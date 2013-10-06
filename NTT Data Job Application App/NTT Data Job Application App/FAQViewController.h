//
//  FAQViewController.h
//  NTT Data Job Application App
//
//  Created by Hilal Yavuz on 10/2/13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSConnectionManager.h"
#import "SBJson.h"
#import "AnswerViewController.h"
#import "MessageUI/MFMailComposeViewController.h"
#import "MessageUI/MessageUI.h"

@interface FAQViewController : UITableViewController<OSConnectionCompletionDelegate, UISearchBarDelegate, UITableViewDataSource ,UITableViewDelegate, MFMailComposeViewControllerDelegate>
{
    NSArray* faq;
    NSInteger selected;
    AnswerViewController* answer;
    NSMutableArray *totalStrings;
    NSMutableArray *filteredStrings;
    BOOL isFiltered;
    
}

@property (nonatomic, strong) IBOutlet UISearchBar *mySearchBar;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property(nonatomic)    NSInteger selected;
@property(nonatomic,strong)    NSArray* faq;
@property (nonatomic, strong) SBJsonParser *parser;
@property (nonatomic, strong)    AnswerViewController* answer;
@property(nonatomic,strong) UIView* loaderView;
@property(nonatomic,strong)  UIActivityIndicatorView* loader;
@end