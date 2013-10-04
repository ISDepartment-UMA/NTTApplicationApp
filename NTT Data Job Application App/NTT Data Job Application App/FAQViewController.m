//
//  FAQViewController.m
//  NTT Data Job Application App
//
//  Created by Hilal Yavuz on 10/2/13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//
#import "FAQViewController.h"
#import "SBJson.h"
#import "QuartzCore/QuartzCore.h"




@implementation FAQViewController
@synthesize faq;
@synthesize loaderView;
@synthesize loader;
@synthesize parser;
@synthesize answer;
@synthesize selected;




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AnswerViewController* dest = (AnswerViewController*)segue.destinationViewController;
    self.answer =dest;
    NSString* ans=[[faq objectAtIndex:selected] objectForKey:@"answer"];
    answer.text = ans;
}
-(void)connectionFailed:(OSConnectionType)connectionType;
{
    // to be filled ...
}


-(void)initLoader
{
    [self.navigationController setNavigationBarHidden:YES];
    
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
    self.mySearchBar.delegate = self;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    [self initLoader];
    [[OSConnectionManager sharedManager] StartConnection:OSCGetFaq];
    [OSConnectionManager sharedManager].delegate = self;
    [loader startAnimating];
    [loaderView setHidden:NO];
    
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length ==0)
    {
        isFiltered = NO;
    }
    else{
        isFiltered =YES;
        filteredStrings = [[NSMutableArray alloc] init];
        for (NSDictionary *obj in faq) {
            NSString* str = [obj objectForKey:@"question"];
            NSRange stringRange = [str rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(stringRange.location != NSNotFound)
            {
                [filteredStrings addObject:str];
            }
        }
    }
    [self.myTableView reloadData];
}
-(void)connectionSuccess:(OSConnectionType)connectionType withData:(NSData *)data
{
    NSString* responseString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    parser= [[SBJsonParser alloc] init];
    id jsonObject= [parser objectWithString:responseString];
    faq = jsonObject ;
    [self.tableView reloadData];
    [loader stopAnimating];
    [loaderView setHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(mailLabelClicked:)];
    [self.navigationController.navigationItem setRightBarButtonItem:button animated:YES];
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.mySearchBar resignFirstResponder];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(isFiltered){
        return [filteredStrings count];
    }
    return [faq count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FAQCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(!isFiltered){
        [cell.textLabel setText:[[faq objectAtIndex:indexPath.row] objectForKey:@"question"]];
    }
    else
    {
        [cell.textLabel setText:[filteredStrings objectAtIndex:indexPath.row]];
    }
    // Configure the cell...
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.numberOfLines = 2;
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selected =indexPath.row;
}


- (IBAction)mailLabelClicked:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController* mailViewController = [[MFMailComposeViewController alloc]init];
        mailViewController.mailComposeDelegate = self;
        [self presentViewController:mailViewController animated:YES completion:NULL];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}


@end
