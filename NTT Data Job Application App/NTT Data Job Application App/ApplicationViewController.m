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

@interface ApplicationViewController ()< UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *jobInfo;

@property (weak, nonatomic) IBOutlet UILabel *responseLabel;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@end

@implementation ApplicationViewController
@synthesize openPosition;

- (IBAction)cancel:(UIButton *)sender {
    self.firstName.text=@"";
    self.lastName.text =@"";
    self.address.text = @"";
    self.email.text=@"";
    self.phoneNumber.text =@"";
    self.responseLabel.text = @"";
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
{   [self.firstName resignFirstResponder];
    [self.lastName resignFirstResponder];
    [self.address resignFirstResponder];
    [self.email resignFirstResponder];
    [self.phoneNumber resignFirstResponder];
    [self resumeView];
}
-(IBAction)nextOnKeyboard:(UITextField *)sender
{
    if (sender == self.firstName) {
        [self.lastName becomeFirstResponder];}
    else if (sender == self.lastName){
        [self.address becomeFirstResponder];
    }
    else if (sender == self.address){
        [self.email becomeFirstResponder];
    }
    else if (sender == self.email)
    {
        [self.phoneNumber becomeFirstResponder];
        
    }
    else if (sender == self.phoneNumber){
        [self hidenKeyboard];
    }
    
}

- (IBAction)sendApplication:(UIButton *)sender {
    self.responseLabel.hidden = NO;
    
    if (((self.sendButton.enabled= YES) && [self.firstName.text isEqualToString:@""]) ||  ((self.sendButton.enabled= YES) && [self.lastName.text isEqualToString:@""])|| ((self.sendButton.enabled= YES) && [self.address.text isEqualToString:@""]) || ((self.sendButton.enabled= YES) && [self.email.text isEqualToString:@""]) || ((self.sendButton.enabled= YES) && [self.phoneNumber.text isEqualToString:@""]))
    {
        UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Ups..." message:@"Please fill in all fields" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [errorMessage show];
        
        self.responseLabel.hidden = YES;
    }
    else{
        if ([self.email.text rangeOfString:@"@"].location == NSNotFound){
            UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Ups..." message:@"Please fill in valid email" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [errorMessage show];
            
            self.responseLabel.hidden = YES;
        }
        else{
            NSCharacterSet *notdigital = [[NSCharacterSet decimalDigitCharacterSet]invertedSet];
            if ([self.phoneNumber.text rangeOfCharacterFromSet:notdigital].location !=NSNotFound){
                
                    UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Ups..." message:@"Please fill in valid phone number" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [errorMessage show];
                    
                    self.responseLabel.hidden = YES;
                
            }
            
        }        

    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.responseLabel.hidden = YES;
    self.jobInfo.dataSource = self;
    self.jobInfo.delegate = self;
	// Do any additional setup after loading the view.
    [super viewDidLoad];
    
    self.firstName.delegate=self;
    self.lastName.delegate = self;
    self.email.delegate = self;
    self.address.delegate = self;
    self.phoneNumber.delegate = self;
   
    self.firstName.returnKeyType = UIReturnKeyNext;
    self.lastName.returnKeyType = UIReturnKeyNext;
    self.email.returnKeyType = UIReturnKeyNext;
    self.address.returnKeyType = UIReturnKeyNext;
    self.phoneNumber.returnKeyType = UIReturnKeyDefault;
    
    
    [self.firstName addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.email addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.lastName addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.email addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.address addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.phoneNumber addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
    [self setupProfile];
}

- (void) viewWillDisappear:(BOOL)animated
{
    MyProfile* profile = [[DatabaseManager sharedInstance]getMyProfile];
    profile.firstName = self.firstName.text;
    profile.lastName = self.lastName.text;
    profile.email = self.email.text;
    profile.address = self.address.text;
    profile.phoneNo = self.phoneNumber.text;
    [[DatabaseManager sharedInstance]saveContext];
    
    [super viewWillDisappear:animated];
}

- (void) setupProfile
{
    MyProfile* profile = [[DatabaseManager sharedInstance]getMyProfile];
    self.firstName.text = profile.firstName;
    self.lastName.text = profile.lastName;
    self.email.text = profile.email;
    self.phoneNumber.text = profile.phoneNo;
    self.address.text = profile.address;
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
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.text = [self titleForRow:indexPath.row];
    
    
    NSString *subtitle = [NSString stringWithFormat:@"Job Title: %@, Location: %@\nReferenceID: %@", [self jobTitleForRow:indexPath.row],[self locationForRow:indexPath.row], [self refNoForRow:indexPath.row]];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.text = subtitle;
    
    return cell;
}


@end
