//
//  ViewController.h
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 29.07.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSConnectionManager.h"

@interface FoundPositionsOverviewViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,OSConnectionCompletionDelegate>
@property NSString *freeText;
- (void)startSearchWithType: (OSConnectionType)type;
@end
