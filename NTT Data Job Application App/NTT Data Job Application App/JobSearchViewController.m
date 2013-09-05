//
//  JobAPPViewController.m
//  JobApp
//
//  Created by Pavel Kurasov and Hilal Yavuz on 13.08.13.
//  Copyright (c) 2013 Pavel Kurasov and Hilal Yavuz. All rights reserved.
//

#import "JobSearchViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "OSAPIManager.h"

@interface JobSearchViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *jobTitle;
@property (weak, nonatomic) IBOutlet UIButton *topics;
@property (weak, nonatomic) IBOutlet UIButton *location;
@property (weak, nonatomic) IBOutlet UIButton *experience;
@property (weak, nonatomic) IBOutlet UIButton *contButton;

@property (weak, nonatomic) IBOutlet UITableView *searchSelection;
@property (strong, nonatomic) NSArray *jobTitles; // of String
@property (strong, nonatomic) NSArray *topicsList; // of String
@property (strong, nonatomic) NSArray *locationsList; // of String
@property (strong, nonatomic) NSArray *experienceList; // of String
@property (strong, nonatomic) NSArray *selected;  // of String

@end

@implementation JobSearchViewController
@synthesize loaderView;
@synthesize loader;
@synthesize parser;
@synthesize searchObject;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [OSAPIManager sharedManager].flashObjects = searchObject;
    NSLog(@"search is %@",searchObject);
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
    self.jobTitles = [[NSArray alloc] init];
    self.topicsList = [[NSArray alloc] init];
    self.locationsList =[[NSArray alloc] init];
    self.experienceList = [[NSArray alloc] init];
    self.selected = self.jobTitles;
    self.jobTitle.selected = YES;
    [self selectTitle:nil];
    
    self.searchSelection.dataSource = self;
    self.searchSelection.delegate = self;
        [self initLoader];
    [self loadAllData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [OSConnectionManager sharedManager].delegate = self;
    [super viewDidAppear:animated];
}

-(void)loadAllData
{
    searchObject= [[NSMutableDictionary alloc] init];
    parser = [[SBJsonParser alloc] init];
    
    [[OSConnectionManager sharedManager] StartConnection:OSCGetTopics];
    [[OSConnectionManager sharedManager] StartConnection:OSCGetLocation];
    [[OSConnectionManager sharedManager] StartConnection:OSCGetJobTitle];
    [[OSConnectionManager sharedManager] StartConnection:OSCGetExperience];
    
    [loader startAnimating];
    [loaderView setHidden:NO];
}

-(void)connectionSuccess:(OSConnectionType)connectionType withData:(NSData *)data
{
    NSString* responseString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    if (connectionType ==OSCGetLocation)
    {
        id jsonObject=  [parser objectWithString:responseString];
        self.locationsList = [jsonObject objectForKey:@"items"];
    }
    else if (connectionType ==OSCGetJobTitle)
    {
        id jsonObject=  [parser objectWithString:responseString];
        self.jobTitles = [jsonObject objectForKey:@"items"];
    }
    else if (connectionType ==OSCGetExperience)
    {
        id jsonObject=  [parser objectWithString:responseString];
        self.experienceList = [jsonObject objectForKey:@"items"];
    }
    else if (connectionType ==OSCGetTopics)
    {
        id jsonObject=  [parser objectWithString:responseString];
        self.topicsList = [jsonObject objectForKey:@"items"];
    }
    
    if ([self.jobTitles count]>0 &&[self.locationsList count]>0 &&[self.experienceList count]>0 &&[self.topicsList count]>0 )
    {
        [loaderView setHidden:YES];
        [loader stopAnimating];
        self.contButton.selected=YES;
        self.selected = self.jobTitles;
        [self.optionsTable reloadData];
    }
    
}

-(void)connectionFailed:(OSConnectionType)connectionType;
{

}

- (IBAction)selectTitle:(UIButton *)sender {
    self.selected = self.jobTitles;
    sender.selected = !sender.isSelected;
    self.location.selected = NO;
    self.topics.selected = NO;
    self.experience.selected = NO;
    self.contButton.enabled = YES;
    self.contButton.alpha = 1.0;
    [self.searchSelection reloadData];
}

- (IBAction)selectTopic:(UIButton *) sender {
    self.selected = self.topicsList;
    sender.selected = !sender.isSelected;
    self.location.selected = NO;
    self.jobTitle.selected = NO;
    self.experience.selected = NO;
    self.contButton.selected = NO;
    self.contButton.enabled = YES;
    self.contButton.alpha = 1.0;
    [self.searchSelection reloadData];
    
}

- (IBAction)selectLocation:(UIButton *)sender {
    self.selected = self.locationsList;
    sender.selected = !sender.isSelected;
    self.topics.selected = NO;
    self.jobTitle.selected = NO;
    self.experience.selected = NO;
    self.contButton.enabled = YES;
    self.contButton.alpha = 1.0;
    [self.searchSelection reloadData];
}

- (IBAction)selectExperience:(UIButton *)sender {
    self.selected = self.experienceList;
    sender.selected = !sender.isSelected;
    self.topics.selected = NO;
    self.jobTitle.selected = NO;
    self.location.selected = NO;
    self.contButton.enabled = NO;
    self.contButton.alpha = 0.3;
    [self.searchSelection reloadData];
}

- (IBAction)contSearch:(UIButton *)sender {
    if(self.jobTitle.isSelected){
        self.jobTitle.selected = NO;
        self.topics.selected = YES;
        self.selected = self.topicsList;
        [self.searchSelection reloadData];
        
    }
    
    else if (self.topics.isSelected) {
        self.topics.selected = NO;
        self.location.selected = YES;
        self.selected = self.locationsList;
        [self.searchSelection reloadData];
    }
    
    else if (self.location.isSelected) {
        self.location.selected = NO;
        self.experience.selected = YES;
        self.selected = self.experienceList;
        [self.searchSelection reloadData];
        self.contButton.enabled = NO;
        self.contButton.alpha = 0.3;
        
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView cellForRowAtIndexPath:indexPath].accessoryType=UITableViewCellAccessoryCheckmark;
    
    if (self.topics.selected)
    {
        NSDictionary* object = [self.topicsList objectAtIndex:indexPath.row];
        [searchObject setObject:[object objectForKey:@"title"] forKey:@"topics"];
        self.topicsLabel.text = [searchObject objectForKey:@"topics"];
    }
    if (self.experience.selected)
    {
        NSDictionary* object = [self.experienceList objectAtIndex:indexPath.row];
        [searchObject setObject:[object objectForKey:@"title"] forKey:@"experience"];
        self.expLabel.text = [searchObject objectForKey:@"experience"];
    }
    if (self.location.selected)
    {
        NSDictionary* object = [self.locationsList objectAtIndex:indexPath.row];
        [searchObject setObject:[object objectForKey:@"title"] forKey:@"location"];
        self.locationLabel.text = [searchObject objectForKey:@"location"];
    }
    if (self.contButton.selected)
    {
        NSDictionary* object = [self.jobTitles objectAtIndex:indexPath.row];
        [searchObject setObject:[object objectForKey:@"title"] forKey:@"jobtitles"];
        self.jobTitleLabel.text = [searchObject objectForKey:@"jobtitles"];
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType=UITableViewCellAccessoryNone; 
}


#pragma mark - UITableViewDataSource

// lets the UITableView know how many rows it should display

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.selected count];
}

- (NSString *)titleForRow:(NSUInteger)row
{
    return [self.selected[row] objectForKey:@"title"];
}

// loads up a table view cell with the search criteria at the given row in the Model

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SelectionItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.text = [self titleForRow:indexPath.row];
    
    return cell;
}


@end
