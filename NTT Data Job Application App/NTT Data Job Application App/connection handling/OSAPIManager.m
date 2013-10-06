
#import "OSAPIManager.h"


@implementation OSAPIManager
@synthesize searchObject;

#pragma mark -
#pragma mark INIT
// Init shared API singelton
+ (OSAPIManager*)sharedManager
{
    
    static OSAPIManager* sharedManager = nil;
    dispatch_once_t token;
    
    dispatch_once(&token, ^{
        sharedManager = [[OSAPIManager alloc]init];
        sharedManager.searchObject = [[NSMutableDictionary alloc]init];
    });
    
	return sharedManager;
}

@end

