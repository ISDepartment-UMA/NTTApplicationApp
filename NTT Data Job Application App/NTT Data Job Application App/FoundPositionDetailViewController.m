//
//  ItemViewController.m
//  NTT Data Job Application App
//
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "FoundPositionDetailViewController.h"
#import "OSAPIManager.h"
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

-(void)viewDidAppear:(BOOL)animated
{
    
    [self loadData];
    [self loadSelectedFilters];
    
}

                           
- (void)loadSelectedFilters
{
    
    NSString *contentExperience = [[DatabaseManager sharedInstance]getExperienceDisplayNameFromDatabaseName:[[OSAPIManager sharedManager].flashObjects objectForKey:@"experience"]];
    NSString *contentJobTitle = [[DatabaseManager sharedInstance]getJobTitleDisplayNameFromDatabaseName:[[OSAPIManager sharedManager].flashObjects objectForKey:@"jobtitles"]];
    NSString *contentTopic = [[DatabaseManager sharedInstance]getTopicDisplayNameFromDatabaseName:[[OSAPIManager sharedManager].flashObjects objectForKey:@"topics"]];
    NSString *contentLocation = [[DatabaseManager sharedInstance]getLocationDisplayNameFromDatabaseName:[[OSAPIManager sharedManager].flashObjects objectForKey:@"location"]];
    
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
    
    self.displaySelectedFilters.text = content;
}
    

-(void)loadData
{
    self.reference.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"ref_no"];
    self.position.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"position_name"];
    self.exp.text = [[DatabaseManager sharedInstance]getExperienceDisplayNameFromDatabaseName: [[OSAPIManager sharedManager].searchObject objectForKey:@"exp"]];
    self.jobTitle.text = [[DatabaseManager sharedInstance]getJobTitleDisplayNameFromDatabaseName: [[OSAPIManager sharedManager].searchObject objectForKey:@"job_title"]];
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
    

    self.descriptionText.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"job_description"];
    self.mainTaskText.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"main_tasks"];
    self.perspectiveText.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"perspective"];
    self.requirementText.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"job_requirements"];
    self.result.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"our_offer"];
    
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    [self.scrollView setScrollEnabled:YES];

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

@end
