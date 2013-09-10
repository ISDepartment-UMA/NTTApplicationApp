//
//  Topic+Create.h
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 07.09.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "Topic.h"

@interface Topic (Create)
+(Topic*)createTopicFromDictionary:(NSDictionary*)dictionary;
+(NSArray*)allTopicsIncludingJSON:(id)jsonObject;
+(NSArray*)getAllTopics;
+(NSString*)getDisplayNameFromDatabaseName: (NSString*)databaseName;
+ (NSString*)getDatabaseNameFromDisplayName: (NSString*)displayName;
@end
