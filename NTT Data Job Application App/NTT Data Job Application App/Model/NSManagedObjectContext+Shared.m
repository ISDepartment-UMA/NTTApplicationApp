//
//  NSManagedObjectContext+Shared.m
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 07.09.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "NSManagedObjectContext+Shared.h"
#import "UIManagedDocument+Shared.h"

@implementation NSManagedObjectContext (Shared)
+ (NSManagedObjectContext*)sharedManagedObjectContext
{
    static NSManagedObjectContext* sharedContext = nil;
    if (!sharedContext)
    {
        static dispatch_once_t dispatchToken;
        dispatch_once(&dispatchToken, ^{
            UIManagedDocument* doc = [UIManagedDocument sharedManagedDocument];
            if (![[NSFileManager defaultManager] fileExistsAtPath:[[doc fileURL] path]])
            {
                [doc saveToURL:[doc fileURL] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success)
                {
                    if (success)
                        sharedContext = doc.managedObjectContext;
                }];
            }
            else if (doc.documentState == UIDocumentStateClosed)
            {
                [doc openWithCompletionHandler:^(BOOL success)
                {
                    if (success)
                        sharedContext = doc.managedObjectContext;
                }];
            }else
                sharedContext = doc.managedObjectContext;
        });
    }
    return sharedContext;
}
@end
