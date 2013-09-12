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
#import "SBJson.h"
#import "Topic+Create.h"
#import "Topic.h"
#import "Location+Create.h"
#import "Location.h"
#import "Experience+Create.h"
#import "Experience.h"
#import "JobTitle+Create.h"
#import "JobTitle.h"

@interface JobSearchViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

@property (weak, nonatomic) IBOutlet UIButton *jobTitle;
@property (weak, nonatomic) IBOutlet UIButton *topics;
@property (weak, nonatomic) IBOutlet UIButton *location;
@property (weak, nonatomic) IBOutlet UIButton *experience;
@property (weak, nonatomic) IBOutlet UIButton *contButton;

@property (weak, nonatomic) IBOutlet UITableView *searchSelection;
@property (strong, nonatomic) NSArray *jobTitleList; // of String
@property (strong, nonatomic) NSArray *topicsList; // of String
@property (strong, nonatomic) NSArray *locationsList; // of String
@property (strong, nonatomic) NSArray *experienceList; // of String
@property (strong, nonatomic) NSArray *selected;  // of String

@property(nonatomic,strong) UIView* loaderView;
@property(nonatomic,strong)  UIActivityIndicatorView* loader;
@property (nonatomic, strong) SBJsonParser *parser;
@property (weak, nonatomic) IBOutlet UITableView *optionsTable;
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicsLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *expLabel;
@property (weak, nonatomic) IBOutlet UILabel *searchCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *proposeJobButton;
@property (strong, nonatomic) NSMutableDictionary* searchObject;
@end

@implementation JobSearchViewController
@synthesize loaderView;
@synthesize loader;
@synthesize parser;
@synthesize searchObject;

#define JSON_SELECTOR @"display_name"
#define JSON_DATABASE_LOCATION_SELECTOR @"location"
#define JSON_DATABASE_EXPERIENCE_SELECTOR @"experience"
#define JSON_DATABASE_JOBTITLE_SELECTOR @"jobtitle"
#define JSON_DATABASE_TOPIC_SELECTOR @"topic"

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
    self.jobTitleList = [[NSArray alloc] init];
    self.topicsList = [[NSArray alloc] init];
    self.locationsList =[[NSArray alloc] init];
    self.experienceList = [[NSArray alloc] init];
    self.selected = self.jobTitleList;
    self.jobTitle.selected = YES;
    [self selectTitle:nil];
    
    self.searchSelection.dataSource = self;
    self.searchSelection.delegate = self;
        [self initLoader];
    [self loadAllData];
    self.searchCountLabel.text = @"";
    
    UIBarButtonItem *refreshButton =[[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                     target:self
                                     action:@selector(refreshButtonClicked:)];
    [self.navigationItem setRightBarButtonItem:refreshButton animated:YES];
    


}

- (void)refreshButtonClicked:(id)sender {
   
    self.location.selected = NO;
    self.topics.selected = NO;
    self.experience.selected = NO;
    self.jobTitle.selected = NO;
    
    self.jobTitleLabel.text = @"";
    self.topicsLabel.text = @"";
    self.locationLabel.text = @"";
    self.expLabel.text = @"";
    
    self.contButton.enabled = YES;
    self.searchButton.enabled = YES;
    self.proposeJobButton.enabled = YES;
    self.searchCountLabel.text = @"";
    
    self.contButton.alpha = 1;
    self.searchButton.alpha = 1;    

    self.selected = nil;   
    [self initLoader];
    [self loadAllData];
    [self.searchSelection reloadData];   
    
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
    
    NSArray* topics = [Topic getAllTopics];
    if (!topics || ![topics count])
        [[OSConnectionManager sharedManager] StartConnection:OSCGetTopics];
    else
        self.topicsList = topics;
    
    NSArray* locations = [Location getAllLocations];
    if (!locations || ![locations count])
        [[OSConnectionManager sharedManager] StartConnection:OSCGetLocation];
    else
        self.locationsList = locations;
    
    NSArray* titles = [JobTitle getAllJobTitles];
    if (!titles ||![titles count])
        [[OSConnectionManager sharedManager] StartConnection:OSCGetJobTitle];
    else
        self.jobTitleList = titles;
    
    NSArray* experiences = [Experience getAllExperiences];
    if (!experiences || ![experiences count])
        [[OSConnectionManager sharedManager] StartConnection:OSCGetExperience];
    else
        self.experienceList = experiences;
    
    if ([self.jobTitleList count]<=0 ||[self.locationsList count]<=0 ||[self.experienceList count]<=0 ||[self.topicsList count]<=0 )
    {
        [loader startAnimating];
        [loaderView setHidden:NO];
    }
}

-(void)connectionSuccess:(OSConnectionType)connectionType withData:(NSData *)data
{
    NSString* responseString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    if (connectionType ==OSCGetLocation)
    {
        id jsonObject= [parser objectWithString:responseString];
        NSArray* locations = [Location allLocationsIncludingJSON:jsonObject];
        self.locationsList = locations;
    }
    else if (connectionType ==OSCGetJobTitle)
    {
        id jsonObject=  [parser objectWithString:responseString];
        NSArray* titles = [JobTitle allJobTitlesIncludingJSON:jsonObject];
        self.jobTitleList = titles;
    }
    else if (connectionType ==OSCGetExperience)
    {
        id jsonObject= [parser objectWithString:responseString];
        NSArray* experiences = [Experience allExperiencesIncludingJSON:jsonObject];
        self.experienceList = experiences;
    }
    else if (connectionType ==OSCGetTopics)
    {
        id jsonObject= [parser objectWithString:responseString];
        NSArray* topics = [Topic allTopicsIncludingJSON:jsonObject];
        self.topicsList = topics;
    }
    else if(connectionType == OSCGetSearch)
    {
        self.searchCountLabel.text = @"";
        id jsonObject = [parser objectWithString:responseString];
        NSArray* results = (NSArray*)jsonObject;
        
        if ([results count] >= 1)
        {
            self.searchCountLabel.text = [NSString stringWithFormat:@"%d Jobs", [results count]];
            if (self.searchButton.enabled != YES)
            {
                self.searchButton.enabled = YES;
                self.searchButton.alpha = 1.0;
            }
        }
        
    }
    
    if ([self.jobTitleList count]>0 &&[self.locationsList count]>0 &&[self.experienceList count]>0 &&[self.topicsList count]>0 && (connectionType != OSCGetSearch))
    {
        [loaderView setHidden:YES];
        [loader stopAnimating];
        self.contButton.selected=YES;
        self.selected = self.jobTitleList;
        [self.optionsTable reloadData];
    }
}

-(void)connectionFailed:(OSConnectionType)connectionType;
{
    if (connectionType == OSCGetSearch)
    {
        self.searchCountLabel.text = @"No Jobs";
        if (self.searchButton.enabled != NO)
        {
            self.searchButton.enabled = NO;
            self.searchButton.alpha = 0.3;
        }
    }
    
}
 



- (IBAction)selectTitle:(UIButton *)sender {
    self.selected = self.jobTitleList;
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
        Topic* topic = [self.topicsList objectAtIndex:indexPath.row];
        [searchObject setObject:topic.databasename forKey:@"topics"];
        self.topicsLabel.text = topic.displayname;
    }
    if (self.experience.selected)
    {
        Experience* experience = [self.experienceList objectAtIndex:indexPath.row];
        [searchObject setObject:experience.databasename forKey:@"experience"];
        self.expLabel.text = experience.displayname;
    }
    if (self.location.selected)
    {
        Location* location = [self.locationsList objectAtIndex:indexPath.row];
        [searchObject setObject:location.databasename forKey:@"location"];
        self.locationLabel.text = location.displayname;
    }
    if (self.jobTitle.selected)
    {
        JobTitle* jobTitle = [self.jobTitleList objectAtIndex:indexPath.row];
        [searchObject setObject:jobTitle.databasename forKey:@"jobtitles"];
        self.jobTitleLabel.text = jobTitle.displayname;
    }

    [OSAPIManager sharedManager].flashObjects = searchObject;
    [[OSConnectionManager sharedManager] StartConnection:OSCGetSearch];
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
    id object = self.selected[row];
    if ([object respondsToSelector:@selector(displayname)])
        return [object performSelector:@selector(displayname)];
    else
        return @"";
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
