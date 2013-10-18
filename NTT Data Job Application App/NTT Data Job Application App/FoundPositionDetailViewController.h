//
//  ItemViewController.h
//  NTT Data Job Application App
//
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

@interface FoundPositionDetailViewController : UIViewController <UIActionSheetDelegate>
- (IBAction)social:(id)sender;
@property NSString *freeText;
@property NSDictionary* openPosition;
@end
