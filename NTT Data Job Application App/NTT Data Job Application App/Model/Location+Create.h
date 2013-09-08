//
//  Location+Create.h
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 07.09.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "Location.h"

@interface Location (Create)
+ (NSArray*)allLocationsIncludingJSON:(NSString*)jsonResponse;
+ (Location*)createLocationFromDictionary:(NSDictionary*)dictionary;
+ (NSArray*)getAllLocations;
@end
