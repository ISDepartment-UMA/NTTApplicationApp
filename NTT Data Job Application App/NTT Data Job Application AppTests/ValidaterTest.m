//
//  ValidaterTest.m
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 02.10.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Validater.h"

@interface ValidaterTest : XCTestCase

@end

@implementation ValidaterTest

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

- (void) testEmailValidation
{
    NSString* validEmail = @"matthias.rabus@uni-mannheim.de";
    NSString* unvalidEmail = @"test..@address.";
    Validater* tester = [[Validater alloc]init];
    
    XCTAssertTrue([tester checkIfMailAddressIsValid:validEmail], @"Email address should be valid");
    
    XCTAssertTrue(![tester checkIfMailAddressIsValid:unvalidEmail], @"Email address should not be valid");
}

- (void)testPhoneNoValidation
{
    NSString* validPhoneNo = @"0231/9020-0";
    NSString* unvalidPhoneNo = @"0231/abc";
    Validater* tester = [[Validater alloc]init];
    
    XCTAssertTrue([tester checkIfPhoneNoIsValid:validPhoneNo], @"Phone No should be valid!");
    XCTAssertTrue(![tester checkIfPhoneNoIsValid:unvalidPhoneNo], @"Phone No should not be valid");
}

@end
