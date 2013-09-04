

#import "OSURLHelper.h"
@implementation OSURLHelper
static OSURLHelper *sharedHelper = nil;

#pragma mark -
#pragma mark singilton init methods
// alloce shared API singelton
+ (id)alloc
{
	@synchronized(self)
    {
		NSAssert(sharedHelper == nil, @"Attempted to allocate a second instance of a singleton.");
		return [super alloc];
	}
	return nil;
}
// Init shared API singelton
+ (OSURLHelper*)sharedHelper
{
	@synchronized(self)
    {
		if (!sharedHelper)
			sharedHelper = [[OSURLHelper alloc] init];
	}
	return sharedHelper;
}
- (id) init
{
	if ((self=[super init]))
    {
        
	}
	return self;
}

#pragma mark -
#pragma mark make url for requests
/**
 *	return the connection url depending on connection type
 *
 *	@param	connectionType	type of connection we need to get is
 *
 *	@return	url of connection
 */
-(NSURL*)getUrl:(OSConnectionType)connectionType
{
    switch (connectionType) {
        case OSCGetTopics:// get list of countries with cities inside
        {
            return [sharedHelper getTopics];
            break;
        }
        case OSCGetLocation: // get list of categories and subcategories url
        {
            return [sharedHelper getLocation];
            break;
        }
        case OSCGetExperience:
        {
            return [sharedHelper getExperience];
            break;
        }
        case OSCGetJobTitle:
        {
            return [sharedHelper getJobTitleUrl];
            break;
        }
        case OSCGetTitle:
        {
            return [sharedHelper getTopics];
            break;
        }
        case OSCGetSearch:
        {
            return [sharedHelper getSearch];
            break;
        }
    }
    return [NSURL URLWithString:@""];
}
#pragma mark customize url for each connection type
/**
 *	get the url for countries
 *
 *	@return	url of get countries
 */
-(NSURL*)getJobTitleUrl
{
    NSString* result = [NSString stringWithFormat:@"http://nttdata.apiary.io/get_job_title"];
    NSURL* url = [NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return url;
}

/**
 *	get the url for categories
 *
 *	@return	url of get categories		
 */
-(NSURL*)getTopics
{
    NSString* result = [NSString stringWithFormat:@"http://nttdata.apiary.io/get_topics"];
    NSURL* url = [NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return url;
}

-(NSURL*)getLocation
{
    NSString* result =[NSString stringWithFormat:@"http://nttdata.apiary.io/get_locations"];
    NSURL* url = [NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return url;
}
-(NSURL*)getExperience
{//
    NSString* result =[NSString stringWithFormat:@"http://nttdata.apiary.io/get_experience"];
    NSURL* url = [NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return url;

}
-(NSURL*)getSearch
{
    
    NSString* result =[NSString stringWithFormat:@"http://54.213.109.35:8080/NTT_Job_Application_Server/rest/fixedjobsquery"];
    NSURL* url = [NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return url;

}

@end
