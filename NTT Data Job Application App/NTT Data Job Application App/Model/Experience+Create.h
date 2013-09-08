//
//  Experience+Create.h
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 07.09.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "Experience.h"

@interface Experience (Create)
+(Experience*)createExperienceFromDictionary:(NSDictionary*)dictionary;
+(NSArray*)allExperiencesIncludingJSON:(NSString*)jsonResponse;
+(NSArray*)getAllExperiences;
@end
