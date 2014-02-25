//
//  NotificationProcessing.m
//  NTT Data Job Application App
//
//  Created by Yunhan Cheng on 2/25/14.
//  Copyright (c) 2014 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "NotificationProcessing.h"
#import "OSConnectionManager.h"

@implementation NotificationProcessing

-(void)notificationProcessing{
    
    [OSConnectionManager sharedManager].delegate = self;
    [[OSConnectionManager sharedManager] StartConnection:OSCGetSearch];
}


- (void)connectionSuccess:(OSConnectionType)connectionType withDataInArray:(NSArray *)array
{

}


- (void)connectionFailed:(OSConnectionType)connectionType
{}
@end
