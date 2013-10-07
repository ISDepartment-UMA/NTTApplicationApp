//
//  Helper.m
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 03.10.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "Helper.h"

@implementation Helper

- (NSString*)getDeviceID
{
    UIDevice* currentDevice = [UIDevice currentDevice];
    return [currentDevice.identifierForVendor description];
}
@end
