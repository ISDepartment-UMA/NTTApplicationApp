//
//  Experience.h
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 07.09.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Experience : NSManagedObject

@property (nonatomic, retain) NSString * displayname;
@property (nonatomic, retain) NSString * databasename;

@end