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

@interface FoundPositionDetailViewController ()
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
    self.jobTitle.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"job_title"];
    self.contact.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"contact_person"];
    self.email.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"email"];
    self.phone.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"phone_no"];
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

@end
