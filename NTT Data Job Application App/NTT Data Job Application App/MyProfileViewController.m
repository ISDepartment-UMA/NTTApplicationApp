//
//  MyProfileViewController.m
//  NTT Data Job Application App
//
//  Created by Hilal Yavuz on 10/1/13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "MyProfileViewController.h"
#import "DatabaseManager.h"
#import "ProfileValidater.h"
#import "SelectedFilesViewController.h"
#import "OSConnectionManager.h"
#import <DBChooser/DBChooser.h>
#import "JVFloatLabeledTextField.h"
#import "FoundPositionsOverviewViewController.h"

@interface MyProfileViewController ()<UITextFieldDelegate, OSConnectionCompletionDelegate>

@property (weak, nonatomic) IBOutlet UIButton *myApplicationsButton;
@property (weak, nonatomic) IBOutlet UIButton *myFilterSetsButton;
@property (weak, nonatomic) IBOutlet UITextView* freeTextTextView;
@property (weak, nonatomic) IBOutlet UIButton *lastPositionsButton;
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

@implementation MyProfileViewController
@synthesize selectedFiles = _selectedFiles;

- (NSArray*)selectedFiles
{
    if (!_selectedFiles)
        _selectedFiles = [[NSArray alloc]init];
    
    return _selectedFiles;
}



- (void)connectionSuccess:(OSConnectionType)connectionType withDataInArray:(NSArray *)array
{
    if (connectionType == OSCSendSpeculativeApplication)
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    
    CGRect rect=CGRectMake(0.0f,-25,width,height);
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
    //float Y = 20.0f;
    CGRect rect=CGRectMake(0.0f,0,width,height);
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


- (void)loadProfileData
{
    MyProfile* profile = [[DatabaseManager sharedInstance]getMyProfile];
    firstNameField.text = profile.firstName;
    lastNameField.text = profile.lastName;
    emailField.text = profile.email;
    phoneField.text = profile.phoneNo;
    addressField.text = profile.address;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

  
    [self.view setTintColor:[UIColor orangeColor]];
    
    UIColor *floatingLabelColor = [UIColor grayColor];
    
    
    firstNameField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                               CGRectMake(kJVFieldHMargin, 120.0f, 100.0f,  kJVFieldHeight)];
    firstNameField.placeholder = NSLocalizedString(@"First Name", @"");
    firstNameField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    firstNameField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    firstNameField.floatingLabelTextColor = floatingLabelColor;
    firstNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:firstNameField];
    
    
    
    lastNameField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                              CGRectMake(kJVFieldHMargin, 155.0f, 100.0f, kJVFieldHeight)];
    lastNameField.placeholder = NSLocalizedString(@"Last Name", @"");
    lastNameField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    lastNameField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    lastNameField.floatingLabelTextColor = floatingLabelColor;
    [self.view addSubview:lastNameField];
    
    
    addressField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                             CGRectMake(kJVFieldHMargin, 190.0f, 200.0f, kJVFieldHeight)];
    addressField.placeholder = NSLocalizedString(@"Address", @"");
    addressField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    addressField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    addressField.floatingLabelTextColor = floatingLabelColor;
    [self.view addSubview:addressField];
    
    
    emailField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                           CGRectMake(kJVFieldHMargin, 225.0f, 200.0f, kJVFieldHeight)];
    emailField.placeholder = NSLocalizedString(@"Email", @"");
    emailField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    emailField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    emailField.floatingLabelTextColor = floatingLabelColor;
    [self.view addSubview:emailField];

    
    phoneField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                           CGRectMake(kJVFieldHMargin, 260.0f, 200.0f, kJVFieldHeight)];
    phoneField.placeholder = NSLocalizedString(@"Phone Number", @"");
    phoneField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    phoneField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    phoneField.floatingLabelTextColor = floatingLabelColor;
    [self.view addSubview:phoneField];
    
    firstNameField.delegate=self;
    lastNameField.delegate = self;
    emailField.delegate = self;
    addressField.delegate = self;
    phoneField.delegate = self;
    
    
    [firstNameField addTarget:self action:@selector(nextResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    [emailField addTarget:self action:@selector(nextResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    [lastNameField addTarget:self action:@selector(nextResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    [emailField addTarget:self action:@selector(nextResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    [addressField addTarget:self action:@selector(nextResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    [phoneField addTarget:self action:@selector(nextResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self loadProfileData];
    [super viewWillAppear:animated];
}

- (IBAction)sendSpeculativeApplication:(UIButton *)sender
{
    
    BOOL applicationCanBeSent = YES;

    if ([firstNameField.text isEqualToString:@""]||[lastNameField.text isEqualToString:@""]||[addressField.text isEqualToString:@""]||[emailField.text isEqualToString:@""]||[phoneField.text isEqualToString:@""]||[self.freeTextTextView.text isEqualToString:@""])
    {
        UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill in all fields before applying" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [errorMessage show];
        applicationCanBeSent = NO;
    }
    else
    {
        ProfileValidater* validater = [[ProfileValidater alloc]init];
        if (![validater checkIfMailAddressIsValid:emailField.text])
        {
            UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The entered mail address is not valid" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [errorMessage show];
            applicationCanBeSent = NO;
        }
        else
        {
            if (![validater checkIfPhoneNoIsValid:phoneField.text])
            {
                UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The entered phone no. is not valid" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [errorMessage show];
                applicationCanBeSent = NO;
            }
        }
    }
    if (!self.selectedFiles || [self.selectedFiles count] == 0){
        applicationCanBeSent= NO;
    }
    
    if (applicationCanBeSent)
    {
        static NSString* specApp_refNo = @"specApp_NTTData";
        Application* application = [[DatabaseManager sharedInstance]getApplicationForRefNo:specApp_refNo];
        if (!application)
        {
            application = [[DatabaseManager sharedInstance]createApplication];
            application.ref_No =specApp_refNo;
            application.firstName = firstNameField.text;
            application.lastName = lastNameField.text;
            application.address = addressField.text;
            application.email = emailField.text;
            application.phoneNo = phoneField.text;
            application.status = @"to_be_processed"; //to_be_processed,withdrawn
            application.statusConfirmed = [NSNumber numberWithBool:NO];
            application.freeText = self.freeTextTextView.text;
            
            DBChooserResult* dbcr = (DBChooserResult*)[self.selectedFiles lastObject];
            application.sharedLink = [dbcr.link description];
            
            [[DatabaseManager sharedInstance]saveContext];
            
            [[OSConnectionManager sharedManager].searchObject setObject:specApp_refNo forKey:@"ref_no"];
            [[OSConnectionManager sharedManager]StartConnection:OSCSendSpeculativeApplication];
        }
        else
        {
            UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You already applied for this position" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [errorMessage show];
        }
    }

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    FoundPositionsOverviewViewController* overviewVC = (FoundPositionsOverviewViewController*)segue.destinationViewController;
    if([segue.identifier isEqualToString:@"selectDropBoxFile"])
    {
        SelectedFilesViewController* svc = (SelectedFilesViewController*)segue.destinationViewController;
        svc.selectedFiles = self.selectedFiles;
    }
    if ([segue.identifier isEqualToString:@"show3"]) {
        overviewVC.cacheAccess = YES;
    }
}

- (IBAction)phoneNumberEditingFinished:(UITextField *)sender
{
    ProfileValidater* validater = [[ProfileValidater alloc]init];
    if (![validater checkIfPhoneNoIsValid:sender.text])
    {
        UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Ups..." message:@"Please fill in valid phone number" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [errorMessage show];
    }
}

- (IBAction)emailEditingFinished:(UITextField *)sender
{
    ProfileValidater* validater = [[ProfileValidater alloc]init];
    if (![validater checkIfMailAddressIsValid:sender.text])
    {
        UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Ups..." message:@"Please fill in valid email" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [errorMessage show];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    MyProfile* profile = [[DatabaseManager sharedInstance]getMyProfile];
    profile.firstName = firstNameField.text;
    profile.lastName = lastNameField.text;
    profile.address = addressField.text;
    profile.email = emailField.text;
    profile.phoneNo = phoneField.text;
    [[DatabaseManager sharedInstance]saveContext];
    
    [super viewWillDisappear:animated];
}

@end
