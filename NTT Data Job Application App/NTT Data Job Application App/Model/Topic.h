//
//  Topic.h
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 01.10.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OpenPosition;

@interface Topic : NSManagedObject

@property (nonatomic, retain) NSString * databasename;
@property (nonatomic, retain) NSString * displayname;
@property (nonatomic, retain) NSSet *topicMatchedBy;
@end

@interface Topic (CoreDataGeneratedAccessors)

- (void)addTopicMatchedByObject:(OpenPosition *)value;
- (void)removeTopicMatchedByObject:(OpenPosition *)value;
- (void)addTopicMatchedBy:(NSSet *)values;
- (void)removeTopicMatchedBy:(NSSet *)values;

@end
