//
//  NTT_Data_Job_Application_AppTests.m
//  NTT Data Job Application AppTests
//
//  Created by Matthias Rabus on 14.09.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "NTT_Data_Job_Application_AppTests.h"
#import "NSManagedObjectContext+Shared.h"

@implementation NTT_Data_Job_Application_AppTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    NSManagedObjectContext* con = [NSManagedObjectContext sharedManagedObjectContext];
    STAssertNotNil(con, @"baba");
}

@end
