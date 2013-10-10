//
//  MyApplicationsViewController.m
//  NTT Data Job Application App
//
//  Created by Hilal Yavuz on 10/1/13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "MyApplicationsViewController.h"
#import "OSConnectionManager.h"
#import "DatabaseManager.h"

@interface MyApplicationsViewController() <OSConnectionCompletionDelegate>
@property NSArray *data;

@end

@implementation MyApplicationsViewController

-(void)viewDidLoad
{
    self.data = [[NSArray alloc]init];
}

- (void) viewDidAppear:(BOOL)animated
{
    [OSConnectionManager sharedManager].delegate = self;
    [[OSConnectionManager sharedManager]StartConnection:OSCGetApplicationsByDevice];
    
    [super viewDidAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"My Application";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.accessoryType= UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    
    
    Application* application = [self.data objectAtIndex:indexPath.row];
    
    // Configure the cell...
    cell.userInteractionEnabled = YES;
    cell.textLabel.text = [[DatabaseManager sharedInstance]getOpenPositionForRefNo:application.ref_No].position_name;
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:application.dateApplied
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    NSString *statusString = [application.status capitalizedString];
    
    NSString *subtitle = [NSString stringWithFormat:@"Date: %@, Status: %@", dateString,statusString];
    
    cell.detailTextLabel.numberOfLines = 1;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    cell.detailTextLabel.text = subtitle;

    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Application* application = [self.data objectAtIndex:indexPath.row];
        application.status = @"withdrawn";
        [[DatabaseManager sharedInstance]saveContext];
        
        [[OSConnectionManager sharedManager].searchObject setObject:application.ref_No forKey:@"ref_no"];
        [[OSConnectionManager sharedManager] StartConnection:OSCSendWithdrawApplication];
        
        [self.tableView reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    Application* application = [self.data objectAtIndex:indexPath.row];
    return ![application.status isEqualToString:@"withdrawn"];
}

- (void)connectionSuccess:(OSConnectionType)connectionType withDataInArray:(NSArray *)array
{
    if (connectionType == OSCGetApplicationsByDevice)
    {
        for (id dict in array)
        {
            if ([dict isKindOfClass:[NSString class]])
                if ([dict isEqualToString:@"resultIsEmpty"])
                    return;
        }
        
        [[DatabaseManager sharedInstance]createApplicationsFromJSON:array];
        self.data = [[DatabaseManager sharedInstance]getAllApplicationsForMyDevice];
        [self.tableView reloadData];
    }
    else if(connectionType == OSCSendWithdrawApplication)
    {
    }
}

- (void)connectionFailed:(OSConnectionType)connectionType
{
}
@end
