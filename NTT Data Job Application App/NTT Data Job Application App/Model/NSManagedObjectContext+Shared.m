//
//  NSManagedObjectContext+Shared.m
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 07.09.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "NSManagedObjectContext+Shared.h"

@implementation NSManagedObjectContext (Shared)
+ (NSManagedObjectContext*)sharedManagedObjectContext
{
    static NSManagedObjectContext* sharedContext = nil;
    if (!sharedContext)
    {
        static dispatch_once_t dispatchToken;
        dispatch_once(&dispatchToken, ^{
            sharedContext = [[NSManagedObjectContext alloc]init];
        });
    }
    return sharedContext;
}
@end
