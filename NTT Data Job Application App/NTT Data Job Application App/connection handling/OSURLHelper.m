
#import "OSURLHelper.h"
@implementation OSURLHelper

static OSURLHelper *sharedHelper = nil;

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
        case OSCGetFreeTextSearch:
        {
            return [sharedHelper getFreeTextSearch];
            break;
        }
        case OSCGetApplicationsByDevice:
        {
            return [sharedHelper getApplications];
            break;
        }
        case OSCGetApplicationsByDeviceAndReference:
        {
            return [sharedHelper getApplications];
            break;
        }
        case OSCSendApplication:
        {
            return [sharedHelper sendApplication];
            break;
        }
        case OSCSendSpeculativeApplication:
        {
            return [sharedHelper sendSpeculativeApplication];
            break;
        }
        case OSCSendWithdrawApplication:
        {
            return [sharedHelper sendWithdrawApplication];
            break;
        }
        case OSCGetSpeculativeApplicationsByDevice:
        {
            return [sharedHelper getSpeculativeApplications];
            break;
        }
        case OSCDeleteSpeculativeApplicaton:
        {
            return [sharedHelper deleteSpeculativeApplication];
            break;
        }
        case OSCGetFaq:
        {
            return [sharedHelper getFaq];
            break;
        }
        case OSCSendFilterSet:
        {
            return [sharedHelper sendFilterSet];
            break;
        }
        case OSCSendDeleteFilterSet:
        {
            return [sharedHelper deleteFilterSet];
            break;
        }
        case OSCGetFaqRating:
        {
            return [sharedHelper getFaqRating];
            break;
        }
        case OSSendRating:
        {
            return [sharedHelper sendRatingToApplication];
        }
    }
    return [NSURL URLWithString:@""];
}

#pragma mark customize url for each connection type
-(NSURL*)getJobTitleUrl
{
    NSString* result = [NSString stringWithFormat:@"http://54.213.109.35:8080/NTT_Job_Application_Server/rest/jobtitlechoicequery"];
    NSURL* url = [NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return url;
}

-(NSURL*)getTopics
{
    NSString* result = [NSString stringWithFormat:@"http://54.213.109.35:8080/NTT_Job_Application_Server/rest/topicschoicequery"];
    NSURL* url = [NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return url;
}

-(NSURL*)getLocation
{
    NSString* result =[NSString stringWithFormat:@"http://54.213.109.35:8080/NTT_Job_Application_Server/rest/locationschoicequery"];
    NSURL* url = [NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return url;
}

-(NSURL*)getExperience
{
    NSString* result =[NSString stringWithFormat:@"http://54.213.109.35:8080/NTT_Job_Application_Server/rest/experiencechoicequery"];
    NSURL* url = [NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return url;
}

-(NSURL*)getSearch
{
    NSString* result =[NSString stringWithFormat:@"http://54.213.109.35:8080/NTT_Job_Application_Server/rest/fixedjobsquery"];
    NSURL* url = [NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return url;
}

-(NSURL*)getFreeTextSearch
{
    NSString* result =[NSString stringWithFormat:@"http://54.213.109.35:8080/NTT_Job_Application_Server/rest/freetextquery"];
    NSURL* url = [NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return url;
}
-(NSURL*)getApplications
{
    NSString* result =[NSString stringWithFormat:@"http://54.213.109.35:8080/NTT_Job_Application_Server/rest/queryapplication"];
    NSURL* url = [NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return url;
}

-(NSURL*)sendApplication
{
    NSString* result =[NSString stringWithFormat:@"http://54.213.109.35:8080/NTT_Job_Application_Server/rest/applyjob"];
    NSURL* url = [NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return url;
}
-(NSURL*)sendWithdrawApplication
{
    NSString* result =[NSString stringWithFormat:@"http://54.213.109.35:8080/NTT_Job_Application_Server/rest/withdrawapplication"];
    NSURL* url = [NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return url;
}
- (NSURL*)getFaq
{
    NSString* result =[NSString stringWithFormat:@"http://54.213.109.35:8080/NTT_Job_Application_Server/rest/faqquery"];
    NSURL* url = [NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return url;
}
-(NSURL*)sendSpeculativeApplication
{
    NSString* result =[NSString stringWithFormat:@"http://54.213.109.35:8080/NTT_Job_Application_Server/rest/apply_speculative_application"];
    NSURL* url = [NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return url;
}
-(NSURL*)sendFilterSet
{
    NSString *result = [NSString stringWithFormat:@"http://54.213.109.35:8080/NTT_Job_Application_Server/rest/store_filter_set"];
    NSURL* url = [NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return url;
}
-(NSURL *)deleteFilterSet
{
    NSString *result = [NSString stringWithFormat:@"http://54.213.109.35:8080/NTT_Job_Application_Server/rest/delete_filter_set"];
    NSURL* url = [NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return url;
}
-(NSURL *)getFaqRating
{
    NSString *result = [NSString stringWithFormat:@"http://54.213.109.35:8080/NTT_Job_Application_Server/rest/ratefaq"];
    NSURL* url = [NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return url;
}
-(NSURL*)getSpeculativeApplications
{
    NSString* result =[NSString stringWithFormat:@"http://54.213.109.35:8080/NTT_Job_Application_Server/rest/query_spec_application"];
    NSURL* url = [NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return url;
}
-(NSURL*)deleteSpeculativeApplication
{
    NSString* result =[NSString stringWithFormat:@"http://54.213.109.35:8080/NTT_Job_Application_Server/rest/delete_spec_application"];
    NSURL* url = [NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return url;
}
-(NSURL*)sendRatingToApplication
{
    NSString* result =[NSString stringWithFormat:@"http://54.213.109.35:8080/NTT_Job_Application_Server/rest/ratefaq"];
    NSURL* url = [NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return url;
}
@end
