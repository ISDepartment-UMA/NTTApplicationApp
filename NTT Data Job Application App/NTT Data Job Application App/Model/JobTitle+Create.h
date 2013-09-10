//
//  JobTitle+Create.h
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 07.09.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "JobTitle.h"

@interface JobTitle (Create)
+(JobTitle*)createJobTitleFromDictionary:(NSDictionary*)dictionary;
+(NSArray*)allJobTitlesIncludingJSON:(id)jsonObject;
+(NSArray*)getAllJobTitles;
+(NSString*)getDisplayNameFromDatabaseName: (NSString*)databaseName;
+ (NSString*)getDatabaseNameFromDisplayName: (NSString*)displayName;
@end
