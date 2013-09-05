//
//  ItemViewController.m
//  NTT Data Job Application App
//
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "FoundPositionDetailViewController.h"

@interface FoundPositionDetailViewController ()

@end

@implementation FoundPositionDetailViewController

-(void)viewDidAppear:(BOOL)animated
{
    [self loadData];
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
    self.description.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"job_description"];
    self.mainTask.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"main_tasks"];
    self.prespective.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"perspective"];
    self.requirement.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"job_requirements"];
    self.result.text = [[OSAPIManager sharedManager].searchObject objectForKey:@"our_offer"];
    [self.scrollView setContentSize:CGSizeMake(320, 950)];
}

@end
