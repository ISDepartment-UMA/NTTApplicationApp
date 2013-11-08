//
//  MyFilterSetsViewController.h
//  NTT Data Job Application App
//
//  Created by Hilal Yavuz on 11/2/13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSConnectionManager.h"

@interface MyFilterSetsViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate, OSConnectionCompletionDelegate>

@property(nonatomic,strong) NSArray *filterSet;
@end
