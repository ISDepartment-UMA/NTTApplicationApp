//
//  CoreDataManagerTest.m
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 23.09.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DatabaseManager.h"

@interface CoreDataManagerTest : XCTestCase

@end

@implementation CoreDataManagerTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void) testSharedDatabaseManager
{
    XCTAssertNotNil([DatabaseManager sharedInstance], @"DatabaseManager is nill");
    
    XCTAssertEqualObjects([DatabaseManager sharedInstance], [DatabaseManager sharedInstance], @"Shared Instances are not equal");
}

@end