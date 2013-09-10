//
//  JobTitle+Create.m
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 07.09.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "JobTitle+Create.h"
#import "NSManagedObjectContext+Shared.h"

@implementation JobTitle (Create)
+(JobTitle*)createJobTitleFromDictionary:(NSDictionary*)dictionary
{
    JobTitle* jobTitle = nil;
    
    NSManagedObjectContext* context = [NSManagedObjectContext sharedManagedObjectContext];
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"JobTitle"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"databasename" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"databasename = %@ && displayname = %@", [dictionary objectForKey:@"jobtitle"], [dictionary objectForKey:@"display_name"]];
    
    NSError* error = nil;
    NSArray* results = [context executeFetchRequest:request error:&error];
    
    if (!results || ([results count] > 1))
    {
    }
    else if (![results count])
    {
        jobTitle = [NSEntityDescription insertNewObjectForEntityForName:@"JobTitle" inManagedObjectContext:context];
        jobTitle.databasename = [dictionary objectForKey:@"jobtitle"];
        jobTitle.displayname = [dictionary objectForKey:@"display_name"];
    }
    else
        jobTitle = [results lastObject];
    
    return jobTitle;
}

+(NSArray*)allJobTitlesIncludingJSON:(id)jsonObject
{
    for (NSDictionary* dict in (NSArray*)jsonObject)
        [JobTitle createJobTitleFromDictionary:dict];
    
    return [JobTitle getAllJobTitles];
}

+(NSArray*)getAllJobTitles
{
    NSManagedObjectContext* context = [NSManagedObjectContext sharedManagedObjectContext];
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"JobTitle"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"databasename" ascending:YES]];
    
    NSError* error = nil;
    return [context executeFetchRequest:request error:&error];
}

+ (NSString*)getDisplayNameFromDatabaseName: (NSString*)databaseName
{
    JobTitle* jobTitle = nil;
    
    NSManagedObjectContext* context = [NSManagedObjectContext sharedManagedObjectContext];
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"JobTitle"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"databasename" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"databasename = %@", databaseName];
    
    NSError* error = nil;
    NSArray* results = [context executeFetchRequest:request error:&error];
    
    if (!results || [results count] != 1)
        return nil;
    else {
        jobTitle = [results lastObject];
        return jobTitle.displayname;
    }
}

+ (NSString*)getDatabaseNameFromDisplayName: (NSString*)displayName
{
    JobTitle* jobTitle = nil;
    
    NSManagedObjectContext* context = [NSManagedObjectContext sharedManagedObjectContext];
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"JobTitle"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"displayname" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"displayname = %@", displayName];
    
    NSError* error = nil;
    NSArray* results = [context executeFetchRequest:request error:&error];
    
    if (!results || [results count] != 1)
        return nil;
    else {
        jobTitle = [results lastObject];
        return jobTitle.databasename;
    }
}
@end
