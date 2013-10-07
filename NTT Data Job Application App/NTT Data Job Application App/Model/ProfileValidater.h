//
//  Validater.h
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 02.10.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileValidater : NSObject
- (BOOL)checkIfMailAddressIsValid: (NSString*)emailAddress;
- (BOOL)checkIfPhoneNoIsValid: (NSString*)phoneNo;
@end
