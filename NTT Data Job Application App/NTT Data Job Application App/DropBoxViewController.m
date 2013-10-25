//
//  DropBoxViewController.m
//  NTT Data Job Application App
//
//  Created by Yunhan Cheng on 10/18/13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "DropBoxViewController.h"

@interface DropBoxViewController ()<UITableViewDataSource ,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong,nonatomic)NSString *fileName;



@property (strong,nonatomic) NSString* dbLink;
@end

@implementation DropBoxViewController
@synthesize dbFile;
@synthesize restClient;
@synthesize dbLink;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.fileName = [[NSString alloc]init];
    self.dbLink=[[NSString alloc]init];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dbFile count];
}



// loads up a table view cell with the search criteria at the given row in the Model
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"dbFile";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont systemFontOfSize:11];
    
        cell.textLabel.text = self.dbFile[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.myTableView cellForRowAtIndexPath:indexPath].accessoryType=UITableViewCellAccessoryCheckmark;
  self.fileName = [[NSString stringWithFormat:@"/"]stringByAppendingString:self.dbFile[indexPath.row]];
    NSLog(@"%@",self.fileName);
 [[self restClient]loadSharableLinkForFile:self.fileName];
    
  
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.myTableView cellForRowAtIndexPath:indexPath].accessoryType=UITableViewCellAccessoryNone;
    self.dbLink = [[NSString alloc]init];
}


- (DBRestClient *)restClient {
    if (!restClient) {
        restClient =
        [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"shareLink"]){
        [segue.destinationViewController performSelector:@selector(setSharedLink:) withObject:self.dbLink];
    }
}
-(void)restClient:(DBRestClient *)restClient loadedSharableLink:(NSString *)link forFile:(NSString *)path
{
    NSLog(@"sharable link %@",link);
    NSLog(@"file path %@",path);
    self.dbLink = link;
    NSLog(@"sharableLink:%@",self.dbLink);//how to pass this self.dbLink back to ApplicationViewController?
      
   
}


-(void)restClient:(DBRestClient*)restClient loadSharableLinkFailedWithError:(NSError*)error
{
     NSLog(@"Error sharing file: %@", error);
    
}

@end
