//
//  JobAPPViewController.h
//  JobApp
//
//  Created by Pavel Kurasov and Hilal Yavuz on 13.08.13.
//  Copyright (c) 2013 Pavel Kurasov and Hilal Yavuz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSConnectionManager.h"
#import "TutorialViewController.h"
@interface JobSearchViewController : UIViewController<OSConnectionCompletionDelegate>
{
    TutorialViewController *viewController;
}
@property(nonatomic,strong)         TutorialViewController *viewController;
@end