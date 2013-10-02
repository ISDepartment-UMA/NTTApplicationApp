//
//  Validater.m
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 02.10.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "Validater.h"

@implementation Validater
- (BOOL)checkIfMailAddressIsValid:(NSString *)emailAddress
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    
    NSError* error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:emailRegex options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray* matches = [regex matchesInString:emailAddress options:NSMatchingReportCompletion range:NSMakeRange(0, [emailAddress length])];
    
    return ([matches count] >= 1);
}

- (BOOL) checkIfPhoneNoIsValid:(NSString *)phoneNo
{
    NSError* error = nil;
    NSDataDetector* detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:&error];
    NSUInteger matches = [detector numberOfMatchesInString:phoneNo options:NSMatchingReportCompletion range:NSMakeRange(0, [phoneNo length])];
    
    return (matches != 0);
}
@end
