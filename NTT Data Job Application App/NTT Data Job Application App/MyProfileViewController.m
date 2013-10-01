//
//  MyProfileViewController.m
//  NTT Data Job Application App
//
//  Created by Hilal Yavuz on 10/1/13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "MyProfileViewController.h"

@interface MyProfileViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *myApplicationsButton;
@end

@implementation MyProfileViewController

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

@end
