//
//  MyApplicationsViewController.m
//  NTT Data Job Application App
//
//  Created by Hilal Yavuz on 10/1/13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "MyApplicationsViewController.h"

@interface MyApplicationsViewController()
@property NSMutableArray *data;

@end
@implementation MyApplicationsViewController

-(void)viewDidLoad{
    self.data = [[NSMutableArray alloc] initWithObjects:@"Application 1",@" Application 2", @" Application 3", nil];
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
    
 
        // Configure the cell...
        cell.userInteractionEnabled = YES;
        cell.textLabel.text = self.data [indexPath.row];
        
    
  
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.data removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
    
}

@end
