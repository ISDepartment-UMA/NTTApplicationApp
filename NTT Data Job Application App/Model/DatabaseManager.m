//
//  DatabaseManager.m
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 23.09.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "DatabaseManager.h"

@interface DatabaseManager()
{
    NSManagedObjectContext* _managedObjectContext;
    NSManagedObjectModel* _objectModel;
    NSPersistentStoreCoordinator* _coordinator;
}
@end

@implementation DatabaseManager
#define EXPERIENCE_TABLENAME @"Experience"
#define JOBTITLE_TABLENAME @"JobTitle"
#define LOCATION_TABLENAME @"Location"
#define TOPIC_TABLENAME @"Topic"

+ (DatabaseManager*)sharedInstance
{
    static DatabaseManager* sharedInstance;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        sharedInstance = [[DatabaseManager alloc]init];
    });
    
    return sharedInstance;
}

- (Experience*)createExperience
{
    return [NSEntityDescription insertNewObjectForEntityForName:EXPERIENCE_TABLENAME inManagedObjectContext:[self context]];
}

- (BOOL)createExperiencesFromJSON:(id)jsonResponse
{
    for (NSDictionary* dict in (NSArray*)jsonResponse)
    {
        if ([[dict objectForKey:@"experience"] isEqualToString:@"null"])
            continue;
        
        NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:EXPERIENCE_TABLENAME];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"databasename" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"databasename = %@ && displayname = %@", [dict  objectForKey:@"experience"], [dict objectForKey:@"display_name"]];
        
        NSError* error = nil;
        NSArray* results = [[self context] executeFetchRequest:request error:&error];
        
        if (!results || [results count] > 1)
        {
            NSLog(@"Error while creating Experience: %@", error);
            return false;
        }
        else if (![results count])
        {
            Experience* experience = [self createExperience];
            experience.databasename = [dict objectForKey:@"experience"];
            experience.displayname = [dict objectForKey:@"display_name"];
        }
    }
    [self saveContext];
    return true;
}

- (NSArray*)allExperiences
{
    return [self fetchAllResultsForEntity:EXPERIENCE_TABLENAME];
}

- (NSString*)getExperienceDisplayNameFromDatabaseName:(NSString *)databaseName
{
    return [self getDisplayNameForDatabaseName:databaseName fromTable:EXPERIENCE_TABLENAME];
}

- (void)clearExperiences
{
    NSArray* experiences = [self allExperiences];
    for (Experience* ex in experiences)
        [[self context]deleteObject:ex];
}

- (JobTitle*)createJobTitle
{
    return [NSEntityDescription insertNewObjectForEntityForName:JOBTITLE_TABLENAME inManagedObjectContext:[self context]];
}

- (BOOL)createJobTitlesFromJSON:(id)jsonResponse
{
    for (NSDictionary* dict in (NSArray*)jsonResponse)
    {
        if ([[dict objectForKey:@"jobtitle"] isEqualToString:@"null"])
            continue;
        
        NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:JOBTITLE_TABLENAME];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"databasename" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"databasename = %@ && displayname = %@", [dict objectForKey:@"jobtitle"], [dict objectForKey:@"display_name"]];
        
        NSError* error = nil;
        NSArray* results = [[self context] executeFetchRequest:request error:&error];
        
        if (!results || [results count] > 1)
        {
            NSLog(@"Error while creating JobTitle: %@", error);
            return false;
        }
        else if (![results count])
        {
            JobTitle* jobTitle = [self createJobTitle];
            jobTitle.databasename = [dict objectForKey:@"jobtitle"];
            jobTitle.displayname = [dict objectForKey:@"display_name"];
        }
    }
    [self saveContext];
    return true;
}

- (NSArray*)allJobTitles
{
    return [self fetchAllResultsForEntity:JOBTITLE_TABLENAME];
}

- (NSString*)getJobTitleDisplayNameFromDatabaseName:(NSString *)databaseName
{
    return [self getDisplayNameForDatabaseName:databaseName fromTable:JOBTITLE_TABLENAME];
}

- (void)clearJobTitles
{
    NSArray* jobTitles = [self allJobTitles];
    for (JobTitle* jobTitle in jobTitles)
         [[self context]deleteObject:jobTitle];
}

- (Location*)createLocation
{
    return [NSEntityDescription insertNewObjectForEntityForName:LOCATION_TABLENAME inManagedObjectContext:[self context]];
}

- (BOOL)createLocationsFromJSON:(id)jsonResponse
{
    for (NSDictionary* dict in (NSArray*)jsonResponse)
    {
        if ([[dict objectForKey:@"location"] isEqualToString:@"null"])
        {
            continue;
        }
        
        NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:LOCATION_TABLENAME];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"databasename" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"databasename = %@ && displayname = %@", [dict  objectForKey:@"location"], [dict objectForKey:@"display_name"]];
        
        NSError* error = nil;
        NSArray* results = [[self context] executeFetchRequest:request error:&error];
        
        if (!results || [results count] > 1)
        {
            NSLog(@"Error while creating Location: %@", error);
            return false;
        }
        else if (![results count])
        {
            Location* location = [self createLocation];
            location.databasename = [dict objectForKey:@"location"];
            location.displayname = [dict objectForKey:@"display_name"];
        }
    }
    [self saveContext];
    return true;
}

- (NSArray*)allLocations
{
    return [self fetchAllResultsForEntity:LOCATION_TABLENAME];;
}

- (NSString*)getLocationDisplayNameFromDatabaseName:(NSString *)databaseName
{
    return [self getDisplayNameForDatabaseName:databaseName fromTable:LOCATION_TABLENAME];
}

- (void)clearLocations
{
    NSArray* locations = [self allLocations];
    for (Location* loc in locations)
        [[self context]deleteObject:loc];
}

- (Topic*)createTopic
{
    return [NSEntityDescription insertNewObjectForEntityForName:TOPIC_TABLENAME inManagedObjectContext:[self context]];
}

- (BOOL)createTopicsFromJSON:(id)jsonResponse
{
    for (NSDictionary* dict in (NSArray*)jsonResponse)
    {
        if ([[dict objectForKey:@"topic"] isEqualToString:@"null"])
        {
            continue;
        }
        
        NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:TOPIC_TABLENAME];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"databasename" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"databasename = %@ && displayname = %@", [dict  objectForKey:@"topic"], [dict objectForKey:@"display_name"]];
        
        NSError* error = nil;
        NSArray* results = [[self context] executeFetchRequest:request error:&error];
        
        if (!results || [results count] > 1)
        {
            NSLog(@"Error while creating Topic: %@", error);
            return false;
        }
        else if (![results count])
        {
            Topic* topic = [self createTopic];
            topic.databasename = [dict objectForKey:@"topic"];
            topic.displayname = [dict objectForKey:@"display_name"];
        }
    }
    [self saveContext];
    return true;
}

- (NSArray*)allTopics
{
    return [self fetchAllResultsForEntity:TOPIC_TABLENAME];
}

- (NSString*)getTopicDisplayNameFromDatabaseName:(NSString *)databaseName
{
    return [self getDisplayNameForDatabaseName:databaseName fromTable:TOPIC_TABLENAME];
}

- (void)clearTopics
{
    NSArray* topics = [[DatabaseManager sharedInstance]allTopics];
    for (Topic* topic in topics)
        [[self context]deleteObject:topic];
}

- (NSString*) getDisplayNameForDatabaseName:(NSString *)databaseName fromTable:(NSString *)tableName
{
    NSArray* results = [self fetchAllResultsForEntity:tableName];
    if (results && [results count])
    {
        for (id o in results)
        {
            if ([o respondsToSelector:@selector(databasename)] && [o respondsToSelector:@selector(displayname)])
            {
                NSString* dbName = [o performSelector:@selector(databasename)];
                if ([dbName isEqualToString:databaseName])
                {
                    return [o performSelector:@selector(displayname)];
                }
            }
        }
    }
    return @"";
}

#pragma mark - Core Data Helper Methods
- (NSArray*) fetchAllResultsForEntity: (NSString*)entity
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:entity];
    request.sortDescriptors =  @[[NSSortDescriptor sortDescriptorWithKey:@"databasename" ascending:YES]];
    
    NSError* error = nil;
    NSArray* results = [[self context]executeFetchRequest:request error:&error];
    
    if (!results)
        NSLog(@"Error while fetching results from Database: %@", error );
    return results;
}

- (NSManagedObjectContext*) context
{
    if (_managedObjectContext)
        return _managedObjectContext;
    
    NSPersistentStoreCoordinator* coordinator = [self persistentStoreCoordinator];
    if (coordinator)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc]init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
    if (_coordinator) {
        return _coordinator;
    }
    
    _coordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:[self managedObjectModel]];
    
    NSError* error = nil;
    NSURL* storeUrl = [[self applicationDocumentsDirectory]URLByAppendingPathComponent:@"NTTDataJobApplicationApp.sqlite"];
    
    if (![_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        //handle error
    }
    
    return _coordinator;
}

- (NSManagedObjectModel*) managedObjectModel
{
    if (_objectModel)
        return _objectModel;
    
    NSURL* modelURL = [[NSBundle mainBundle] URLForResource:@"NTTDataJobAppDatabase" withExtension:@"momd"];
    
    _objectModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
    return _objectModel;
}

- (NSURL*)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];
}

- (void) saveContext
{
    NSManagedObjectContext* con = [self context];
    NSError* error = nil;
    
    if ([con hasChanges] && ![con save:&error]) {
        NSLog(@"Error while saving context: %@", error);
    }
}
@end
