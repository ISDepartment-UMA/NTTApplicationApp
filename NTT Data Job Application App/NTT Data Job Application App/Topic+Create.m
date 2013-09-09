//
//  Topic+Create.m
//  NTT Data Job Application App
//
//  Created by Matthias Rabus on 07.09.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "Topic+Create.h"
#import "NSManagedObjectContext+Shared.h"

@implementation Topic (Create)
+(Topic*)createTopicFromDictionary:(NSDictionary*)dictionary
{
    Topic* topic = nil;
    
    NSManagedObjectContext* context = [NSManagedObjectContext sharedManagedObjectContext];
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Topic"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"databasename" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"databasename = %@ && displayname = %@", [dictionary objectForKey:@"topic"], [dictionary objectForKey:@"display_name"]];
    
    NSError* error = nil;
    NSArray* results = [context executeFetchRequest:request error:&error];
    
    if (!results && [results count]> 1)
    {
    }else if (![results count])
    {
        topic = [NSEntityDescription insertNewObjectForEntityForName:@"Topic" inManagedObjectContext:context];
        topic.databasename = [dictionary objectForKey:@"topic"];
        topic.displayname = [dictionary objectForKey:@"display_name"];
    }
    else
        topic = [results lastObject];
    
    return topic;
}

+(NSArray*)allTopicsIncludingJSON:(id)jsonObject
{
    for (NSDictionary* dict in (NSArray*)jsonObject)
        [Topic createTopicFromDictionary:dict];
    
    return [Topic getAllTopics];
}

+ (NSArray*)getAllTopics
{
    NSManagedObjectContext* context = [NSManagedObjectContext sharedManagedObjectContext];
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Topic"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"databasename" ascending:YES]];
    if (context) {
        NSLog(@"Context: %@", context);

    }

    NSError* error = nil;
    return [context executeFetchRequest:request error:&error];
}
@end
