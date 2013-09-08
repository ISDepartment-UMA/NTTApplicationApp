//
//  ViewController.m
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 29.07.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "FoundPositionsOverviewViewController.h"
#import "QuartzCore/QuartzCore.h"

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
    if (connectionType != OSCGetSearch) {
        self.resultArray = [jsonObject objectForKey:@"items"];
    }
    else
        self.resultArray = jsonObject;
    [self.tableView reloadData];
    [loaderView setHidden:YES];
    [loader setHidden:NO];
}

- (void)connectionFailed:(OSConnectionType)connectionType
{}
- (IBAction)byTitleSelected:(UIBarButtonItem *)sender {
    [self sortByTitle];
    [self.tableView reloadData];
}

- (void)sortByTitle{
    NSArray* sorted = [self.resultArray sortedArrayUsingComparator:(NSComparator)^(NSDictionary *item1, NSDictionary *item2) {
        NSString *score1 = [item1 objectForKey:@"job_title"];
        //NSLog([NSString stringWithFormat:@"start:%@",score1]  );
        
        NSString *score2 = [item2 objectForKey:@"job_title"];
        //NSLog(score2);
        
        //NSLog([NSString stringWithFormat:@"%d",[score1 localizedCaseInsensitiveCompare :score2 ] ]);
        return (NSComparisonResult)[score1 compare:score2 options:NSCaseInsensitiveSearch] ;
    }];
    self.resultArray =sorted;
}
- (IBAction)byLocationSelected:(UIBarButtonItem *)sender {
    [self sortByLocation];
    [self.tableView reloadData];
}

- (void)sortByLocation{
    NSArray* sorted = [self.resultArray sortedArrayUsingComparator:(NSComparator)^(NSDictionary *item1, NSDictionary *item2) {
        NSString *score1 = [item1 objectForKey:@"location1"];
        //NSLog([NSString stringWithFormat:@"start:%@",score1]  );
        
        NSString *score2 = [item2 objectForKey:@"location1"];
        //NSLog(score2);
        
        //NSLog([NSString stringWithFormat:@"%d",[score1 localizedCaseInsensitiveCompare :score2 ] ]);
        return (NSComparisonResult)[score1 compare:score2 options:NSCaseInsensitiveSearch] ;
    }];
    self.resultArray =sorted;
}

- (IBAction)byRefNoSelected:(UIBarButtonItem *)sender {
    [self sortByRefNo];
    [self.tableView reloadData];
}

- (void)sortByRefNo{
    NSArray* sorted = [self.resultArray sortedArrayUsingComparator:(NSComparator)^(NSDictionary *item1, NSDictionary *item2) {
        NSString *score1 = [item1 objectForKey:@"ref_no"];
        //NSLog([NSString stringWithFormat:@"start:%@",score1]  );
        
        NSString *score2 = [item2 objectForKey:@"ref_no"];
        //NSLog(score2);
        
        //NSLog([NSString stringWithFormat:@"%d",[score1 localizedCaseInsensitiveCompare :score2 ] ]);
        return (NSComparisonResult)[score1 compare:score2 options:NSCaseInsensitiveSearch] ;
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