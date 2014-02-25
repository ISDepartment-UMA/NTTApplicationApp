//
//  AppDelegate.m
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 29.07.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "AppDelegate.h"
#import <DBChooser/DBChooser.h>
#import <CoreData/CoreData.h>
#import "FoundPositionDetailViewController.h"
#import "XNGAPIClient.h"
#import "OSConnectionManager.h"

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            // At this point you can start making API calls
        }
        return YES;
    }
    
    if ([[XNGAPIClient sharedClient] handleOpenURL:url])
        return YES;
    
    // Add whatever other url handling code your app requires here
    return NO;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
  sourceApplication:(NSString *)source annotation:(id)annotation
{
    if ([[DBChooser defaultChooser] handleOpenURL:url]) {
        return YES;
    }
    if ([[XNGAPIClient sharedClient] handleOpenURL:url])
        return YES;
    
    return NO;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    sleep(1.5);    
    DBSession* dbSession =
    [[DBSession alloc]
      initWithAppKey:@"8pptn1m3kun48pp"
      appSecret:@"4t2abq4k2lr5g5n"
      root:kDBRootDropbox] // either kDBRootAppFolder or kDBRootDropbox
     ;
    [DBSession setSharedSession:dbSession];
    
    //ask device whether to receive push notification
    [[UIApplication sharedApplication]registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert |UIRemoteNotificationTypeSound)];
    
    if (launchOptions != nil)
    {
        NSDictionary* dic = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        {
            if (dic != nil){
                NSLog(@"notification: %@",dic);
                //handle dic
            }
        }
    }
    if (![[AppSettingsHelper sharedHelper] checkSettingFound]) {
        [[AppSettingsHelper sharedHelper] setSetting:YES];
    }
    
 
    
    return YES;
}

//get device token for push service
-(void)application: (UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{   NSLog(@"Device token is: %@",deviceToken);
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to get token, error: %@",error);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString* notificationString = [[userInfo valueForKey:@"aps"]valueForKey:@"alert"];
    NSArray *arr = [notificationString componentsSeparatedByString:@" "];
    self.jobID = arr[3];
    
    
    NSLog (@"jobID: %@",arr[3]);
    
    /*   UINavigationController *nvc = (UINavigationController*)self.window.rootViewController;
        FoundPositionDetailViewController *notificationController = [nvc.storyboard instantiateViewControllerWithIdentifier:@"FPDVC"];
    [nvc presentViewController:notificationController animated:YES completion:nil];
    
  */
  // [[NSNotificationCenter defaultCenter] postNotificationName:@"pushNotification" object:nil userInfo:userInfo];
    [OSConnectionManager sharedManager].delegate = self;
    [[OSConnectionManager sharedManager]StartConnection:OSCGetSearch];
    
    
    
}

- (void)connectionSuccess:(OSConnectionType)connectionType withDataInArray:(NSArray *)array
{
    NSLog (@"joblists: %@",array);
    for(int i = 0; i< array.count - 1; i++){
        if ([[array[i]valueForKey:@"ref_no"]isEqualToString:self.jobID]){
            NSLog(@"notification job: %@",array[i]);
        }
    }
}


- (void)connectionFailed:(OSConnectionType)connectionType
{}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
