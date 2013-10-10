//
//  Faq.h
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 10.10.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Rating;

@interface Faq : NSManagedObject

@property (nonatomic, retain) NSString * answer;
@property (nonatomic, retain) NSString * question;
@property (nonatomic, retain) NSSet *isRatedBy;
@end

@interface Faq (CoreDataGeneratedAccessors)

- (void)addIsRatedByObject:(Rating *)value;
- (void)removeIsRatedByObject:(Rating *)value;
- (void)addIsRatedBy:(NSSet *)values;
- (void)removeIsRatedBy:(NSSet *)values;

@end
