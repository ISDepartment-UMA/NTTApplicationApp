//
//  MyFilterSetsViewController.m
//  NTT Data Job Application App
//
//  Created by Hilal Yavuz on 11/2/13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "MyFilterSetsViewController.h"
#import "FoundPositionsOverviewViewController.h"
#import "DatabaseManager.h"
#import "Filter.h"

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
    NSString *freeText = [self.filterSet [indexPath.row ]valueForKey:@"freeTextFilter"];
    if (!freeText)
    cell.textLabel.text = [NSString stringWithFormat:@"experience: %@, location: %@, topic: %@, title: %@",exp,loc,topic,title];
    else cell.textLabel.text = [NSString stringWithFormat:@"Key words: %@",freeText];
    cell.textLabel.numberOfLines = 2 ;
    return cell;
    
}

- (void)connectionSuccess:(OSConnectionType)connectionType withDataInArray:(NSArray *)array
{
    NSLog(@"load success");
    
}
-(void)connectionFailed:(OSConnectionType)connectionType;
{
    NSLog(@"fail");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType=UITableViewCellAccessoryCheckmark;
    NSString *freeText = [self.filterSet [indexPath.row ]valueForKey:@"freeTextFilter"];
    
    if (!freeText){
    
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
    else
    {
        [OSConnectionManager sharedManager].delegate = self;
        [[OSConnectionManager sharedManager].searchObject setObject:freeText forKey:@"freeText"];
        [[OSConnectionManager sharedManager] StartConnection:OSCGetFreeTextSearch];
        [self performSegueWithIdentifier:@"showJobsFromFreeTextFilter" sender:self];
        
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType=UITableViewCellAccessoryNone;
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{      FoundPositionsOverviewViewController* overviewVC = (FoundPositionsOverviewViewController*)segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"showJobsFromFilter"]){
        ;       
        [overviewVC startSearchWithType:OSCGetSearch];
    }
    if ( [segue.identifier isEqualToString:@"showJobsFromFreeTextFilter"])
    {
        [overviewVC startSearchWithType:OSCGetFreeTextSearch];
    }    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {        
        // delete object in database
        [[DatabaseManager sharedInstance]deleteFilter:[self.filterSet objectAtIndex:indexPath.row]];
        Filter *filter = [self.filterSet objectAtIndex:indexPath.row];
        if (!filter.freeTextFilter){
        [[OSConnectionManager sharedManager].searchObject setObject:filter.uuid forKey:@"uuid"];
            [[OSConnectionManager sharedManager]StartConnection:OSCSendDeleteFilterSet];}
        [self viewDidLoad];
        [tableView reloadData];
    }
}




@end
