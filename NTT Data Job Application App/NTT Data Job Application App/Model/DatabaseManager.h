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
#import "Application.h"
#import "MyProfile.h"
#import "Faq.h"
#import "Rating.h"
#import "Filter.h"

@interface DatabaseManager : NSObject
#define SPECULATIVE_APPLICATION_REFNO @"specApp_NTTData"
+ (DatabaseManager*)sharedInstance;

-(void)removeFilter:(Filter*)filter;
-(NSArray*)getAllFilter;
-(void)storeFilter:(NSString*)uuid :(NSString*)contentExperience :(NSString*)contentJobTitle :(NSString*)contentTopic :(NSString*)contentLocation :(NSString*)freeTextFilter;
-(void)deleteFilter: (id)object;

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
- (OpenPosition*)getOpenPositionForRefNo: (NSString*)refNo;
- (BOOL)createOpenPositionFromJSON:(id)jsonResponse;

- (void)saveContext;

- (void)clearLocations;
- (void)clearExperiences;
- (void)clearJobTitles;
- (void)clearTopics;
- (void)clearOpenPositions;

- (Application*)createApplication;
- (NSArray*)getAllApplications;
- (NSArray*)getAllApplicationsForMyDevice;
- (BOOL)createApplicationsFromJSON: (id)jsonResponse;
- (void)clearApplications;
- (Application*)getApplicationForRefNo: (NSString*)refNo;

- (MyProfile*)getMyProfile;
- (void)clearMyProfile;

- (Faq*)createFaq;
- (NSArray*)getAllFaqs;
- (BOOL)createFaqsFromJSON: (id)jsonResponse;
- (void)clearFaqs;

- (Rating*)createRatingForFaq:(Faq*)faq withValue: (NSNumber*)value;
- (Rating*)getRatingForFaq: (Faq*)faq;
- (void)clearRatings;
@end
