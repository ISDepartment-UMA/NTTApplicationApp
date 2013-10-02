
#import "OSAPIManager.h"


@implementation OSAPIManager

static OSAPIManager *sharedManager = nil;
@synthesize searchObject;

#pragma mark -
#pragma mark INIT
// alloce shared API singelton
+ (id)alloc
{
	@synchronized(self)
    {
		NSAssert(sharedManager == nil, @"Attempted to allocate a second instance of a singleton.");
		return [super alloc];
	}
	return nil;
}

// Init shared API singelton
+ (OSAPIManager*)sharedManager
{
	@synchronized(self)
    {
		if (!sharedManager)
			sharedManager = [[OSAPIManager alloc] init];
	}
	return sharedManager;
}

- (id) init
{
	if ((self=[super init]))
    {
        searchObject = [[NSMutableDictionary alloc] init];
    }
	return self;
}
@end

