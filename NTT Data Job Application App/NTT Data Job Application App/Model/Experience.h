//
//  Experience.h
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 25.09.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OpenPosition;

@interface Experience : NSManagedObject

@property (nonatomic, retain) NSString * databasename;
@property (nonatomic, retain) NSString * displayname;
@property (nonatomic, retain) NSSet *canOffer;
@end

@interface Experience (CoreDataGeneratedAccessors)

- (void)addCanOfferObject:(OpenPosition *)value;
- (void)removeCanOfferObject:(OpenPosition *)value;
- (void)addCanOffer:(NSSet *)values;
- (void)removeCanOffer:(NSSet *)values;

@end
