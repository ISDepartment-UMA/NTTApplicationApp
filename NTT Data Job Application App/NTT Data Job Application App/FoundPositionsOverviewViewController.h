//
//  ViewController.h
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 29.07.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSConnectionManager.h"
#import "SBJson.h"
#import "OSAPIManager.h"
@interface FoundPositionsOverviewViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,OSConnectionCompletionDelegate>
{
    NSArray* resultArray;
    UIView* loaderView;
    UIActivityIndicatorView* loader;
    SBJsonParser *parser;
}

@property(nonatomic,strong)    UIView* loaderView;
@property(nonatomic,strong)    UIActivityIndicatorView* loader;
@property (nonatomic, strong) SBJsonParser *parser;
@property (weak, nonatomic) IBOutlet UITableView *optionsTable;
@property (strong, nonatomic)  NSArray* resultArray;


@end
