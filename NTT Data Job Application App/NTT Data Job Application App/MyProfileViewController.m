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

@interface MyProfileViewController ()<UITextFieldDelegate, OSConnectionCompletionDelegate>
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *myApplicationsButton;
@property (weak, nonatomic) IBOutlet UIButton *myFilterSetsButton;
@property (weak, nonatomic) IBOutlet UITextView* freeTextTextView;
@property (weak, nonatomic) IBOutlet UIButton *lastPositionsButton;

@end

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
    }}

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

- (void)loadProfileData
{
    MyProfile* profile = [[DatabaseManager sharedInstance]getMyProfile];
    self.firstName.text = profile.firstName;
    self.lastName.text = profile.lastName;
    self.email.text = profile.email;
    self.phoneNumber.text = profile.phoneNo;
    self.address.text = profile.address;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    self.firstName.delegate=self;
    self.lastName.delegate = self;
    self.email.delegate = self;
    self.address.delegate = self;
    self.phoneNumber.delegate = self;
    
    [self.firstName addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.email addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.lastName addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.email addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.address addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.phoneNumber addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
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

    if ([self.firstName.text isEqualToString:@""]||[self.lastName.text isEqualToString:@""]||[self.address.text isEqualToString:@""]||[self.email.text isEqualToString:@""]||[self.phoneNumber.text isEqualToString:@""]||[self.freeTextTextView.text isEqualToString:@""])
    {
        UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill in all fields before applying" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [errorMessage show];
        applicationCanBeSent = NO;
    }
    else
    {
        ProfileValidater* validater = [[ProfileValidater alloc]init];
        if (![validater checkIfMailAddressIsValid:self.email.text])
        {
            UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The entered mail address is not valid" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [errorMessage show];
            applicationCanBeSent = NO;
        }
        else
        {
            if (![validater checkIfPhoneNoIsValid:self.phoneNumber.text])
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
            application.firstName = self.firstName.text;
            application.lastName = self.lastName.text;
            application.address = self.address.text;
            application.email = self.email.text;
            application.phoneNo = self.phoneNumber.text;
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
    if([segue.identifier isEqualToString:@"selectDropBoxFile"])
    {
        SelectedFilesViewController* svc = (SelectedFilesViewController*)segue.destinationViewController;
        svc.selectedFiles = self.selectedFiles;
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
    profile.firstName = self.firstName.text;
    profile.lastName = self.lastName.text;
    profile.address = self.address.text;
    profile.email = self.email.text;
    profile.phoneNo = self.phoneNumber.text;
    [[DatabaseManager sharedInstance]saveContext];
    
    [super viewWillDisappear:animated];
}

@end
