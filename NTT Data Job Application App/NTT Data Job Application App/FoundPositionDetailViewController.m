//
//  ItemViewController.m
//  NTT Data Job Application App
//
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "FoundPositionDetailViewController.h"
#import "OSAPIManager.h"
#import "OSConnectionManager.h"
#import "JobTitle+Create.h"
#import "Location+Create.h"
#import "Experience+Create.h"
#import "Topic+Create.h"
#import "MessageUI/MessageUI.h"
#import "MessageUI/MFMailComposeViewController.h"

@interface FoundPositionDetailViewController () <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectedTitle;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectedTopic;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectedLocation;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectedExperience;
@property (weak, nonatomic) IBOutlet UILabel *reference;
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UILabel *exp;
@property (weak, nonatomic) IBOutlet UILabel *jobTitle;
@property (weak, nonatomic) IBOutlet UILabel *contact;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UILabel *mainTask;
@property (weak, nonatomic) IBOutlet UILabel *prespective;
@property (weak, nonatomic) IBOutlet UILabel *requirement;
@property (weak, nonatomic) IBOutlet UILabel *result;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (weak, nonatomic) IBOutlet UITextView *mainTaskText;
@property (weak, nonatomic) IBOutlet UITextView *perspectiveText;
@property (weak, nonatomic) IBOutlet UITextView *requirementText;
//@property (strong, nonatomic) NSDictionary *myDictionary;
@end

@implementation FoundPositionDetailViewController

-(void)viewDidAppear:(BOOL)animated
{
    [self loadData];
    self.selectedExperience.title = [Experience getDisplayNameFromDatabaseName:[[OSAPIManager sharedManager].flashObjects objectForKey:@"experience"]];
    [self.selectedExperience setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:7], UITextAttributeFont,nil] forState:UIControlStateNormal];

        
    self.selectedTitle.title = [JobTitle getDisplayNameFromDatabaseName:[[OSAPIManager sharedManager].flashObjects objectForKey:@"jobtitles"]];
    [self.selectedTitle setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:7], UITextAttributeFont,nil] forState:UIControlStateNormal];
    
    self.selectedTopic.title = [Topic getDisplayNameFromDatabaseName:[[OSAPIManager sharedManager].flashObjects objectForKey:@"topics"]];
    [self.selectedTopic setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:7], UITextAttributeFont,nil] forState:UIControlStateNormal];
    self.selectedLocation.title = [Location getDisplayNameFromDatabaseName:[[OSAPIManager sharedManager].flashObjects objectForKey:@"location"]];
    [self.selectedLocation setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:7], UITextAttributeFont,nil] forState:UIControlStateNormal];

   
}

-(void)loadData
{
    self.reference.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"ref_no"];
    
    self.position.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"position_name"];
    
    self.exp.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"exp"];
    self.exp.text = [Experience getDisplayNameFromDatabaseName:[[OSAPIManager sharedManager].searchObject objectForKey:@"exp"]];
    
    self.jobTitle.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"job_title"];
    self.jobTitle.text = [JobTitle getDisplayNameFromDatabaseName:[[OSAPIManager sharedManager].flashObjects objectForKey:@"jobtitles"]];
    
    self.contact.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"contact_person"];
    
    self.email.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"email"];
    if (self.email.text && ![self.email.text isEqualToString:@"none"])
    {
        UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mailLabelClicked)];
        [self.email setUserInteractionEnabled:YES];
        [self.email addGestureRecognizer:recognizer];
    }
    
    self.phone.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"phone_no"];
    if (self.phone.text && ![self.phone.text isEqualToString:@"none"])
    {
        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(phoneLabelClicked)];
        [self.phone setUserInteractionEnabled:YES];
        [self.phone addGestureRecognizer:gesture];
    }
    
    //self.description.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"job_description"];
    self.descriptionText.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"job_description"];
    
    self.mainTaskText.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"main_tasks"];
    //self.mainTask.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"main_tasks"];
    
    self.perspectiveText.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"perspective"];
    //self.prespective.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"perspective"];
    
    self.requirementText.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"job_requirements"];
    //self.requirement.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"job_requirements"];
    
    self.result.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"our_offer"];
    
    [self.scrollView setContentSize:CGSizeMake(320, 950)];
}

- (void) phoneLabelClicked
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString: [NSString stringWithFormat:@"tel:%@", [self.phone.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
    }
}

- (void) mailLabelClicked
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController* mailViewController = [[MFMailComposeViewController alloc]init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:[NSString stringWithFormat:@"Application for position: %@ %@", self.position.text, self.reference.text]];
        
        NSString *trimmed = [self.email.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        [mailViewController setToRecipients:@[trimmed]];
        
        [self presentViewController:mailViewController animated:YES completion:NULL];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

@end
