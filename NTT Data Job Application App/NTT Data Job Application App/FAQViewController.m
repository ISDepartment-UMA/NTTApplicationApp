//
//  FAQViewController.m
//  NTT Data Job Application App
//
//  Created by Hilal Yavuz on 10/2/13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//
#import "FAQViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "DatabaseManager.h"
#import "OSConnectionManager.h"
#import "AnswerViewController.h"
#import "MessageUI/MFMailComposeViewController.h"
#import "MessageUI/MessageUI.h"


@interface FAQViewController ()<OSConnectionCompletionDelegate, UISearchBarDelegate, UITableViewDataSource ,UITableViewDelegate, UIScrollViewDelegate, MFMailComposeViewControllerDelegate>
{
    NSMutableArray *filteredFaqs;
    BOOL isFiltered;
}
@property (nonatomic, strong) IBOutlet UISearchBar *mySearchBar;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
    @property(nonatomic)    NSInteger selected;
    @property(nonatomic,strong)    NSArray* faqArray;
    @property(nonatomic,strong) UIView* loaderView;
    @property(nonatomic,strong)  UIActivityIndicatorView* loader;
@property (nonatomic,strong) NSString* question;
@property (nonatomic,strong)Faq* faq;
@property (nonatomic,strong)NSArray* rate;
@property (nonatomic,strong)NSArray* videoId;
@end

@implementation FAQViewController
@synthesize faqArray;
@synthesize loaderView;
@synthesize loader;
@synthesize selected;


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openAnswer"])
    {
        AnswerViewController* dest = (AnswerViewController*)segue.destinationViewController;
        Faq* faq = nil;
        
        if (isFiltered)
        {faq = [filteredFaqs objectAtIndex:selected];
            self.question = faq.question;}
        else
        { faq = [faqArray objectAtIndex:selected];
            self.question = faq.question;
        }
        dest.text = faq.answer;
        if ([segue.destinationViewController respondsToSelector:@selector(setQuestion:)] )
        {
            [ segue.destinationViewController performSelector:@selector(setQuestion:) withObject:self.question];
            [segue.destinationViewController performSelector:@selector(setFaq:) withObject:self.faq];
            [segue.destinationViewController performSelector:@selector(setFaqArray:) withObject:faqArray];
            
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


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.mySearchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.mySearchBar resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mySearchBar.delegate = self;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    [self initLoader];
    [OSConnectionManager sharedManager].delegate = self;
    [self loadFaqData];
   
}



-(void)viewDidAppear:(BOOL)animated
{
    UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(mailLabelClicked:)];
    [self.navigationController.navigationItem setRightBarButtonItem:button animated:YES];
    [super viewDidAppear:animated];
}

- (void) loadFaqData
{
    
   /* NSArray* faqFromDatabase = [[DatabaseManager sharedInstance]getAllFaqs];
    
    if (!faqFromDatabase || [faqFromDatabase count] == 0)
    {
        [[OSConnectionManager sharedManager] StartConnection:OSCGetFaq];
        [loader startAnimating];
        [loaderView setHidden:NO];
    }else
    {
        faqArray = faqFromDatabase;
       
    }*/
    [[OSConnectionManager sharedManager] StartConnection:OSCGetFaq];
    [loader startAnimating];
    [loaderView setHidden:NO];
    
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length ==0)
    {
        isFiltered = NO;
    }
    else
    {
        isFiltered =YES;
        filteredFaqs = [[NSMutableArray alloc] init];
        
        for (Faq *obj in faqArray)
        {
            NSString* str = obj.question;
            NSRange stringRange = [str rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(stringRange.location != NSNotFound)
            {
                [filteredFaqs addObject:obj];
            }
        }
    }
    [self.myTableView reloadData];
}

#pragma mark - Connection delegate
- (void)connectionSuccess:(OSConnectionType)connectionType withDataInArray:(NSArray *)array

{
    [[DatabaseManager sharedInstance]createFaqsFromJSON:array];
    self.rate = array;
    
    faqArray = [[DatabaseManager sharedInstance]getAllFaqs];
    [self.tableView reloadData];
    [loader stopAnimating];
    [loaderView setHidden:YES];
}

-(void)connectionFailed:(OSConnectionType)connectionType;
{
    // to be filled ...
}

#pragma mark - Table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(isFiltered)
    {
        return [filteredFaqs count];
    }
    return [faqArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FAQCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(!isFiltered)
    {
        Faq* question = [faqArray objectAtIndex:indexPath.row];
        NSString *avgRate = [self.rate[indexPath.row]objectForKey: @"average_rates"];
        NSString* questionWithRate = [question.question stringByAppendingString:[NSString stringWithFormat:
        @"\nAverage rate: %@", avgRate]];
        [cell.textLabel setText:questionWithRate];
    }
    
    else
    {
        Faq* question = [filteredFaqs objectAtIndex:indexPath.row];
        [cell.textLabel setText:question.question];
        
        
    }
    // Configure the cell...
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.numberOfLines = 3;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selected = indexPath.row;
    self.faq = [faqArray objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"openAnswer" sender:self];
    
}

#pragma mark - Mail delegate
- (IBAction)phoneLableClicked:(id)sender
{
   
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel:4917684365597"]];
        }
    
}

- (IBAction)mailLabelClicked:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController* mailViewController = [[MFMailComposeViewController alloc]init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:[NSString stringWithFormat:@"Your Question: "]];
        
        NSString *trimmed = [NSString stringWithFormat:@"NTTFAQteam@NTT.cm "];
        [mailViewController setToRecipients:@[trimmed]];
        [self presentViewController:mailViewController animated:YES completion:NULL];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}
@end
