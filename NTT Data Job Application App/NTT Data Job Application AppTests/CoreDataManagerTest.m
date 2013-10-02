//
//  CoreDataManagerTest.m
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 23.09.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "DatabaseManager.h"

@interface CoreDataManagerTest : XCTestCase
@end

@implementation CoreDataManagerTest
#pragma mark - Helper Method for InMemory Database Creation
- (NSManagedObjectContext*) context
{
    static NSManagedObjectContext* _context = nil;
    
    if (!_context)
    {
        _context = [[NSManagedObjectContext alloc]init];
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"NTTDataJobAppDatabase" withExtension:@"mom"];
        NSManagedObjectModel* mod = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
        
        NSPersistentStoreCoordinator* coord = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:mod];
        [coord addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
        [_context setPersistentStoreCoordinator:coord];
    }
    return _context;
}

- (void)setUp
{
    [super setUp];

    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
        Method orig = class_getInstanceMethod([DatabaseManager class], @selector(context));
        Method new = class_getInstanceMethod([self class], @selector(context));
        method_exchangeImplementations(orig, new);
    });
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void) testSharedDatabaseManager
{
    XCTAssertNotNil([DatabaseManager sharedInstance], @"DatabaseManager is nill");
    
    XCTAssertEqualObjects([DatabaseManager sharedInstance], [DatabaseManager sharedInstance], @"Shared Instances are not equal");
}

- (void) testExperienceCreation
{
    XCTAssertNotNil([[DatabaseManager sharedInstance] createExperience], @"Experience is nil");
}

- (void)testAllExperiences
{
    Experience* ex1 = [[DatabaseManager sharedInstance]createExperience];
    ex1.databasename = @"Test";
    ex1.displayname = @"Testing";

    
    NSArray* experiences = [[DatabaseManager sharedInstance] allExperiences];
    XCTAssertNotNil(experiences, @"Experiences is nil");
    
    XCTAssert([experiences count] == 1, @"Count should be 1");
    
    Experience* ex = [experiences lastObject];
    
    XCTAssert([ex.databasename isEqualToString:ex1.databasename], @"Databasenames differ");
    XCTAssert([ex.displayname isEqualToString:ex1.displayname], @"Displaynames differ");
}

- (void) testJobTitleCreation
{
    XCTAssertNotNil([[DatabaseManager sharedInstance]createJobTitle], @"JobTitle is nil");
}

- (void) testAllJobTitles
{
    JobTitle* jobTitle = [[DatabaseManager sharedInstance]createJobTitle];
    jobTitle.databasename = @"consultant";
    jobTitle.displayname = @"Consultant";
    
    NSArray* jobTitles = [[DatabaseManager sharedInstance]allJobTitles];
    
    XCTAssertNotNil(jobTitles, @"All JobTitles returns nil");
    XCTAssert([jobTitles count] == 1, @"Count of all jobTitles should be 1");
    
    JobTitle* jobTitleFromDB = [jobTitles lastObject];
    XCTAssert([jobTitleFromDB.databasename isEqualToString:jobTitle.databasename], @"JobTitles are not equal");
    XCTAssert([jobTitleFromDB.displayname isEqualToString:jobTitle.displayname], @"JobTitles are not equal");
}

- (void)testLocationCreation
{
    XCTAssertNotNil([[DatabaseManager sharedInstance] createLocation], @"Location should not be nil");
}

- (void)testAllLocations
{
    Location* loc = [[DatabaseManager sharedInstance]createLocation];
    loc.displayname = @"Mannheim";
    loc.databasename = @"mannheim";
    
    NSArray* locations = [[DatabaseManager sharedInstance]allLocations];
    XCTAssertNotNil(locations, @"Locations Array should not be nil");
    
    XCTAssert([locations count] == 1, @"Array should contain one element");
    
    Location* locFromDB = [locations lastObject];
    XCTAssert([loc.databasename isEqualToString:locFromDB.databasename], @"Location database names should be equal");
    XCTAssert([loc.displayname isEqualToString:locFromDB.displayname], @"Location displaynames should be equal");
}

- (void)testTopicCreation
{
    XCTAssertNotNil([[DatabaseManager sharedInstance] createTopic], @"Topic should not be nil");
}

- (void)testAllTopics
{
    Topic* topic = [[DatabaseManager sharedInstance]createTopic];
    topic.databasename = @"BI";
    topic.displayname = @"Business Intelligence";
    
    NSArray* topics = [[DatabaseManager sharedInstance]allTopics];
    XCTAssertNotNil(topics, @"Topics Array should not be nil");
    XCTAssert([topics count]==1, @"Topics Array should contain 1 item");
    
    Topic* topicFromDB = [topics lastObject];
    XCTAssert([topic.displayname isEqualToString:topicFromDB.displayname], @"Topic Displaynames should be equal");
    XCTAssert([topicFromDB.databasename isEqualToString:topic.databasename], @"Topic database names should be equal");
}

- (void)testClearLocations
{
    Location* loc = [[DatabaseManager sharedInstance]createLocation];
    loc.databasename = @"hockenheim";
    loc.displayname = @"Hockenheim";
    
    NSArray* locations = [[DatabaseManager sharedInstance]allLocations];
    XCTAssert([locations count] >= 1, @"At least one location in database");
    
    [[DatabaseManager sharedInstance]clearLocations];
    locations = [[DatabaseManager sharedInstance]allLocations];
    XCTAssert([locations count] == 0, @"Locations should be empty");
}

- (void)testClearExperiences
{
    Experience* exp = [[DatabaseManager sharedInstance]createExperience];
    exp.databasename = @"student";
    exp.displayname = @"Student";
    
    NSArray* experiences = [[DatabaseManager sharedInstance]allExperiences];
    XCTAssert([experiences count] >= 1, @"Experiences should contain at least one entry");
    
    [[DatabaseManager sharedInstance]clearExperiences];
    experiences = [[DatabaseManager sharedInstance]allExperiences];
    XCTAssert([experiences count] == 0, @"Experiences should contain no entry");
}

- (void)testClearJobTitles
{
    JobTitle* title = [[DatabaseManager sharedInstance]createJobTitle];
    title.databasename = @"project_manager";
    title.displayname = @"Project Manager";
    
    NSArray* jobTitles = [[DatabaseManager sharedInstance]allJobTitles];
    XCTAssert([jobTitles count] >= 1, @"JobTitles should contain at least one instance");
    
    [[DatabaseManager sharedInstance]clearJobTitles];
    jobTitles = [[DatabaseManager sharedInstance]allJobTitles];
    XCTAssert([jobTitles count] == 0, @"JobTitles should contain no instance");
}

- (void)testClearTopics
{
    Topic* topic = [[DatabaseManager sharedInstance]createTopic];
    topic.databasename = @"process_management";
    topic.displayname = @"Process Management";
    
    NSArray* topics = [[DatabaseManager sharedInstance]allTopics];
    XCTAssert([topics count] >=1, @"Topics should contain at least one instance");
    
    [[DatabaseManager sharedInstance]clearTopics];
    topics = [[DatabaseManager sharedInstance]allTopics];
    XCTAssert([topics count] == 0, @"Topics should contain no instance");
}

- (void) testDisplayName
{
    Location* loc = [[DatabaseManager sharedInstance]createLocation];
    loc.databasename = @"new_york";
    loc.displayname = @"New York";
    XCTAssert([[[DatabaseManager sharedInstance]getLocationDisplayNameFromDatabaseName:@"new_york"]isEqualToString:@"New York"], @"Location displayname is wrong");
    
    Experience* ex = [[DatabaseManager sharedInstance]createExperience];
    ex.databasename = @"manager";
    ex.displayname = @"Manager";
    XCTAssert([[[DatabaseManager sharedInstance]getExperienceDisplayNameFromDatabaseName:@"manager"]isEqualToString:@"Manager"], @"Experience displayname is wrong");
    
    JobTitle* jobTitle = [[DatabaseManager sharedInstance]createJobTitle];
    jobTitle.databasename = @"technical_consultant";
    jobTitle.displayname = @"Technical Consultant";
    XCTAssert([[[DatabaseManager sharedInstance]getJobTitleDisplayNameFromDatabaseName:@"technical_consultant"] isEqualToString:@"Technical Consultant"], @"Job Title displayname is wrong");
    
    Topic* topic = [[DatabaseManager sharedInstance]createTopic];
    topic.databasename = @"sap_consulting";
    topic.displayname = @"SAP Consulting";
    XCTAssert([[[DatabaseManager sharedInstance]getTopicDisplayNameFromDatabaseName:@"sap_consulting"]isEqualToString:@"SAP Consulting"], @"Topic displayname is wrong");
}


- (void)testCreateOpenPosition
{
    XCTAssertNotNil([[DatabaseManager sharedInstance]createOpenPosition], @"New open position should not be nil");
}

- (void)testAllOpenPositions
{
    OpenPosition* pos = [[DatabaseManager sharedInstance]createOpenPosition];
    pos.ref_no = @"123";
    
    NSArray* openPositions = [[DatabaseManager sharedInstance]allOpenPositions];
    XCTAssertNotNil(openPositions, @"All OpenPositions should not be nil");
    
    XCTAssert([openPositions count] >= 1, @"Open Positions count should be at least 1");
}

- (void) testClearOpenPositions
{
    OpenPosition* position = [[DatabaseManager sharedInstance]createOpenPosition];
    position.ref_no = @"890";
    
    NSArray* positions = [[DatabaseManager sharedInstance]allOpenPositions];
    XCTAssert([positions count] >= 1, @"Open Positions should contain at least one element");
    
    [[DatabaseManager sharedInstance]clearOpenPositions];
    positions = [[DatabaseManager sharedInstance]allOpenPositions];
    XCTAssert([positions count] == 0, @"Positions count should be zero");
}

- (void) testCreateApplication
{
    XCTAssertNotNil([[DatabaseManager sharedInstance]createApplication], @"Created Application should not be nil");
}

- (void)testPrefilledFields
{
    Application* application = [[DatabaseManager sharedInstance]createApplication];
    
    XCTAssertNotNil(application.dateApplied, @"Date applied should be not nil");
    
    XCTAssertNotNil(application.deviceID, @"DevideID should be filled");
}

- (void) testGetAllApplications
{
    [[DatabaseManager sharedInstance]createApplication];
    XCTAssert([[[DatabaseManager sharedInstance]getAllApplications]count] > 0, @"There should exist at least one application");
}

- (void) testClearApplications
{
    [[DatabaseManager sharedInstance]createApplication];
        XCTAssert([[[DatabaseManager sharedInstance]getAllApplications]count] > 0, @"There should exist at least one application");
    [[DatabaseManager sharedInstance]clearApplications];
        XCTAssert([[[DatabaseManager sharedInstance]getAllApplications]count] == 0, @"There should be no application in the database");
}

- (void) testClearProfiles
{
    [[DatabaseManager sharedInstance]getMyProfile];
    
    XCTAssertNoThrow([[DatabaseManager sharedInstance]clearMyProfile], @"There should be no error during profile deletion");
}

- (void) testGetProfile
{
    MyProfile* myProfile = [[DatabaseManager sharedInstance]getMyProfile];
    XCTAssertNotNil(myProfile, @"MyProfile should not be nil");
    
    MyProfile* secondProfile = [[DatabaseManager sharedInstance]getMyProfile];
    XCTAssertEqual(myProfile, secondProfile, @"There should be only one profile in the database");
    
    XCTAssertNotNil(myProfile.deviceID, @"Device ID should be set");
}
@end
