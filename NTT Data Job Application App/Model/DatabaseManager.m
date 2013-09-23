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
    NSManagedObjectContext* _context;
    NSManagedObjectModel* _objectModel;
    NSPersistentStoreCoordinator _coordinator;
}
@end

@implementation DatabaseManager

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
    return [NSEntityDescription insertNewObjectForEntityForName:@"Experience" inManagedObjectContext:nil];
}


#pragma mark - Core Data Methods

- (NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
    return _coordinator;
}

- (NSManagedObjectContext*) context
{
    if (_context) {
        return _context;
    }
    
    NSPersistentStoreCoordinator* coordinator = [self persistentStoreCoordinator];
    
}

@end
