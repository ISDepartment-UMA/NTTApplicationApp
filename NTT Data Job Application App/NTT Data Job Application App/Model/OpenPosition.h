//
//  OpenPosition.h
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 25.09.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Experience, JobTitle, Location, Topic;

@interface OpenPosition : NSManagedObject

@property (nonatomic, retain) NSString * contact_person;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * job_description;
@property (nonatomic, retain) NSString * job_requirements;
@property (nonatomic, retain) NSString * main_tasks;
@property (nonatomic, retain) NSString * our_offer;
@property (nonatomic, retain) NSString * perspective;
@property (nonatomic, retain) NSString * phone_no;
@property (nonatomic, retain) NSString * position_name;
@property (nonatomic, retain) NSString * ref_no;
@property (nonatomic, retain) NSSet *dealsWith;
@property (nonatomic, retain) NSSet *isLocatedAt;
@property (nonatomic, retain) JobTitle *jobTitleIs;
@property (nonatomic, retain) Experience *requiresExperience;
@end

@interface OpenPosition (CoreDataGeneratedAccessors)

- (void)addDealsWithObject:(Topic *)value;
- (void)removeDealsWithObject:(Topic *)value;
- (void)addDealsWith:(NSSet *)values;
- (void)removeDealsWith:(NSSet *)values;

- (void)addIsLocatedAtObject:(Location *)value;
- (void)removeIsLocatedAtObject:(Location *)value;
- (void)addIsLocatedAt:(NSSet *)values;
- (void)removeIsLocatedAt:(NSSet *)values;

@end
