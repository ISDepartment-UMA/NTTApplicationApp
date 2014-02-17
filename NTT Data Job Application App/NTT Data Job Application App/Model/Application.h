//
//  Application.h
//  NTT Data Job Application App
//
//  Created by Matthias  on 18.02.14.
//  Copyright (c) 2014 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Application : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSDate * dateApplied;
@property (nonatomic, retain) NSString * deviceID;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * freeText;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * phoneNo;
@property (nonatomic, retain) NSString * ref_No;
@property (nonatomic, retain) NSString * sharedLink;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSNumber * statusConfirmed;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSString * socialLink;

@end
