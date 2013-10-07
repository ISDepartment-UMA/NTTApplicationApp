//
//  FreeTextSearchViewController.m
//  NTT Data Job Application App
//
//  Created by Hilal Yavuz on 9/24/13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "FreeTextSearchViewController.h"
#import "OSConnectionManager.h"
#import "FoundPositionsOverviewViewController.h"

@interface FreeTextSearchViewController ()<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *freeTextSearchBar;

@end

@implementation FreeTextSearchViewController
@synthesize freeTextSearchBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    freeTextSearchBar.delegate =self;
    
    freeTextSearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    freeTextSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    freeTextSearchBar.showsCancelButton = NO;
}

#pragma mark UISearchBarDelegate
- (void) searchBarTextDidBeginEditing:(UISearchBar*) searchBar {
    freeTextSearchBar.showsCancelButton = NO;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    freeTextSearchBar.showsCancelButton = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
   [self performSegueWithIdentifier:@"connect" sender:searchBar];
}


#pragma mark - View Controller Life Cycle
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"connect"])
    {
        [[OSConnectionManager sharedManager].searchObject setObject:freeTextSearchBar.text forKey:@"freeText"];
        if ([segue.destinationViewController isKindOfClass:[FoundPositionsOverviewViewController class]])
        {
            FoundPositionsOverviewViewController *fpovc = (FoundPositionsOverviewViewController *)segue.destinationViewController;
            fpovc.freeText = freeTextSearchBar.text;
            
            [fpovc startSearchWithType:OSCGetFreeTextSearch];
        }
    }
}


@end
