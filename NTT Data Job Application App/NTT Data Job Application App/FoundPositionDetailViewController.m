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
@property (weak, nonatomic) IBOutlet UIButton *filterSetSaveButton;
@property (nonatomic, retain)NSManagedObjectContext* managedObjectContext;

@end

@implementation FoundPositionDetailViewController
@synthesize openPosition;



-(void)viewDidAppear:(BOOL)animated
{
    [self loadData];
    [self loadSelectedFilters];
    [self synchronizewith:self.openPosition];
}

- (void)loadSelectedFilters
{
    NSString *contentExperience = [[DatabaseManager sharedInstance]getExperienceDisplayNameFromDatabaseName:[[OSConnectionManager sharedManager].searchObject objectForKey:@"experience"]];
    NSString *contentJobTitle = [[DatabaseManager sharedInstance]getJobTitleDisplayNameFromDatabaseName:[[OSConnectionManager sharedManager].searchObject objectForKey:@"jobtitles"]];
    NSString *contentTopic = [[DatabaseManager sharedInstance]getTopicDisplayNameFromDatabaseName:[[OSConnectionManager sharedManager].searchObject objectForKey:@"topics"]];
    NSString *contentLocation = [[DatabaseManager sharedInstance]getLocationDisplayNameFromDatabaseName:[[OSConnectionManager sharedManager].searchObject objectForKey:@"location"]];
    
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
    
    if (self.freeText)
        content = self.freeText;
    
    self.displaySelectedFilters.numberOfLines =3;
    self.displaySelectedFilters.text = content;
    
    if ([self.displaySelectedFilters.text isEqualToString:@""]) {
        [self.filterSetSaveButton removeFromSuperview];
    }
}
#define VIEWED_POSITIONS_KEY @"ViewedPositions"
-(void) synchronizewith: (NSDictionary *) selectedPosition{
    NSMutableArray *accessedPositions = [[[NSUserDefaults  standardUserDefaults] arrayForKey:VIEWED_POSITIONS_KEY] mutableCopy];
    if (!accessedPositions) {
        accessedPositions= [[NSMutableArray alloc] init];
    }
    //NSLog(@"start");
    //NSLog([NSString stringWithFormat:@"%d",accessedPositions.count]);
    
    if ([accessedPositions containsObject:selectedPosition]) {
        [accessedPositions removeObject:selectedPosition];
    }
    
    
    //[accessedPhotos removeObjectAtIndex:0];
    
    [accessedPositions addObject:selectedPosition];
    if (accessedPositions.count > 3) {
        [accessedPositions removeObjectAtIndex:0];
    }
    [[NSUserDefaults standardUserDefaults] setObject:accessedPositions forKey:VIEWED_POSITIONS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    /*NSMutableArray *accessedPhotos = [[[NSUserDefaults  standardUserDefaults] arrayForKey:ALL_PHOTOS_KEY] mutableCopy];
     if (!accessedPhotos) {
     accessedPhotos = [[NSMutableArray alloc] init];
     }
     [accessedPhotos addObject:selectedPhoto];
     [[NSUserDefaults standardUserDefaults] setObject:accessedPhotos forKey:ALL_PHOTOS_KEY];
     [[NSUserDefaults standardUserDefaults] synchronize];*/
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
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
        SLComposeViewController *twittersheet = [[SLComposeViewController alloc] init];
        
        twittersheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [twittersheet setInitialText:[NSString stringWithFormat:@"#NTT_DATA #open_position %@ \n%@	",[self.openPosition objectForKey:@"position_name"],[self.openPosition objectForKey:@"url"]]];
        [self presentViewController:twittersheet animated:YES completion:nil];
        
        
    }else
    {   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Service not Available" message:@"Sorry ! Twitter service not available" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
    }
}

- (IBAction)saveFilterSets:(UIButton *)sender {    
   
    if (self.freeText){
        [[DatabaseManager sharedInstance]storeFilter:nil:nil :nil :nil :nil :self.freeText];       
        
    }else
    
     [[OSConnectionManager sharedManager]StartConnection:OSCSendFilterSet];
    
    
    

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Your filters are saved!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [alertView show];
}

- (IBAction)socialFB:(id)sender
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
                    SLComposeViewController *facebooksheet = [[SLComposeViewController alloc] init];
        
                    facebooksheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
                    [facebooksheet setInitialText:[NSString stringWithFormat:@"NTT Data open posistion : %@ \nIf your interested check the line below: \n%@",[self.openPosition objectForKey:@"position_name"],[self.openPosition objectForKey:@"url"]]];
                    [self presentViewController:facebooksheet animated:YES completion:nil];
        
        
                }	else
               {   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Service not Available" message:@"Sorry ! Facebook service not available" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                   [alertView show];
                }
    
}

    @end;








