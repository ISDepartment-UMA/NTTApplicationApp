//
//  MyFilterSetsViewController.m
//  NTT Data Job Application App
//
//  Created by Hilal Yavuz on 11/2/13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "MyFilterSetsViewController.h"
#import "AppDelegate.h"
#import "FoundPositionsOverviewViewController.h"
#import "Topic.h"
#import "Location.h"
#import "Experience.h"
#import "JobTitle.h"
#import "DatabaseManager.h"

@implementation MyFilterSetsViewController
@synthesize filterSet;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.filterSet = [[DatabaseManager sharedInstance]getAllFilter];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.filterSet count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"filter";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    
    NSString *exp = [self.filterSet[indexPath.row] valueForKey:@"expFilter"];
    NSString *loc = [self.filterSet[indexPath.row] valueForKey:@"locationFilter"];
    NSString *topic = [self.filterSet [indexPath.row] valueForKey:@"topicFilter"];
    NSString *title = [self.filterSet[indexPath.row] valueForKey:@"titleFilter"];
    cell.textLabel.text = [NSString stringWithFormat:@"experience: %@, location: %@, topic: %@, title: %@",exp,loc,topic,title];
    cell.textLabel.numberOfLines = 2 ;
    return cell;
    
}

- (void)connectionSuccess:(OSConnectionType)connectionType withDataInArray:(NSArray *)array
{
    NSLog(@"load success");
    
}
-(void)connectionFailed:(OSConnectionType)connectionType;
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType=UITableViewCellAccessoryCheckmark;
    
    
    NSString *exp = [[self.filterSet[indexPath.row] valueForKey:@"expFilter"]lowercaseString];
    NSString *loc = [[self.filterSet[indexPath.row] valueForKey:@"locationFilter"]lowercaseString];
    NSString *topic = [[self.filterSet [indexPath.row] valueForKey:@"topicFilter"]lowercaseString];
    NSString *title = [[self.filterSet[indexPath.row] valueForKey:@"titleFilter"]lowercaseString];
    
    if (![topic isEqualToString:@""])[[OSConnectionManager sharedManager].searchObject setObject:topic forKey:@"topics"];
    
    
    if (![exp isEqualToString:@""])[[OSConnectionManager sharedManager].searchObject setObject:exp forKey:@"experience"];
    
    
    if (![loc isEqualToString:@""])
        [[OSConnectionManager sharedManager].searchObject setObject:loc forKey:@"location"];
    
    if (![title isEqualToString:@""])
        [[OSConnectionManager sharedManager].searchObject setObject:title forKey:@"jobtitles"];
    
    [OSConnectionManager sharedManager].delegate = self;
    [[OSConnectionManager sharedManager] StartConnection:OSCGetSearch];
    [self performSegueWithIdentifier:@"showJobsFromFilter" sender:self];
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType=UITableViewCellAccessoryNone;
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showJobsFromFilter"]){
        FoundPositionsOverviewViewController* overviewVC = (FoundPositionsOverviewViewController*)segue.destinationViewController;
        [overviewVC startSearchWithType:OSCGetSearch];}
    
    NSLog(@"search is!! %@", [OSConnectionManager sharedManager].searchObject);
    
}





@end
