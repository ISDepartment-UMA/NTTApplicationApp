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
#define FAQ_TABLENAME @"Faq"
#define RATING_TABLENAME @"Rating"

+ (DatabaseManager*)sharedInstance
{
    static DatabaseManager* sharedInstance;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        sharedInstance = [[DatabaseManager alloc]init];
    });
    
    return sharedInstance;
}
#pragma mark FilterSet

-(void)removeFilter:(Filter*)filter
{
    [[self context] deleteObject:filter];
    
}

-(NSArray*)getAllFilter
{
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Filter"
                                              inManagedObjectContext:[self context]];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return fetchedRecords;
    
}

-(void)storeFilter:(NSString*)uuid :(NSString*)contentExperience :(NSString*)contentJobTitle :(NSString*)contentTopic :(NSString*)contentLocation :(NSString*)freeTextFilter
{
    Filter *filter = [NSEntityDescription insertNewObjectForEntityForName:@"Filter"
                                                   inManagedObjectContext:[self context]];
    
    filter.expFilter = contentExperience;
    filter.titleFilter = contentJobTitle;
    filter.topicFilter = contentTopic;
    filter.locationFilter = contentLocation;
    filter.freeTextFilter = freeTextFilter;
    filter.uuid = uuid;

}

-(void)deleteFilter:(id)object
{
    [[self context] deleteObject:object];
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
- (OpenPosition*)getOpenPositionForRefNo: (NSString*)refNo
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:OPENPOSITION_TABLENAME];
    request.sortDescriptors =  @[[NSSortDescriptor sortDescriptorWithKey:@"ref_no" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"ref_no == %@", refNo];
    
    NSError* error = nil;
    NSArray* results = [[self context]executeFetchRequest:request error:&error];
    
    if (!results || [results count] > 1)
    {
        return nil;;
    }
    else if([results count] == 1)
        return [results lastObject];
    else
        return nil;
}

- (void)clearOpenPositions
{
    NSArray* openPositions = [self allOpenPositions];
    for (OpenPosition* pos in openPositions) 
        [[self context]deleteObject:pos];
}

#pragma mark -
#pragma mark Applications
#pragma mark -
- (Application*)createApplication
{
    Application* currentApplication =  [NSEntityDescription insertNewObjectForEntityForName:APPLICATION_TABLENAME inManagedObjectContext:[self context]];
    currentApplication.dateApplied = [NSDate date];
    currentApplication.deviceID = [[[Helper alloc]init]getDeviceID];
    currentApplication.uuid = [self GetUUID];
    
    return currentApplication;
}

- (void)clearApplications
{
    for (Application* application in [self getAllApplications])
        [[self context]deleteObject:application];
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

- (NSArray*)getAllApplicationsForMyDevice
{
    NSArray* data = [self getAllApplications];
    NSPredicate* filter = [NSPredicate predicateWithFormat:@"deviceID == %@", [self getMyProfile].deviceID];
    return [data filteredArrayUsingPredicate:filter];
}

- (BOOL)createApplicationsFromJSON:(id)jsonResponse
{
    for (NSDictionary* dict in (NSArray*)jsonResponse)
    {
        NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:APPLICATION_TABLENAME];
        request.sortDescriptors =  @[[NSSortDescriptor sortDescriptorWithKey:@"deviceID" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"deviceID = %@ && ref_No == %@", [dict objectForKey:@"device_id"], [dict objectForKey:@"job_ref_no"]];
        
        Application* application = nil;
        NSError* error = nil;
        NSArray* results = [[self context]executeFetchRequest:request error:&error];
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        
        if (!results || [results count] > 1)
        {
            //Error!
        }else if ([results count] == 0)
        {
            application = [self createApplication];
            application.deviceID = [dict objectForKey:@"device_id"];
            application.ref_No = [dict objectForKey:@"job_ref_no"];
            application.dateApplied =   [formatter dateFromString: [dict objectForKey:@"apply_time"]];
            application.status = [dict objectForKey:@"application_status"];
            application.email = [dict objectForKey:@"email"];
            application.firstName = [dict objectForKey:@"first_name"];
            application.lastName = [dict objectForKey:@"last_name"];
            application.address = [dict objectForKey:@"address"];
            application.phoneNo = [dict objectForKey:@"phone_no"];
            application.sharedLink = [dict objectForKey:@"resume_dropbox_url"];
            application.uuid = [dict objectForKey:@"uuid"];
            if ([[dict allKeys]containsObject:@"freetext"]) {
                application.freeText = [dict objectForKey:@"freetext"];
            }
            
        }else
        {
            application = [results lastObject];
            application.dateApplied = [formatter dateFromString: [dict objectForKey:@"apply_time"]];
            application.status = [dict objectForKey:@"application_status"];
            application.email = [dict objectForKey:@"email"];
            application.firstName = [dict objectForKey:@"first_name"];
            application.lastName = [dict objectForKey:@"last_name"];
            application.address = [dict objectForKey:@"address"];
            application.phoneNo = [dict objectForKey:@"phone_no"];
            application.sharedLink = [dict objectForKey:@"resume_dropbox_url"];
            application.uuid = [dict objectForKey:@"uuid"];
            if ([[dict allKeys]containsObject:@"freetext"]) {
                application.freeText = [dict objectForKey:@"freetext"];
            }
        }
    }
    
    [self saveContext];
    return true;
}

- (Application*)getApplicationForRefNo: (NSString*)refNo
{
    Helper* deviceIdHelper = [[Helper alloc]init];
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:APPLICATION_TABLENAME];
    request.sortDescriptors =  @[[NSSortDescriptor sortDescriptorWithKey:@"deviceID" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"deviceID = %@ && ref_No == %@", [deviceIdHelper getDeviceID], refNo];
    
    NSError* error = nil;
    NSArray* results = [[self context]executeFetchRequest:request error:&error];
    
    if (!results || [results count] > 1)
    {
        return nil;;
    }
    else if([results count] == 1)
        return [results lastObject];
    else
        return nil;
}

#pragma mark -
#pragma mark Profile
#pragma mark -
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

#pragma mark -
#pragma mark FAQ
#pragma mark -

- (Faq*)createFaq
{
    return [NSEntityDescription insertNewObjectForEntityForName:FAQ_TABLENAME inManagedObjectContext:[self context]];
}

- (NSArray*)getAllFaqs
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:FAQ_TABLENAME];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"question" ascending:YES]];
    NSError* error = nil;
    
    return [[self context]executeFetchRequest:request error:&error];
}

- (void)clearFaqs
{
    for (Faq* faq in [self getAllFaqs])
        [[self context]deleteObject:faq];
}

- (BOOL)createFaqsFromJSON:(id)jsonResponse
{
    for (NSDictionary* dict in (NSArray*)jsonResponse)
    {
        NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:FAQ_TABLENAME];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"question" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"answer" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"question == %@ && answer == %@", [dict objectForKey:@"question"], [dict objectForKey:@"answer"]];
        
        NSError* error = nil;
        NSArray* results = [[self context]executeFetchRequest:request error:&error];
        if (!results || [results count] > 1)
        {
            //error...
        }
        else if ([results count] == 0)
        {
            Faq* faq = [self createFaq];
            faq.question = [dict objectForKey:@"question"];
            faq.answer = [dict objectForKey:@"answer"];
            faq.faqId = [NSString stringWithFormat:@"%i",[[dict objectForKey:@"number"] intValue]];
            faq.rating =[dict objectForKey:@"average_rates"];
        }
    }
    
    [self saveContext];
    return true;
}

#pragma mark -
#pragma mark Rating
#pragma mark -

#define RATING_UPPER_BOUND 10
#define RATING_LOWER_BOUND 1
- (Rating*)createRatingForFaq:(Faq*)faq withValue: (NSNumber*)value
{
    Rating* rating = [self getRatingForFaq:faq];
    if (!rating)
    {
        rating = [NSEntityDescription insertNewObjectForEntityForName:RATING_TABLENAME inManagedObjectContext:[self context]];
        rating.rates = faq;

        MyProfile* profile = [self getMyProfile];
        rating.deviceID = profile.deviceID;
        
        int valueAsInt = [value intValue];
        if (valueAsInt > RATING_UPPER_BOUND)
            rating.rating = [NSNumber numberWithInt:RATING_UPPER_BOUND];
        else if(valueAsInt < RATING_LOWER_BOUND)
            rating.rating = [NSNumber numberWithInt:RATING_LOWER_BOUND];
        else
            rating.rating = value;
        
        [self saveContext];
    }
    return rating;
}

- (Rating*)getRatingForFaq: (Faq*)faq
{
    MyProfile* profile = [self getMyProfile];
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:RATING_TABLENAME];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"rates" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"devicdeID = %@ && rates = %@", profile.deviceID, faq];
    NSError* error = nil;
    NSArray* results = [[self context]executeFetchRequest:request error:&error];
    
    if (results && [results count]==1)
        return [results lastObject];
    else
        return  nil;
}

- (void)clearRatings
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:RATING_TABLENAME];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"rates" ascending:YES]];
    for (Rating* r in [[self context]executeFetchRequest:request error:NULL])
        [[self context]deleteObject:r];
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

- (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

@end
