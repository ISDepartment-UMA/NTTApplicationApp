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
    [[OSConnectionManager sharedManager]StartConnection:OSCGetSpeculativeApplicationsByDevice];
    
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
    if([statusString isEqualToString:@"To_Be_Processed"])
    
    {NSString *subtitle = [NSString stringWithFormat:@"Date: %@, Status: to be processed", dateString];
        
        NSMutableAttributedString *attributedSubtitle = [[NSMutableAttributedString alloc]initWithString:subtitle];
        int length = [subtitle length];
        [attributedSubtitle addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, length)];
        cell.detailTextLabel.attributedText = attributedSubtitle;
        
    }
    else if([statusString isEqualToString:@"Withdrawn"]){
        NSString *subtitle = [NSString stringWithFormat:@"Date: %@, Status: %@", dateString,statusString];
        int length = [subtitle length];
        NSMutableAttributedString *attributedSubtitle = [[NSMutableAttributedString alloc]initWithString:subtitle];
        [attributedSubtitle addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, length)];
        cell.detailTextLabel.attributedText = attributedSubtitle;
    }
    else {
        cell.detailTextLabel.text =[NSString stringWithFormat:@"Date: %@, Status: %@", dateString,statusString];
    }
    
    cell.detailTextLabel.numberOfLines = 1;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Application* application = [self.data objectAtIndex:indexPath.row];
        application.status = @"withdraw sent";
        application.statusConfirmed = [NSNumber numberWithBool:NO];
        [[DatabaseManager sharedInstance]saveContext];
        
        [[OSConnectionManager sharedManager].searchObject setObject:application.ref_No forKey:@"ref_no"];
        if ([application.ref_No isEqualToString:SPECULATIVE_APPLICATION_REFNO])
        {
            [[OSConnectionManager sharedManager] StartConnection:OSCDeleteSpeculativeApplicaton];
        }
        else
        {
            [[OSConnectionManager sharedManager] StartConnection:OSCSendWithdrawApplication];
        }
        
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
    if (connectionType == OSCGetApplicationsByDevice || connectionType == OSCGetSpeculativeApplicationsByDevice)
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
        if (array)
        {
            if ([array isKindOfClass:[NSDictionary class]])
            {
                NSDictionary* dict = (NSDictionary*)array;
                if ([dict objectForKey:@"withdrawapplication_successful"])
                {
                    Application* application = [[DatabaseManager sharedInstance]getApplicationForRefNo:[dict objectForKey:@"job_ref_no"]];
                    application.status = @"withdrawn";

                    application.statusConfirmed = [NSNumber numberWithBool:YES];
                    [[DatabaseManager sharedInstance]saveContext];
                    [self.tableView reloadData];
                    
                    UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Application has been successfully withdrawn" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [errorMessage show];
                }
            }
        }
    }
}

- (void)connectionFailed:(OSConnectionType)connectionType
{
}
@end
