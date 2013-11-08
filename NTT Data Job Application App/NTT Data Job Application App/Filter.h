//
//  Filter.h
//  NTT Data Job Application App
//
//  Created by Yunhan Cheng on 11/8/13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Filter : NSManagedObject

@property (nonatomic, retain) NSString * expFilter;
@property (nonatomic, retain) NSString * locationFilter;
@property (nonatomic, retain) NSString * titleFilter;
@property (nonatomic, retain) NSString * topicFilter;
@property (nonatomic, retain) NSString * freeTextFilter;

@end
