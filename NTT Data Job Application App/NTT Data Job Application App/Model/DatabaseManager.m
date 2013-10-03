//
//  DatabaseManager.m
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 23.09.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "DatabaseManager.h"
#import "Helper.h"

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
#define OPENPOSITION_TABLENAME @"OpenPosition"
#define APPLICATION_TABLENAME @"Application"
#define MYPROFILE_TABLENAME @"MyProfile"

+ (DatabaseManager*)sharedInstance
{
    static DatabaseManager* sharedInstance;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        sharedInstance = [[DatabaseManager alloc]init];
    });
    
    return sharedInstance;
}

#pragma mark -
#pragma mark Experience
#pragma mark - 
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

#pragma mark -
#pragma mark JobTitle
#pragma mark -
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

#pragma mark -
#pragma mark Location
#pragma mark -
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

#pragma mark -
#pragma mark Topic
#pragma mark -
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

#pragma mark -
#pragma mark OpenPosition
#pragma mark -

- (OpenPosition*)createOpenPosition
{
    return [NSEntityDescription insertNewObjectForEntityForName:OPENPOSITION_TABLENAME inManagedObjectContext:[self context]];
}

- (BOOL)createOpenPositionFromJSON:(id)jsonResponse
{
    for (NSDictionary* dict in (NSArray*)jsonResponse)
    {
        NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:OPENPOSITION_TABLENAME];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"ref_no" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"ref_no = %@", [dict  objectForKey:@"ref_no"]];
        
        NSError* error = nil;
        NSArray* results = [[self context] executeFetchRequest:request error:&error];
        
        if (!results || [results count] > 1)
        {
            NSLog(@"Error while creating OpenPosition: %@", error);
            return false;
        }
        else if (![results count])
        {
            OpenPosition* position = [self createOpenPosition];
            NSArray* locations = [self allLocations];
            NSArray* experiences = [self allExperiences];
            NSArray* topics = [self allTopics];
            NSArray* jobTitles = [self allJobTitles];
            
            position.ref_no = [dict objectForKey:@"ref_no"];
            position.contact_person = [dict objectForKey:@"contact_person"];
            position.email = [dict objectForKey:@"email"];
            position.job_description = [dict objectForKey:@"job_description"];
            position.job_requirements = [dict objectForKey:@"job_requirements"];
            position.main_tasks = [dict objectForKey:@"main_tasks"];
            position.our_offer = [dict objectForKey:@"our_offer"];
            position.perspective = [dict objectForKey:@"perspective"];
            position.phone_no = [dict objectForKey:@"phone_no"];
            position.position_name = [dict objectForKey:@"position_name"];
            
            if ([dict objectForKey:@"location1"])
            {
                for (Location* loc in locations) {
                    if ([loc.databasename isEqualToString:[dict objectForKey:@"location1"]]) {
                        if (![position.isLocatedAt containsObject:loc]) {
                            [position addIsLocatedAtObject:loc];
                        }
                        break;
                    }
                }
            }
            if ([dict objectForKey:@"location2"])
            {
                for (Location* loc in locations) {
                    if ([loc.databasename isEqualToString:[dict objectForKey:@"location2"]]) {
                        if (![position.isLocatedAt containsObject:loc]) {
                            [position addIsLocatedAtObject:loc];
                        }
                        break;
                    }
                }
            }
            if ([dict objectForKey:@"location3"])
            {
                for (Location* loc in locations) {
                    if ([loc.databasename isEqualToString:[dict objectForKey:@"location3"]]) {
                        if (![position.isLocatedAt containsObject:loc]) {
                            [position addIsLocatedAtObject:loc];
                        }
                        break;
                    }
                }
            }
            if ([dict objectForKey:@"location4"])
            {
                for (Location* loc in locations) {
                    if ([loc.databasename isEqualToString:[dict objectForKey:@"location4"]]) {
                        if (![position.isLocatedAt containsObject:loc]) {
                            [position addIsLocatedAtObject:loc];
                        }
                        break;
                    }
                }
            }
            if ([dict objectForKey:@"exp"])
            {
                for (Experience* ex in experiences) {
                    if ([ex.databasename isEqualToString:[dict objectForKey:@"exp"]]) {
                        position.requiresExperience = ex;
                        break;
                    }
                }
            }
            
            if ([dict objectForKey:@"topic1"])
            {
                for (Topic* topic in topics) {
                    if ([topic.databasename isEqualToString:[dict objectForKey:@"topic1"]]) {
                        if (![position.dealsWith containsObject:topic]) {
                            [position addDealsWithObject:topic];
                        }
                        break;
                    }
                }
            }
            if ([dict objectForKey:@"topic2"])
            {
                for (Topic* topic in topics) {
                    if ([topic.databasename isEqualToString:[dict objectForKey:@"topic2"]]) {
                        if (![position.dealsWith containsObject:topic]) {
                            [position addDealsWithObject:topic];
                        }
                        break;
                    }
                }
            }
            if ([dict objectForKey:@"topic3"])
            {
                for (Topic* topic in topics) {
                    if ([topic.databasename isEqualToString:[dict objectForKey:@"topic3"]]) {
                        if (![position.dealsWith containsObject:topic]) {
                            [position addDealsWithObject:topic];
                        }
                        break;
                    }
                }
            }
            if ([dict objectForKey:@"topic4"])
            {
                for (Topic* topic in topics) {
                    if ([topic.databasename isEqualToString:[dict objectForKey:@"topic4"]]) {
                        if (![position.dealsWith containsObject:topic]) {
                            [position addDealsWithObject:topic];
                        }
                        break;
                    }
                }
            }

            if ([dict objectForKey:@"job_title"])
            {
                for (JobTitle* jt in jobTitles) {
                    if ([jt.databasename isEqualToString:[dict objectForKey:@"job_title"]])
                    {
                        position.jobTitleIs = jt;
                        break;
                    }
                }
            }
            
        }
    }
    
    [self saveContext];
    return true;
}

- (NSArray*)allOpenPositions
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:OPENPOSITION_TABLENAME];
    request.sortDescriptors =  @[[NSSortDescriptor sortDescriptorWithKey:@"ref_no" ascending:YES]];
    
    NSError* error = nil;
    NSArray* results = [[self context]executeFetchRequest:request error:&error];
    
    if (!results)
        NSLog(@"Error while fetching results from Database: %@", error );
    return results;
}

- (void)clearOpenPositions
{
    NSArray* openPositions = [self allOpenPositions];
    for (OpenPosition* pos in openPositions) 
        [[self context]deleteObject:pos];
}


- (Application*)createApplication
{
    Application* currentApplication =  [NSEntityDescription insertNewObjectForEntityForName:APPLICATION_TABLENAME inManagedObjectContext:[self context]];
    currentApplication.dateApplied = [NSDate date];
    currentApplication.deviceID = [[[Helper alloc]init]getDeviceID];
    
    return currentApplication;
}

- (NSArray*)getAllApplications
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:APPLICATION_TABLENAME];
    request.sortDescriptors =  @[[NSSortDescriptor sortDescriptorWithKey:@"deviceID" ascending:YES]];
    
    NSError* error = nil;
    NSArray* results = [[self context]executeFetchRequest:request error:&error];
    
    if (!results)
        NSLog(@"Error while fetching results from Database: %@", error );
    return results;
}

- (MyProfile*)getMyProfile
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:MYPROFILE_TABLENAME];
    request.sortDescriptors =  @[[NSSortDescriptor sortDescriptorWithKey:@"deviceID" ascending:YES]];
    
    NSError* error = nil;
    NSArray* results = [[self context]executeFetchRequest:request error:&error];
    
    if (!results)
        NSLog(@"Error while fetching results from Database: %@", error );
    
    MyProfile* profile = nil;
    if ([results count] == 0)
    {
        profile = [NSEntityDescription insertNewObjectForEntityForName:MYPROFILE_TABLENAME inManagedObjectContext:[self context]];
    }else if([results count] == 1)
    {
        profile = [results lastObject];
    }else
    {
        [self clearMyProfile];
        profile = [NSEntityDescription insertNewObjectForEntityForName:MYPROFILE_TABLENAME inManagedObjectContext:[self context]];
    }
    
    profile.deviceID = [[[Helper alloc]init]getDeviceID];
    return profile;
}

- (void)clearApplications
{
    for (Application* application in [self getAllApplications])
        [[self context]deleteObject:application];
}

- (void)clearMyProfile
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:MYPROFILE_TABLENAME];
    request.sortDescriptors =  @[[NSSortDescriptor sortDescriptorWithKey:@"deviceID" ascending:YES]];
    
    NSError* error = nil;
    NSArray* results = [[self context]executeFetchRequest:request error:&error];
    
    if (!results)
        NSLog(@"Error while fetching results from Database: %@", error );
   
    for (MyProfile* profile in results)
        [[self context]deleteObject:profile];
}

- (BOOL)createApplicationsFromJSON:(id)jsonResponse
{ 
    for (NSDictionary* dict in (NSArray*)jsonResponse)
    {
        NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:MYPROFILE_TABLENAME];
        request.sortDescriptors =  @[[NSSortDescriptor sortDescriptorWithKey:@"deviceID" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"deviceID = %@ && ref_No == %@", [dict objectForKey:@"device_id"], [dict objectForKey:@"job_ref_no"]];
        
        Application* application = nil;
        NSError* error = nil;
        NSArray* results = [[self context]executeFetchRequest:request error:&error];
        
        if (!results || [results count] > 1)
        {
            //Error!
        }else if ([results count] == 0)
        {
            application = [self createApplication];
            application.deviceID = [dict objectForKey:@"device_id"];
            application.ref_No = [dict objectForKey:@"job_ref_no"];
            application.dateApplied = [dict objectForKey:@"apply_time"];
            application.status = [dict objectForKey:@"application_status"];
            application.email = [dict objectForKey:@"email"];
            application.firstName = [dict objectForKey:@"first_name"];
            application.lastName = [dict objectForKey:@"last_name"];
            application.address = [dict objectForKey:@"address"];
            application.phoneNo = [dict objectForKey:@"phone_no"];
            
        }else
        {
            application = [results lastObject];
            application.dateApplied = [dict objectForKey:@"apply_time"];
            application.status = [dict objectForKey:@"application_status"];
            application.email = [dict objectForKey:@"email"];
            application.firstName = [dict objectForKey:@"first_name"];
            application.lastName = [dict objectForKey:@"last_name"];
            application.address = [dict objectForKey:@"address"];
            application.phoneNo = [dict objectForKey:@"phone_no"];
        }
        
    }

    [self saveContext];
    return true;
}



#pragma mark -
#pragma mark Save
#pragma mark -
- (void) saveContext
{
    NSManagedObjectContext* con = [self context];
    NSError* error = nil;
    
    if ([con hasChanges] && ![con save:&error]) {
        NSLog(@"Error while saving context: %@", error);
    }
}

#pragma mark - Private Helper Methods
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
    
    NSURL* modelURL = [[NSBundle mainBundle] URLForResource:@"NTTDataJobAppDatabase" withExtension:@"mom"];
    
    _objectModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
    return _objectModel;
}

- (NSURL*)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];
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

@end
