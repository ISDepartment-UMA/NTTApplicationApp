//
//  JobAPPViewController.h
//  JobApp
//
//  Created by Pavel Kurasov and Hilal Yavuz on 13.08.13.
//  Copyright (c) 2013 Pavel Kurasov and Hilal Yavuz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSConnectionManager.h"
#import "SBJson.h"
@interface JobAPPViewController : UIViewController<OSConnectionCompletionDelegate>
{
    UIView* loaderView;
    UIActivityIndicatorView* loader;
    SBJsonParser *parser;
    NSMutableDictionary* searchObject;
    
}
@property(nonatomic,strong)    UIView* loaderView;
@property(nonatomic,strong)    UIActivityIndicatorView* loader;
@property (nonatomic, strong) SBJsonParser *parser;
@property (weak, nonatomic) IBOutlet UITableView *optionsTable;
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicsLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *expLabel;
@property (strong, nonatomic)    NSMutableDictionary* searchObject;
@end