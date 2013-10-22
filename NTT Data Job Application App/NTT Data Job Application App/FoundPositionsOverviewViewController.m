//
//  ViewController.m
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 29.07.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "FoundPositionsOverviewViewController.h"
#import "FoundPositionDetailViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "OSConnectionManager.h"
#import "DatabaseManager.h"

@interface FoundPositionsOverviewViewController()
@property(nonatomic,strong) UIView* loaderView;
@property(nonatomic,strong)  UIActivityIndicatorView* loader;
@property (weak, nonatomic) IBOutlet UITableView *optionsTable;
@property (strong, nonatomic)  NSArray* resultArray;
@property (nonatomic) BOOL locationOrderedAscending;
@property (nonatomic) BOOL jobTitleOrderedAscending;
@property (nonatomic) NSInteger selectedJob;
@end

@implementation FoundPositionsOverviewViewController
@synthesize loaderView;
@synthesize loader;
@synthesize resultArray;
@synthesize selectedJob;

#pragma mark - View Controller Life Cycle
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showPositionsDetails"])
    {
        NSDictionary* position = [[resultArray objectAtIndex:selectedJob] copy];
        if ([segue.destinationViewController respondsToSelector:@selector(setOpenPosition:)])
            [segue.destinationViewController performSelector:@selector(setOpenPosition:) withObject:position];
        if ([segue.destinationViewController respondsToSelector:@selector(setFreeText:)]) {
            [segue.destinationViewController performSelector:@selector(setFreeText:) withObject:self.freeText];
        }
    }
}

-(void)initLoader
{
    float width = 100;
    float hight = 100;
    loader =[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, width, hight)];
    loaderView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 -width/2, self.view.frame.size.height/2 - hight/2, width, hight)];
    
    [loaderView setBackgroundColor:[UIColor clearColor]];
    UIImageView* loaderImage = [[UIImageView alloc] initWithFrame:loaderView.frame];
    CGRect frame = loaderView.frame;
    frame.origin.x = 0;
    frame.origin.y= 0;
    [loaderImage setFrame:frame];
    [loaderImage setBackgroundColor:[UIColor grayColor]];
    [loaderImage setAlpha:0.8];
    [loaderView addSubview:loaderImage];
    
    [loader setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loaderImage.layer.cornerRadius = 5.0;
    loaderView.layer.cornerRadius = 5.0;
    [loaderImage setClipsToBounds:YES];
    [loader setColor:[UIColor whiteColor]];
    [loaderView addSubview:loader];
    [self.view addSubview:loaderView];
    [loaderView setHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.resultArray = [[NSArray alloc] init];
    
    [self initLoader];
}

-(void)viewDidAppear:(BOOL)animated
{
    [loaderView setHidden:YES];
}


#pragma mark - Connection handling
- (void)connectionSuccess:(OSConnectionType)connectionType withDataInArray:(NSArray *)array
{
    self.resultArray = array;
    
    if (!resultArray)
        resultArray = [[NSArray alloc]init];
    else
    {
        if ([resultArray count] == 1)// && connectionType == OSCGetFreeTextSearch)
        {
            NSArray* keys = [(NSDictionary*)resultArray allKeys];
            if ([keys containsObject:@"resultIsEmpty"])
                resultArray = [[NSArray alloc]init];
        }
    }
    
    [self.tableView reloadData];
    [loaderView setHidden:YES];
    [loader setHidden:NO];
    
    if ([resultArray count] == 0)
        self.title = @"No Open Positions";
    else if ([resultArray count] == 1)
        self.title = @"1 Open Position";
    else
        self.title = [NSString stringWithFormat:@"%d Open Positions", [resultArray count]];
}

- (void)connectionFailed:(OSConnectionType)connectionType
{}

#pragma mark - Sorting
- (IBAction)byTitleSelected
{
    [self sortByTitle];
    [self.tableView reloadData];
}

- (void)sortByTitle{
    NSArray* sorted = [self.resultArray sortedArrayUsingComparator:(NSComparator)^(NSDictionary *item1, NSDictionary *item2)
    {
        NSComparisonResult res = [[item1 objectForKey:@"position_name"] caseInsensitiveCompare: [item2 objectForKey:@"position_name"]];
        
        if (res == NSOrderedAscending) {
            if (self.jobTitleOrderedAscending) 
                return NSOrderedDescending;
            else
                return NSOrderedAscending;
        } else if(res == NSOrderedDescending){
            if (self.jobTitleOrderedAscending)
                return NSOrderedAscending;
             else
                return NSOrderedDescending;
            
        }else
            return res;
        
    }];
    self.jobTitleOrderedAscending = !self.jobTitleOrderedAscending;
    self.resultArray = sorted;
}
- (IBAction)byLocationSelected
{
    [self sortByLocation];
    [self.tableView reloadData];
}

- (void)sortByLocation
{
    NSArray* sorted = [self.resultArray sortedArrayUsingComparator:(NSComparator)^(NSDictionary *item1, NSDictionary *item2) {
        
        NSComparisonResult res = [[[DatabaseManager sharedInstance]getLocationDisplayNameFromDatabaseName:[item1 objectForKey:@"location1"]] caseInsensitiveCompare:[[DatabaseManager sharedInstance]getLocationDisplayNameFromDatabaseName:[item2 objectForKey:@"location1"]]];
        
        if (res == NSOrderedAscending) {
            if (self.locationOrderedAscending)
                return NSOrderedDescending;
            else
                return NSOrderedAscending;
        } else if(res == NSOrderedDescending){
            if (self.locationOrderedAscending)
                return NSOrderedAscending;
            else
                return NSOrderedDescending;
            
        }else
            return res;
    }];
    self.locationOrderedAscending = !self.locationOrderedAscending;
    self.resultArray =sorted;
}

#pragma mark - Supplemental methods for row creation
- (NSString *)titleForRow:(NSUInteger)row
{
    NSDictionary* object = [resultArray objectAtIndex:row];
    return [object objectForKey:@"position_name"];
}

- (NSString *)jobTitleForRow:(NSUInteger)row
{
    NSDictionary* object = [resultArray objectAtIndex:row];
    return [[DatabaseManager sharedInstance]getJobTitleDisplayNameFromDatabaseName:[object objectForKey:@"job_title"]];
}

- (NSString *)locationForRow:(NSUInteger)row
{
    NSDictionary* object = [resultArray objectAtIndex:row];
    return [[DatabaseManager sharedInstance]getLocationDisplayNameFromDatabaseName:[object objectForKey:@"location1"]];
}

- (NSString *)refNoForRow:(NSUInteger)row
{
    NSDictionary* object = [resultArray objectAtIndex:row];
    return [object objectForKey:@"ref_no"];
}

#pragma mark - UITableViewDataSource
// lets the UITableView know how many rows it should display
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     NSInteger num = [resultArray count];
    
    if (num == 0)
        num = 1;
    
    return num;
}

// loads up a table view cell with the search criteria at the given row in the Model
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Position";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.accessoryType= UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont systemFontOfSize:12];

    if ([resultArray count] > 0)
    {
        // Configure the cell...
        cell.userInteractionEnabled = YES;
        cell.textLabel.text = [self titleForRow:indexPath.row];
        
        NSString *subtitle = [NSString stringWithFormat:@"Job Title: %@, Location: %@\nReferenceID: %@", [self jobTitleForRow:indexPath.row],[self locationForRow:indexPath.row], [self refNoForRow:indexPath.row]];
        
        cell.detailTextLabel.numberOfLines = 3;
        cell.detailTextLabel.text = subtitle;
    }
    else
    {
        cell.userInteractionEnabled = NO;
        cell.textLabel.text = @"No results found for your keyword";
        NSString* query = [[OSConnectionManager sharedManager].searchObject objectForKey:@"freeText"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Your keyword was \"%@\"", query];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedJob = indexPath.row;
    [self performSegueWithIdentifier:@"showPositionsDetails" sender:self];
}

- (void)startSearchWithType: (OSConnectionType)type
{
    [OSConnectionManager sharedManager].delegate = self;
    [[OSConnectionManager sharedManager] StartConnection:type];
}
@end