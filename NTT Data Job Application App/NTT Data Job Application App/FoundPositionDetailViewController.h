//
//  ItemViewController.h
//  NTT Data Job Application App
//
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSConnectionManager.h"

@interface FoundPositionDetailViewController : UIViewController <UIActionSheetDelegate, OSConnectionCompletionDelegate>
@property NSString *freeText;
@property NSDictionary* openPosition;

@property BOOL fromNotification;
@property (strong, nonatomic) NSString* jobID;
@end
