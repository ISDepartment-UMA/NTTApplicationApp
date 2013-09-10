//
//  ViewController.m
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 29.07.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "FoundPositionsOverviewViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "OSConnectionManager.h"
#import "SBJson.h"
#import "OSAPIManager.h"

@interface FoundPositionsOverviewViewController()
@property(nonatomic,strong) UIView* loaderView;
@property(nonatomic,strong)  UIActivityIndicatorView* loader;
@property (nonatomic, strong) SBJsonParser *parser;
@property (weak, nonatomic) IBOutlet UITableView *optionsTable;
@property (strong, nonatomic)  NSArray* resultArray;

@end

@implementation FoundPositionsOverviewViewController
@synthesize loaderView;
@synthesize loader;
@synthesize resultArray;
@synthesize parser;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{  
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
    
    parser = [[SBJsonParser alloc] init];
    [self initLoader];
}

-(void)viewDidAppear:(BOOL)animated
{
    [OSConnectionManager sharedManager].delegate = self;
    [[OSConnectionManager sharedManager] StartConnection:OSCGetSearch];
    [loader startAnimating];
    [loaderView setHidden:NO];
}

-(void)connectionSuccess:(OSConnectionType)connectionType withData:(NSData *)data
{
    NSString* responseString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"null" withString:@"\"none\""];
    
    id jsonObject=  [parser objectWithString:responseString];
    if (connectionType != OSCGetSearch)
        self.resultArray = (NSArray*)jsonObject;
    else
        self.resultArray = jsonObject;
    
//    resultArray = [resultArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        return [obj1[@"position_name"] compare:obj2[@"position_name"]
//                                       options:NSCaseInsensitiveSearch];
//        [self. tableView reloadData];
//    }];
    
    [self.tableView reloadData];
    [loaderView setHidden:YES];
    [loader setHidden:NO];
}

- (void)connectionFailed:(OSConnectionType)connectionType
{}

- (IBAction)byTitleSelected
{
    [self sortByTitle];
    [self.tableView reloadData];
}

- (void)sortByTitle{
    NSArray* sorted = [self.resultArray sortedArrayUsingComparator:(NSComparator)^(NSDictionary *item1, NSDictionary *item2) {
        return (NSComparisonResult)[[item1 objectForKey:@"job_title"] compare:[item2 objectForKey:@"job_title"] options:NSCaseInsensitiveSearch] ;
    }];
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
        return (NSComparisonResult)[[item1 objectForKey:@"location1"] compare:[item2 objectForKey:@"location1"] options:NSCaseInsensitiveSearch] ;
    }];
    self.resultArray =sorted;
}

- (IBAction)byRefNoSelected
{
    [self sortByRefNo];
    [self.tableView reloadData];
}

- (void)sortByRefNo{
    NSArray* sorted = [self.resultArray sortedArrayUsingComparator:(NSComparator)^(NSDictionary *item1, NSDictionary *item2) {
        return (NSComparisonResult)[[item1 objectForKey:@"ref_no"] compare:[item2 objectForKey:@"ref_no"] options:NSCaseInsensitiveSearch] ;
    }];
    self.resultArray =sorted;
}


#pragma mark - UITableViewDataSource
// lets the UITableView know how many rows it should display
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [resultArray count];
}

- (NSString *)titleForRow:(NSUInteger)row
{
    NSDictionary* object = [resultArray objectAtIndex:row];
    return [object objectForKey:@"position_name"];
}

- (NSString *)jobTitleForRow:(NSUInteger)row
{
    NSDictionary* object = [resultArray objectAtIndex:row];
    return [object objectForKey:@"job_title"];
}

- (NSString *)locationForRow:(NSUInteger)row
{
    NSDictionary* object = [resultArray objectAtIndex:row];
    return [object objectForKey:@"location1"];
}

- (NSString *)refNoForRow:(NSUInteger)row
{
    NSDictionary* object = [resultArray objectAtIndex:row];
    return [object objectForKey:@"ref_no"];
}


// loads up a table view cell with the search criteria at the given row in the Model

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Position";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.accessoryType= UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.text = [self titleForRow:indexPath.row];

    //@"Location\nReferenceID"
    NSString *subtitle = [NSString stringWithFormat:@"Job Title: %@ && Location: %@\nReferenceID: %@", [self jobTitleForRow:indexPath.row],[self locationForRow:indexPath.row], [self refNoForRow:indexPath.row]];
        
    cell.detailTextLabel.numberOfLines = 3;
    cell.detailTextLabel.text = subtitle;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [OSAPIManager sharedManager].searchObject = [resultArray objectAtIndex:indexPath.row];
}
@end