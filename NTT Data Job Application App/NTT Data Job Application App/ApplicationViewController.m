//
//  ApplicationViewController.m
//  NTT Data Job Application App
//
//  Created by Pavel Kurasov on 20.09.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "ApplicationViewController.h"
#import "OSAPIManager.h"
#import "DatabaseManager.h"

@interface ApplicationViewController ()< UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *jobInfo;
@property (weak, nonatomic) IBOutlet UITextView *firstName;
@property (weak, nonatomic) IBOutlet UITextView *lastName;
@property (weak, nonatomic) IBOutlet UITextView *address;
@property (weak, nonatomic) IBOutlet UITextView *email;
@property (weak, nonatomic) IBOutlet UITextView *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *responseLabel;

@end

@implementation ApplicationViewController

- (IBAction)sendApplication:(UIButton *)sender {
    self.responseLabel.hidden = NO;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.responseLabel.hidden = YES;
    self.jobInfo.dataSource = self;
    self.jobInfo.delegate = self;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Supplemental methods for row creation
- (NSString *)titleForRow:(NSUInteger)row
{
    return [[OSAPIManager sharedManager].searchObject objectForKey:@"position_name"];;
}

- (NSString *)jobTitleForRow:(NSUInteger)row
{
    return [[DatabaseManager sharedInstance]getJobTitleDisplayNameFromDatabaseName:[[OSAPIManager sharedManager].searchObject objectForKey:@"job_title"]];
}

- (NSString *)locationForRow:(NSUInteger)row
{
    return [[DatabaseManager sharedInstance]getLocationDisplayNameFromDatabaseName:[[OSAPIManager sharedManager].searchObject objectForKey:@"location1"]];;
}

- (NSString *)refNoForRow:(NSUInteger)row
{
    
    return [[OSAPIManager sharedManager].searchObject objectForKey:@"ref_no"];
}


#pragma mark - UITableViewDataSource
// lets the UITableView know how many rows it should display
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// loads up a table view cell with the search criteria at the given row in the Model
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"JobInfo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.accessoryType= UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.text = [self titleForRow:indexPath.row];
    
    
    NSString *subtitle = [NSString stringWithFormat:@"Job Title: %@, Location: %@\nReferenceID: %@", [self jobTitleForRow:indexPath.row],[self locationForRow:indexPath.row], [self refNoForRow:indexPath.row]];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.text = subtitle;
    
    return cell;
}


@end
