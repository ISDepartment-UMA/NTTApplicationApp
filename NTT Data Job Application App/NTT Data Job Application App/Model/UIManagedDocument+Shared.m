//
//  UIManagedDocument+Shared.m
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 09.09.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "UIManagedDocument+Shared.h"

@implementation UIManagedDocument (Shared)
+ (UIManagedDocument*)sharedManagedDocument
{
    NSURL* url = [[[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"NTT Data Job App Database"];
    
    static UIManagedDocument* document = nil;
    if (!document || ![document.fileURL isEqual:url])
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            document = [[UIManagedDocument alloc]initWithFileURL:url];
        });
    }
    return document;
}
@end
