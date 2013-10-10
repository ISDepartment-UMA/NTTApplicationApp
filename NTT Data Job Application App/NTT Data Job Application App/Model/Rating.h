//
//  Rating.h
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 10.10.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Faq;

@interface Rating : NSManagedObject

@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * deviceID;
@property (nonatomic, retain) Faq *rates;

@end
