//
//  SelectedFilesViewController.m
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 26.10.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "SelectedFilesViewController.h"
#import <DBChooser/DBChooser.h>
#import "ApplicationViewController.h"
#import "MyProfileViewController.h"

@interface SelectedFilesViewController ()
@end

@implementation SelectedFilesViewController
@synthesize selectedFiles;

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBackSegue)];
    [self.navigationItem setLeftBarButtonItem:backButton];
}

- (void)goBackSegue
{
    if([[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2] isKindOfClass:[ApplicationViewController class]])
    {
        ApplicationViewController* avc = (ApplicationViewController*) [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
        avc.selectedFiles = self.selectedFiles;
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if([[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2] isKindOfClass:[MyProfileViewController class]])
    {
        MyProfileViewController* mpvc = (MyProfileViewController*)[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
        mpvc.selectedFiles = self.selectedFiles;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)shareFiles:(id)sender
{
    [[DBChooser defaultChooser] openChooserForLinkType:DBChooserLinkTypePreview
                                    fromViewController:self completion:^(NSArray *results)
     {
         if ([results count])
         {
             NSMutableArray* files;
             if (self.selectedFiles)
                 files = [self.selectedFiles mutableCopy];
             else
                 files = [[NSMutableArray alloc]init];
             
             for (DBChooserResult* dbc in results)
             {
                 bool notcontained = NO;
                 for (DBChooserResult* oldres in files) {
                     if ([oldres.name isEqualToString:dbc.name] && [[oldres.link description] isEqualToString:[dbc.link description]]) {
                         notcontained = YES;
                         continue;
                     }
                 }
                 if (!notcontained) 
                     [files addObject:dbc];
             }
             
             self.selectedFiles = [files copy];
             [self.tableView reloadData];
         }
         else
         {
             //nothing selected
         }
     }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.selectedFiles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DBFileCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    DBChooserResult* res = [self.selectedFiles objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [res.link description];
    cell.textLabel.text = res.name;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (self.selectedFiles)
        {
            NSMutableArray* files = [self.selectedFiles mutableCopy];
            [files removeObjectAtIndex:indexPath.row];
            self.selectedFiles = [files copy];
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
@end
