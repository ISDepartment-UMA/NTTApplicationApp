//
//  ApplicationViewController.m
//  NTT Data Job Application App
//
//  Created by Pavel Kurasov on 20.09.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "ApplicationViewController.h"
#import "DatabaseManager.h"
#import "OSConnectionManager.h"
#import "ProfileValidater.h"
#import "SelectedFilesViewController.h"
#import <DBChooser/DBChooser.h>
#import <DropboxSDK/DropboxSDK.h>
#import "JVFloatLabeledTextField.h"

@interface ApplicationViewController ()< UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate, OSConnectionCompletionDelegate>

@property (weak, nonatomic) IBOutlet UITableView *jobInfo;
@property (weak, nonatomic) IBOutlet UILabel *responseLabel;
@property (weak, nonatomic) IBOutlet UIButton *dropBoxButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UILabel *errorDisplay;
@end

const static CGFloat kJVFieldHeight = 30.0f;
const static CGFloat kJVFieldHMargin = 20.0f;
const static CGFloat kJVFieldFontSize = 14.0f;
const static CGFloat kJVFieldFloatingLabelFontSize = 11.0f;

JVFloatLabeledTextField *firstNameField;
JVFloatLabeledTextField *lastNameField;
JVFloatLabeledTextField *addressField;
JVFloatLabeledTextField *emailField;
JVFloatLabeledTextField *phoneField;

@implementation ApplicationViewController
@synthesize openPosition;
@synthesize selectedFiles;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"selectDropBoxFile"])
    {
        SelectedFilesViewController* svc = (SelectedFilesViewController*)segue.destinationViewController;
        svc.selectedFiles = self.selectedFiles;
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    
    CGRect rect=CGRectMake(0.0f,-100,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES;
}

-(void)resumeView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    
    float Y = 20.0f;
    CGRect rect=CGRectMake(0.0f,Y,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}

-(void)hidenKeyboard
{   [firstNameField resignFirstResponder];
    [lastNameField resignFirstResponder];
    [addressField resignFirstResponder];
    [emailField resignFirstResponder];
    [phoneField resignFirstResponder];
    [self resumeView];
}


- (IBAction)sendApplication:(UIButton *)sender
{
    BOOL applicationCanBeSent = YES;
    self.responseLabel.hidden = NO;
    self.errorDisplay.hidden = YES;
    if ((self.sendButton.enabled==YES)&&([firstNameField.text isEqualToString:@""]||[lastNameField.text isEqualToString:@""]||[addressField.text isEqualToString:@""]||[emailField.text isEqualToString:@""]||[phoneField.text isEqualToString:@""]))
    {
        self.responseLabel.hidden = YES;
        self.errorDisplay.hidden = NO;
        applicationCanBeSent = NO;
    }
    else
    {
        ProfileValidater* validater = [[ProfileValidater alloc]init];
        if (![validater checkIfMailAddressIsValid:emailField.text])
        {
            self.responseLabel.hidden = YES;
            self.errorDisplay.hidden = NO;
            applicationCanBeSent = NO;
        }
        else
        {
            if (![validater checkIfPhoneNoIsValid:phoneField.text])
            {
                self.responseLabel.hidden = YES;
                self.errorDisplay.hidden = NO;
                applicationCanBeSent = NO;
            }
        }
    }
    if (!self.selectedFiles || [selectedFiles count] == 0){
        self.responseLabel.hidden = YES;
        self.errorDisplay.hidden = YES;
        applicationCanBeSent= NO;
        self.responseLabel.hidden = NO;
        self.responseLabel.text = @"Please select application files";
    }
    
    if (applicationCanBeSent)
    {
        
        Application* application = [[DatabaseManager sharedInstance]getApplicationForRefNo:[self.openPosition objectForKey:@"ref_no"]];
        if (!application)
        {
            OpenPosition* openPosition1 = [[DatabaseManager sharedInstance]createOpenPosition];
            openPosition1.ref_no = [openPosition objectForKey:@"ref_no"];
            openPosition1.position_name =[openPosition objectForKey:@"position_name"];
            [[DatabaseManager sharedInstance] saveContext];
            application = [[DatabaseManager sharedInstance]createApplication];
            application.ref_No =[openPosition objectForKey:@"ref_no"];
            application.firstName = firstNameField.text;
            application.lastName = lastNameField.text;
            application.address = addressField.text;
            application.email = emailField.text;
            application.phoneNo = phoneField.text;
            application.status = @"to_be_processed"; //to_be_processed,withdrawn
            application.statusConfirmed = [NSNumber numberWithBool:NO];
            
            DBChooserResult* dbcr = (DBChooserResult*)[self.selectedFiles lastObject];
            application.sharedLink = [dbcr.link description];
            
            [[DatabaseManager sharedInstance]saveContext];
            
            [[OSConnectionManager sharedManager].searchObject setObject:[openPosition objectForKey:@"ref_no"]forKey:@"ref_no"];
            [[OSConnectionManager sharedManager]StartConnection:OSCSendApplication];
        }else
        {
            UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You already applied for this position" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [errorMessage show];
        }
        [self updateProfile];
        
    }
}
- (void)connectionSuccess:(OSConnectionType)connectionType withDataInArray:(NSArray *)array
{
    if (connectionType == OSCSendApplication)
    {
        NSLog(@"%@", array);
        
        NSDictionary* dict = (NSDictionary*)array;
        Application* application = [[DatabaseManager sharedInstance]getApplicationForRefNo: [dict objectForKey:@"job_ref_no"]];
        if ([application.deviceID isEqualToString:[dict objectForKey:@"device_id"]] && [dict objectForKey:@"applyingJob_successful"])
        {
            application.statusConfirmed = [NSNumber numberWithBool:YES];
            [[DatabaseManager sharedInstance]saveContext];
            
            UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Application has been successfully sent to NTT Data" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [errorMessage show];
        }
    }
}

- (void)connectionFailed:(OSConnectionType)connectionType
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setTintColor:[UIColor orangeColor]];
    
    UIColor *floatingLabelColor = [UIColor grayColor];
    
    
    firstNameField = [[JVFloatLabeledTextField alloc] initWithFrame:
                      CGRectMake(kJVFieldHMargin, 210.0f, 100.0f,  kJVFieldHeight)];
    firstNameField.placeholder = NSLocalizedString(@"First Name", @"");
    firstNameField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    firstNameField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    firstNameField.floatingLabelTextColor = floatingLabelColor;
    firstNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:firstNameField];
    
    
    
    lastNameField = [[JVFloatLabeledTextField alloc] initWithFrame:
                     CGRectMake(kJVFieldHMargin, 245.0f, 100.0f, kJVFieldHeight)];
    lastNameField.placeholder = NSLocalizedString(@"Last Name", @"");
    lastNameField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    lastNameField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    lastNameField.floatingLabelTextColor = floatingLabelColor;
    [self.view addSubview:lastNameField];
    
    
    addressField = [[JVFloatLabeledTextField alloc] initWithFrame:
                    CGRectMake(kJVFieldHMargin, 280.0f, 200.0f, kJVFieldHeight)];
    addressField.placeholder = NSLocalizedString(@"Address", @"");
    addressField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    addressField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    addressField.floatingLabelTextColor = floatingLabelColor;
    [self.view addSubview:addressField];
    
    
    emailField = [[JVFloatLabeledTextField alloc] initWithFrame:
                  CGRectMake(kJVFieldHMargin, 315.0f, 200.0f, kJVFieldHeight)];
    emailField.placeholder = NSLocalizedString(@"Email", @"");
    emailField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    emailField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    emailField.floatingLabelTextColor = floatingLabelColor;
    [self.view addSubview:emailField];
    
    
    phoneField = [[JVFloatLabeledTextField alloc] initWithFrame:
                  CGRectMake(kJVFieldHMargin, 350.0f, 200.0f, kJVFieldHeight)];
    phoneField.placeholder = NSLocalizedString(@"Phone Number", @"");
    phoneField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    phoneField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    phoneField.floatingLabelTextColor = floatingLabelColor;
    [self.view addSubview:phoneField];

    
    self.responseLabel.hidden = YES;
    self.errorDisplay.hidden = YES;
    self.jobInfo.dataSource = self;
    self.jobInfo.delegate = self;
   	// Do any additional setup after loading the view.
    [super viewDidLoad];
    
    firstNameField.delegate=self;
    lastNameField.delegate = self;
    emailField.delegate = self;
    addressField.delegate = self;
    phoneField.delegate = self;
    [OSConnectionManager sharedManager].delegate = self;
    
    firstNameField.returnKeyType = UIReturnKeyNext;
    lastNameField.returnKeyType = UIReturnKeyNext;
    emailField.returnKeyType = UIReturnKeyNext;
    addressField.returnKeyType = UIReturnKeyNext;
    phoneField.returnKeyType = UIReturnKeyDefault;
    
    
    [firstNameField addTarget:self action:@selector(nextResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    [emailField addTarget:self action:@selector(nextResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    [lastNameField addTarget:self action:@selector(nextResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    [emailField addTarget:self action:@selector(nextResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    [addressField addTarget:self action:@selector(nextResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    [phoneField addTarget:self action:@selector(nextResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
    [self setupProfile];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self updateProfile];
    [super viewWillDisappear:animated];
}

- (void) setupProfile
{
    MyProfile* profile = [[DatabaseManager sharedInstance]getMyProfile];
    firstNameField.text = profile.firstName;
    lastNameField.text = profile.lastName;
    emailField.text = profile.email;
    phoneField.text = profile.phoneNo;
    addressField.text = profile.address;
}

- (void)updateProfile
{
    MyProfile* profile = [[DatabaseManager sharedInstance]getMyProfile];
    profile.firstName = firstNameField.text;
    profile.lastName = lastNameField.text;
    profile.email = emailField.text;
    profile.address = addressField.text;
    profile.phoneNo = phoneField.text;
    [[DatabaseManager sharedInstance]saveContext];
}

#pragma mark - Supplemental methods for row creation
- (NSString *)titleForRow:(NSUInteger)row
{
    return [self.openPosition objectForKey:@"position_name"];;
}

- (NSString *)jobTitleForRow:(NSUInteger)row
{
    return [[DatabaseManager sharedInstance]getJobTitleDisplayNameFromDatabaseName:[self.openPosition objectForKey:@"job_title"]];
}

- (NSString *)locationForRow:(NSUInteger)row
{
    return [[DatabaseManager sharedInstance]getLocationDisplayNameFromDatabaseName:[self.openPosition objectForKey:@"location1"]];;
}

- (NSString *)refNoForRow:(NSUInteger)row
{
    return [self.openPosition objectForKey:@"ref_no"];
}


#pragma mark - UITableViewDataSource
// lets the UITableView know how many rows it should display
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// loads up a table view cell with the search criteria at the given row in the Model
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"JobInfo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.accessoryType= UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
    cell.textLabel.textColor = [UIColor orangeColor];
    cell.textLabel.numberOfLines = 3;
    cell.textLabel.text = [self titleForRow:indexPath.row];
    
    
    NSString *subtitle = [NSString stringWithFormat:@"Job Title: %@, Location: %@\nReferenceID: %@", [self jobTitleForRow:indexPath.row],[self locationForRow:indexPath.row], [self refNoForRow:indexPath.row]];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    cell.detailTextLabel.numberOfLines = 3;
    cell.detailTextLabel.text = subtitle;
    
    return cell;
}
@end
