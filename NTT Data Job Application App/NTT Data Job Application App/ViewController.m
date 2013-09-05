//
//  ViewController.m
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 29.07.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "ViewController.h"
#import "QuartzCore/QuartzCore.h"

@implementation ViewController
@synthesize loaderView;
@synthesize loader;
@synthesize resultArray;

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

// loads up a table view cell with the search criteria at the given row in the Model

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Position";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.text = [self titleForRow:indexPath.row];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [OSAPIManager sharedManager].searchObject = [resultArray objectAtIndex:indexPath.row];
}



@end