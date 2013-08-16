//
//  JobAPPViewController.m
//  JobApp
//
//  Created by Pavel Kurasov and Hilal Yavuz on 13.08.13.
//  Copyright (c) 2013 Pavel Kurasov and Hilal Yavuz. All rights reserved.
//

#import "JobAPPViewController.h"

@interface JobAPPViewController () <UITableViewDataSource, UITableViewDelegate>

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

@implementation JobAPPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.jobTitles = @[@"Consultant",@"Project Manager",@"Students",@"Technical Consultant"];
    self.topicsList = @[@"Application Management",@"Business Intelligence",@"Business Process Management",@"Corporate Functions",@"Customer Management",@"Finance Transformation",@"Financial Services",@"IT Management", @"IT and Methods", @"Management Consulting", @"Manufacturing", @"Public", @"SAP Consulting", @"Sales", @"Services & Logistics", @"Telekommunikation", @"Utilities"];
    self.locationsList =@[@"Ettingen", @"Frankfurt", @"Hamburg", @"Hannover", @"Köln", @"München", @"Stuttgart", @"Deutschlandweit"];
    self.experienceList = @[@"Alle", @"Students", @"Young Professional/Graduate", @"Professional", @"Senior Professional"];
    self.selected = self.jobTitles;
    self.jobTitle.selected = YES;
    self.searchSelection.dataSource = self;
    self.searchSelection.delegate = self;
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([tableView cellForRowAtIndexPath:indexPath].accessoryType==UITableViewCellAccessoryCheckmark) {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType=UITableViewCellAccessoryNone;
    } else {
        
        [tableView cellForRowAtIndexPath:indexPath].accessoryType=UITableViewCellAccessoryCheckmark;
        if (self.jobTitle.isSelected) {
            
        }
    }
  }


#pragma mark - UITableViewDataSource

// lets the UITableView know how many rows it should display

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.selected count];
}



- (NSString *)titleForRow:(NSUInteger)row
{
    return self.selected[row];
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
