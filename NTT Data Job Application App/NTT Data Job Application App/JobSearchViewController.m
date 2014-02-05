//
//  JobAPPViewController.m
//  JobApp
//
//  Created by Pavel Kurasov and Hilal Yavuz on 13.08.13.
//  Copyright (c) 2013 Pavel Kurasov and Hilal Yavuz. All rights reserved.
//

#import "JobSearchViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "Topic.h"
#import "Location.h"
#import "Experience.h"
#import "JobTitle.h"
#import "DatabaseManager.h"
#import "FoundPositionsOverviewViewController.h"

@interface JobSearchViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

@property (weak, nonatomic) IBOutlet UIButton *jobTitle;
@property (weak, nonatomic) IBOutlet UIButton *topics;
@property (weak, nonatomic) IBOutlet UIButton *location;
@property (weak, nonatomic) IBOutlet UIButton *experience;

@property (weak, nonatomic) IBOutlet UITableView *searchSelection;
@property (strong, nonatomic) NSArray *jobTitleList; // of String
@property (strong, nonatomic) NSArray *topicsList; // of String
@property (strong, nonatomic) NSArray *locationsList; // of String
@property (strong, nonatomic) NSArray *experienceList; // of String
@property (strong, nonatomic) NSArray *selected;  // of String
@property (strong,nonatomic)NSArray *results;
@property (strong, nonatomic)NSArray *allPositions; //cointains all Positions including obsolete

@property(nonatomic,strong) UIView* loaderView;
@property(nonatomic,strong)  UIActivityIndicatorView* loader;
@property (weak, nonatomic) IBOutlet UITableView *optionsTable;
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicsLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *expLabel;
@property (weak, nonatomic) IBOutlet UILabel *searchCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *proposeJobButton;
@property (weak, nonatomic) IBOutlet UIButton *freeTextButton;
@end

@implementation JobSearchViewController
@synthesize loaderView;
@synthesize loader;
@synthesize viewController;
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
    // Make Buttons gradient
    NSArray *buttonArray;
    buttonArray = [NSArray arrayWithObjects:self.jobTitle, self.topics, self.location, self.experience, nil];
    for (UIButton *button in buttonArray) {
        CAGradientLayer *btnGradient = [CAGradientLayer layer];
        btnGradient.frame = button.bounds;
        btnGradient.colors = [NSArray arrayWithObjects:
                              (id)[[UIColor colorWithRed:128.0f / 255.0f green:128.0f / 255.0f blue:255.0f / 255.0f alpha:1.0f] CGColor],
                              (id)[[UIColor colorWithRed:90.0f / 255.0f green:90.0f / 255.0f blue:255.0f / 255.0f alpha:1.0f] CGColor],
                              nil];
        [button.layer insertSublayer:btnGradient atIndex:0];
    }
    
    
    
    [self loadAllData];
    [self selectTitle:self.jobTitle];
    
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

- (void)refreshButtonClicked:(id)sender
{
    [OSConnectionManager sharedManager].searchObject = [[NSMutableDictionary alloc]init];
    
    self.location.selected = NO;
    self.topics.selected = NO;
    self.experience.selected = NO;
    self.jobTitle.selected = NO;
    
    self.jobTitleLabel.text = @"";
    self.topicsLabel.text = @"";
    self.locationLabel.text = @"";
    self.expLabel.text = @"";
    
    self.searchButton.enabled = YES;
    self.proposeJobButton.enabled = YES;
    self.searchCountLabel.text = @"";
    
    self.searchButton.alpha = 1;
    
    self.selected = nil;
    [self initLoader];
    [self loadAllData];
    [self selectTitle:self.jobTitle];
    [self.searchSelection reloadData];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [OSConnectionManager sharedManager].delegate = self;
    if ([[AppSettingsHelper sharedHelper] getSetting])
    {
        [self help:nil];
    }
    [super viewDidAppear:animated];
}

-(void)loadAllData
{
    NSArray* topics = [[DatabaseManager sharedInstance]allTopics];
    if (!topics || ![topics count])
        [[OSConnectionManager sharedManager] StartConnection:OSCGetTopics];
    else
        self.topicsList = topics;
    
    NSArray* locations = [[DatabaseManager sharedInstance]allLocations];
    if (!locations || ![locations count])
        [[OSConnectionManager sharedManager] StartConnection:OSCGetLocation];
    else
        self.locationsList = locations;
    
    NSArray* titles = [[DatabaseManager sharedInstance]allJobTitles];
    if (!titles ||![titles count])
        [[OSConnectionManager sharedManager] StartConnection:OSCGetJobTitle];
    else
        self.jobTitleList = titles;
    
    NSArray* experiences = [[DatabaseManager sharedInstance]allExperiences];
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

- (void)connectionSuccess:(OSConnectionType)connectionType withDataInArray:(NSArray *)array
{
    
    if (connectionType ==OSCGetLocation)
    {
        [[DatabaseManager sharedInstance]createLocationsFromJSON:array];
        NSArray* locations = [[DatabaseManager sharedInstance]allLocations];
        self.locationsList = locations;
    }
    else if (connectionType ==OSCGetJobTitle)
    {
        [[DatabaseManager sharedInstance]createJobTitlesFromJSON:array];
        NSArray* titles = [[DatabaseManager sharedInstance]allJobTitles];
        self.jobTitleList = titles;
    }
    else if (connectionType ==OSCGetExperience)
    {
        [[DatabaseManager sharedInstance]createExperiencesFromJSON:array];
        NSArray* experiences = [[DatabaseManager sharedInstance]allExperiences];
        self.experienceList = experiences;
    }
    else if (connectionType ==OSCGetTopics)
    {
        [[DatabaseManager sharedInstance] createTopicsFromJSON:array];
        NSArray* topics = [[DatabaseManager sharedInstance]allTopics];
        self.topicsList = topics;
    }
    else if(connectionType == OSCGetSearch)
    {
        self.searchCountLabel.text = @"";
        self.results = [self removeObsoletePositions:array];
        
        if ([_results count] == 0) {
            self.searchCountLabel.text = @"No Jobs";
            if (self.searchButton.enabled != NO)
            {
                self.searchButton.enabled = NO;
                self.searchButton.alpha = 0.3;
            }
            
        }
        else if ([self.results count] > 1)
        {
            self.searchCountLabel.text = [NSString stringWithFormat:@"%d Jobs", [_results count]];
            if (self.searchButton.enabled != YES)
            {
                self.searchButton.enabled = YES;
                self.searchButton.alpha = 1.0;
            }
        }
        else if([_results count] == 1)
        {
            if ([_results isKindOfClass:[NSDictionary class]]) {
                NSArray* keys = [(NSDictionary*)self.results allKeys];
                if ([keys containsObject:@"resultIsEmpty"])
                {
                    self.searchCountLabel.text = @"No Jobs";
                    if (self.searchButton.enabled != NO)
                    {
                        self.searchButton.enabled = NO;
                        self.searchButton.alpha = 0.3;
                    }
                }
            }
            else
            {
                self.searchCountLabel.text = [NSString stringWithFormat:@"%d Jobs", [_results count]];
                if (self.searchButton.enabled != YES)
                {
                    self.searchButton.enabled = YES;
                    self.searchButton.alpha = 1.0;
                }
            }
            
        }
        
    }
    
    if ([self.jobTitleList count]>0 &&[self.locationsList count]>0 &&[self.experienceList count]>0 &&[self.topicsList count]>0 && (connectionType != OSCGetSearch))
    {
        [loaderView setHidden:YES];
        [loader stopAnimating];
        self.selected = self.jobTitleList;
        [self.optionsTable reloadData];
    }
}
- ( id) removeObsoletePositions: (NSArray *) allPositions{
    if (![allPositions isKindOfClass:[NSDictionary class]]) {
        
        
        NSMutableArray* allPositions2 = [[NSMutableArray alloc ] initWithArray:allPositions];
        NSMutableArray* allPositions3 = [[NSMutableArray alloc ] initWithArray:allPositions];
        for (NSDictionary* position in allPositions2) {
            
            if(![[position objectForKey:@"position_status"] isEqualToString:@"active"]){
                [allPositions3 removeObject:position];
            }
            
        }
        
        return allPositions3;
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"value1", @"resultIsEmpty", nil];
    return dict;
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
    if (!sender.selected)
        self.selected = nil;
    [self.searchSelection reloadData];
    
}

- (IBAction)selectTopic:(UIButton *) sender {
    self.selected = self.topicsList;
    sender.selected = !sender.isSelected;
    self.location.selected = NO;
    self.jobTitle.selected = NO;
    self.experience.selected = NO;
    if (!sender.selected)
        self.selected = nil;
    [self.searchSelection reloadData];
}

- (IBAction)selectLocation:(UIButton *)sender {
    self.selected = self.locationsList;
    sender.selected = !sender.isSelected;
    self.topics.selected = NO;
    self.jobTitle.selected = NO;
    self.experience.selected = NO;
    if (!sender.selected)
        self.selected = nil;
    [self.searchSelection reloadData];
}

- (IBAction)selectExperience:(UIButton *)sender {
    self.selected = self.experienceList;
    sender.selected = !sender.isSelected;
    self.topics.selected = NO;
    self.jobTitle.selected = NO;
    self.location.selected = NO;
    if (!sender.selected)
        self.selected = nil;
    [self.searchSelection reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType=UITableViewCellAccessoryCheckmark;
    if (self.topics.selected)
    {
        Topic* topic = [self.topicsList objectAtIndex:indexPath.row];
        [[OSConnectionManager sharedManager].searchObject setObject:topic.databasename forKey:@"topics"];
        self.topicsLabel.text = topic.displayname;
    }
    
    if (self.experience.selected)
    {
        Experience* experience = [self.experienceList objectAtIndex:indexPath.row];
        [[OSConnectionManager sharedManager].searchObject setObject:experience.databasename forKey:@"experience"];
        self.expLabel.text = experience.displayname;
    }
    
    if (self.location.selected)
    {
        Location* location = [self.locationsList objectAtIndex:indexPath.row];
        [[OSConnectionManager sharedManager].searchObject setObject:location.databasename forKey:@"location"];
        self.locationLabel.text = location.displayname;
    }
    
    if (self.jobTitle.selected)
    {
        JobTitle* jobTitle = [self.jobTitleList objectAtIndex:indexPath.row];
        [[OSConnectionManager sharedManager].searchObject setObject:jobTitle.databasename forKey:@"jobtitles"];
        self.jobTitleLabel.text = jobTitle.displayname;
    }
    [OSConnectionManager sharedManager].delegate = self;
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
    cell.textLabel.font = [UIFont systemFontOfSize:11];
    cell.textLabel.text = [self titleForRow:indexPath.row];
    
    return cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showOpenPositionsOverview"])
    {
        FoundPositionsOverviewViewController* overviewVC = (FoundPositionsOverviewViewController*)segue.destinationViewController;
        [overviewVC startSearchWithType:OSCGetSearch];
    }
    NSLog(@"search is %@", [OSConnectionManager sharedManager].searchObject);
}

- (IBAction)sarchButtonPressed:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"showOpenPositionsOverview" sender:self];
}

-(IBAction)help:(id)sender
{
    
    viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tutorial"];
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
}
@end