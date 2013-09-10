//
//  Location+Create.m
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 07.09.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "Location+Create.h"
#import "NSManagedObjectContext+Shared.h"

@implementation Location (Create)
+ (NSArray*)allLocationsIncludingJSON:(id)jsonObject
{
    for (NSDictionary* dict in (NSArray*)jsonObject)
        [Location createLocationFromDictionary:dict];
    
    return [Location getAllLocations];
}

+ (Location*) createLocationFromDictionary:(NSDictionary*)dictionary
{
    Location* location = nil;
    NSManagedObjectContext* context = [NSManagedObjectContext sharedManagedObjectContext];
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"databasename" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"databasename = %@ && displayname = %@", [dictionary objectForKey:@"location"], [dictionary objectForKey:@"display_name"]];
    
    NSError* error = nil;
    NSArray* results = [context executeFetchRequest:request error:&error];
    
    if (!results || [results count]>1)
    {}
    else if (![results count])
    {
        location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:context];
        location.databasename = [dictionary objectForKey:@"location"];
        location.displayname = [dictionary objectForKey:@"display_name"];
    }
    else
        location = [results lastObject];
    
    return location;
}

+ (NSArray*)getAllLocations
{
    NSManagedObjectContext* context = [NSManagedObjectContext sharedManagedObjectContext];
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"databasename" ascending:YES]];
    
    NSError* error = nil;
    return [context executeFetchRequest:request error:&error];
}

+ (NSString*)getDisplayNameFromDatabaseName: (NSString*)databaseName
{
    Location* location = nil;
    NSManagedObjectContext* context = [NSManagedObjectContext sharedManagedObjectContext];
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"databasename" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"databasename = %@", databaseName];
    
    NSError* error = nil;
    NSArray* results = [context executeFetchRequest:request error:&error];
    
    if (!results || [results count] != 1)
        return nil;
    else
    {
        location = [results lastObject];
        return location.displayname;
    }
}

+ (NSString*)getDatabaseNameFromDisplayName: (NSString*)displayName
{
    Location* location = nil;
    NSManagedObjectContext* context = [NSManagedObjectContext sharedManagedObjectContext];
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"displayname" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"displayname = %@", displayName];
    
    NSError* error = nil;
    NSArray* results = [context executeFetchRequest:request error:&error];
    
    if (!results || [results count] != 1)
        return nil;
    else
    {
        location = [results lastObject];
        return location.databasename;
    }
}
@end
