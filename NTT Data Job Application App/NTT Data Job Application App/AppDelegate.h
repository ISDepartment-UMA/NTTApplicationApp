//
//  AppDelegate.h
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 29.07.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import "OSConnectionManager.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate ,OSConnectionCompletionDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) NSString *jobID;

@end
