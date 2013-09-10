//
//  Experience+Create.m
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 07.09.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "Experience+Create.h"
#import "NSManagedObjectContext+Shared.h"

@implementation Experience (Create)
+(Experience*)createExperienceFromDictionary:(NSDictionary*)dictionary
{
    Experience* experience = nil;
    
    NSManagedObjectContext* context = [NSManagedObjectContext sharedManagedObjectContext];
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Experience"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"databasename" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"databasename = %@ && displayname = %@", [dictionary objectForKey:@"experience"], [dictionary objectForKey:@"display_name"]];
    
    NSError* error = nil;
    NSArray* results = [context executeFetchRequest:request error:&error];
    
    if (!results || [results count] > 1)
    {
        //error
    }else if (![results count])
    {
        experience = [NSEntityDescription insertNewObjectForEntityForName:@"Experience" inManagedObjectContext:context];
        experience.databasename = [dictionary objectForKey:@"experience"];
        experience.displayname = [dictionary objectForKey:@"display_name"];
    }else
        experience = [results lastObject];
    
    return experience;
}

+(NSArray*)allExperiencesIncludingJSON:(id)jsonObject
{
    for (NSDictionary* dict in (NSArray*)jsonObject)
        [Experience createExperienceFromDictionary:dict];

    return [Experience getAllExperiences];
}

+(NSArray*)getAllExperiences
{
    NSManagedObjectContext* context = [NSManagedObjectContext sharedManagedObjectContext];
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Experience"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"databasename" ascending:YES]];
    
    NSError* error = nil;
    return [context executeFetchRequest:request error:&error];
}

+ (NSString*)getDisplayNameFromDatabaseName: (NSString*)databaseName
{
    Experience* experience = nil;
    
    NSManagedObjectContext* context = [NSManagedObjectContext sharedManagedObjectContext];
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Experience"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"databasename" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"databasename = %@", databaseName];
    
    NSError* error = nil;
    NSArray* results = [context executeFetchRequest:request error:&error];
    
    if (!results || [results count] != 1)
        return nil;
    else
    {
        experience = [results lastObject];
        return experience.displayname;
    }
}

+ (NSString*)getDatabaseNameFromDisplayName: (NSString*)displayName
{
    Experience* experience = nil;
    
    NSManagedObjectContext* context = [NSManagedObjectContext sharedManagedObjectContext];
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Experience"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"displayname" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"displayname = %@", displayName];
    
    NSError* error = nil;
    NSArray* results = [context executeFetchRequest:request error:&error];
    
    if (!results || [results count] != 1)
        return nil;
    else
    {
        experience = [results lastObject];
        return experience.databasename;
    }
}
@end
