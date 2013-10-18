//
//  ItemViewController.m
//  NTT Data Job Application App
//
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "FoundPositionDetailViewController.h"
#import "OSConnectionManager.h"
#import "MessageUI/MessageUI.h"
#import "MessageUI/MFMailComposeViewController.h"
#import "DatabaseManager.h"

@interface FoundPositionDetailViewController () <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *displaySelectedFilters;
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
@end

@implementation FoundPositionDetailViewController
@synthesize openPosition;

-(void)viewDidAppear:(BOOL)animated
{
    [self loadData];
    [self loadSelectedFilters];
}

- (void)loadSelectedFilters
{
    NSString *contentExperience = [[DatabaseManager sharedInstance]getExperienceDisplayNameFromDatabaseName:[self.openPosition objectForKey:@"experience"]];
    NSString *contentJobTitle = [[DatabaseManager sharedInstance]getJobTitleDisplayNameFromDatabaseName:[self.openPosition objectForKey:@"jobtitles"]];
    NSString *contentTopic = [[DatabaseManager sharedInstance]getTopicDisplayNameFromDatabaseName:[self.openPosition objectForKey:@"topics"]];
    NSString *contentLocation = [[DatabaseManager sharedInstance]getLocationDisplayNameFromDatabaseName:[self.openPosition objectForKey:@"location"]];
    
    NSString* content = [[NSString alloc]init];
    if (contentExperience && contentExperience.length > 0)
    {
        content = [content stringByAppendingString:contentExperience];
    }
    
    if (contentJobTitle && contentJobTitle.length > 0)
    {
        if (content.length > 0)
            content = [content stringByAppendingString:[NSString stringWithFormat:@", %@", contentJobTitle]];
        else
            content = [content stringByAppendingString:contentJobTitle];
    }
    
    if (contentLocation && contentLocation.length > 0)
    {
        if (content.length > 0)
            content = [content stringByAppendingString:[NSString stringWithFormat:@", %@", contentLocation]];
        else
            content = [content stringByAppendingString:contentLocation];
    }
    
    if (contentTopic && contentTopic.length > 0)
    {
        if (content.length > 0)
            content = [content stringByAppendingString:[NSString stringWithFormat:@", %@", contentTopic]];
        else
            content = [content stringByAppendingString:contentTopic];
    }
    
    if (self.freeText != NULL) {
        content = self.freeText;
    }
    
    self.displaySelectedFilters.text = content;
}
    

-(void)loadData
{
    self.reference.text = [self.openPosition objectForKey:@"ref_no"];
    self.position.text = [self.openPosition objectForKey:@"position_name"];
    self.position.numberOfLines = 3;
    self.exp.text = [[DatabaseManager sharedInstance]getExperienceDisplayNameFromDatabaseName: [self.openPosition objectForKey:@"exp"]];
    self.jobTitle.text = [[DatabaseManager sharedInstance]getJobTitleDisplayNameFromDatabaseName: [self.openPosition objectForKey:@"job_title"]];
    self.contact.text = [self.openPosition objectForKey:@"contact_person"];
    self.email.text = [self.openPosition objectForKey:@"email"];

    if (self.email.text && ![self.email.text isEqualToString:@"none"])
    {
        UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mailLabelClicked)];
        [self.email setUserInteractionEnabled:YES];
        [self.email addGestureRecognizer:recognizer];
    }
    
    self.phone.text = [self.openPosition objectForKey:@"phone_no"];
    if (self.phone.text && ![self.phone.text isEqualToString:@"none"])
    {
        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(phoneLabelClicked)];
        [self.phone setUserInteractionEnabled:YES];
  
        [self.phone addGestureRecognizer:gesture];
    }
    

    self.descriptionText.text = [self.openPosition objectForKey:@"job_description"];
    self.mainTaskText.text = [self.openPosition objectForKey:@"main_tasks"];
    self.perspectiveText.text = [self.openPosition objectForKey:@"perspective"];
    self.requirementText.text = [self.openPosition objectForKey:@"job_requirements"];
    
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width,1500)];
    [self.scrollView setScrollEnabled:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"apply"])
        if ([segue.destinationViewController respondsToSelector:@selector(setOpenPosition:)])
            [segue.destinationViewController performSelector:@selector(setOpenPosition:) withObject:self.openPosition];
        
    
}

- (IBAction)apply:(id)sender
{
    [self performSegueWithIdentifier:@"apply" sender:self];
}

#pragma mark - Phone and Mail capabilities
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
#pragma mark - posting on social media 

- (IBAction)social:(id)sender
{
    UIActionSheet *share = [[UIActionSheet alloc]initWithTitle:@"sharing" delegate:self cancelButtonTitle:@"ok" destructiveButtonTitle:nil otherButtonTitles:@"Facebook it!",@"Twiter it!", nil];
    [share showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 0) {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
            SLComposeViewController *tweetsheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [tweetsheet setInitialText:[NSString stringWithFormat:@"%@",[self.openPosition objectForKey:@"position_name"]]];
            [self presentViewController:tweetsheet animated:YES completion:nil];
            
            
        }else
        {   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Service not Available" message:@"Sorry ! Facebook service not available" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
        }
        
        
    }else if (actionSheet.tag == 1)
     {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
            SLComposeViewController *facebooksheet = [SLComposeViewController  composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            [facebooksheet setInitialText:[NSString stringWithFormat:@"#NTT_DATA #open_position %@",[self.openPosition objectForKey:@"position_name"]]];
            [self presentViewController:facebooksheet animated:YES completion:nil];
            
            
        }	else
        {   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Service not Available" message:@"Sorry ! Twiter service not available" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
        }
    }
}
@end








