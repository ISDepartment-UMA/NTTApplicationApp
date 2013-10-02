//
//  JobTitle.h
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 01.10.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OpenPosition;

@interface JobTitle : NSManagedObject

@property (nonatomic, retain) NSString * databasename;
@property (nonatomic, retain) NSString * displayname;
@property (nonatomic, retain) NSSet *isMatchedBy;
@end

@interface JobTitle (CoreDataGeneratedAccessors)

- (void)addIsMatchedByObject:(OpenPosition *)value;
- (void)removeIsMatchedByObject:(OpenPosition *)value;
- (void)addIsMatchedBy:(NSSet *)values;
- (void)removeIsMatchedBy:(NSSet *)values;

@end
