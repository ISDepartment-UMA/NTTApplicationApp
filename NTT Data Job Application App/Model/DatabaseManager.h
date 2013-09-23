//
//  DatabaseManager.h
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 23.09.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Experience.h"
#import "JobTitle.h"
#import "Location.h"
#import "Topic.h"

@interface DatabaseManager : NSObject
+ (DatabaseManager*)sharedInstance;

//- (Experience*)createExperience;
//- (NSArray*)allExperiences;
//
//- (JobTitle*)createJobTitle;
//- (NSArray*)allJobTitles;
//
//- (Location*)createLocation;
//- (NSArray*)allLocations;
//
//- (Topic*) createTopic;
//- (NSArray*) allTopics;
@end
