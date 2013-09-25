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
#import "OpenPosition.h"

@interface DatabaseManager : NSObject
+ (DatabaseManager*)sharedInstance;

- (Experience*)createExperience;
- (NSArray*)allExperiences;
- (NSString*)getExperienceDisplayNameFromDatabaseName:(NSString*)databaseName;
- (BOOL)createExperiencesFromJSON: (id)jsonResponse;

- (JobTitle*)createJobTitle;
- (NSArray*)allJobTitles;
- (NSString*)getJobTitleDisplayNameFromDatabaseName:(NSString*)databaseName;
- (BOOL)createJobTitlesFromJSON: (id)jsonResponse;

- (Location*)createLocation;
- (NSArray*)allLocations;
- (NSString*)getLocationDisplayNameFromDatabaseName:(NSString*)databaseName;
- (BOOL)createLocationsFromJSON: (id)jsonResponse;

- (Topic*)createTopic;
- (NSArray*)allTopics;
- (NSString*)getTopicDisplayNameFromDatabaseName:(NSString*)databaseName;
- (BOOL)createTopicsFromJSON: (id)jsonResponse;


- (OpenPosition*)createOpenPosition;
- (NSArray*)allOpenPositions;
- (BOOL)createOpenPositionFromJSON:(id)jsonResponse;

- (void)saveContext;

- (void)clearLocations;
- (void)clearExperiences;
- (void)clearJobTitles;
- (void)clearTopics;
- (void)clearOpenPositions;
@end
