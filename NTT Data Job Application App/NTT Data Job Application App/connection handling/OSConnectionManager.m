

#import "OSConnectionManager.h"
@implementation OSConnectionManager

@synthesize connectionsData;
@synthesize connectionsHashTable;
@synthesize delegate;
static OSConnectionManager *sharedManager = nil;

#pragma mark -
#pragma mark singilton init methods
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
+ (OSConnectionManager*)sharedManager
{
	@synchronized(self)
    {
		if (!sharedManager)
			sharedManager = [[OSConnectionManager alloc] init];
	}
	return sharedManager;
}

- (id) init
{
	if ((self=[super init]))
    {
        self.connectionsHashTable = [[NSMutableDictionary alloc] init];
        self.connectionsData = [[NSMutableDictionary alloc] init];
	}
	return self;
}
#pragma mark -
#pragma mark Connection LifeCycle

- (NSString*) preprocessString:(NSString*)input
{
    return ((input) ? [NSString stringWithFormat:@"\"%@\"",input] : @"null");
}

/**
 *	Start a connection for getting data from server api with post&get parameters
 *
 *	@param	connectionType	enum for get type of connection, to check duplicating of connectiontype
 *
 *	@return	yes if connection not duplicated, and then send connection, or no if duplicated
 */
-(BOOL)StartConnection:(OSConnectionType)connectionType
{
    // get object of connection Type
    NSString* connectionTypeValue = [NSString stringWithFormat:@"%i",connectionType];
    NSURL* url = [[OSURLHelper sharedHelper] getUrl:connectionType];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    if (connectionType == OSCGetSearch)
    {
        NSDictionary* searchObject = [OSAPIManager sharedManager].flashObjects;
        
        NSString* exp = [searchObject objectForKey:@"experience"];
        exp = [self preprocessString:exp];
        
        NSString* topic = [searchObject objectForKey:@"topics"];
        topic = [self preprocessString:topic];
        
        NSString* jobtitle = [searchObject objectForKey:@"jobtitles"];
        jobtitle = [self preprocessString:jobtitle];
    
        NSString* location = [searchObject objectForKey:@"location"];
        location = [self preprocessString:location];
        
        NSString* postString =[NSString stringWithFormat:@"{\"jobtitle\":%@,\"location\":%@,\"topic\":%@,\"exp\":%@}", jobtitle, location, topic, exp];
        NSData* requestdata = [NSData dataWithBytes:[postString UTF8String] length:[postString length]];
        
        [request setHTTPBody:requestdata];
    }
    
    if (connectionType == OSCGetFreeTextSearch)
    {
        NSDictionary* searchObject = [OSAPIManager sharedManager].searchObject;
        
        NSString* freeText = [searchObject objectForKey:@"freeText"];
        freeText = [self preprocessString:freeText];
        
        NSString* postString =[NSString stringWithFormat:@"{\"freetext\":%@}", freeText];
        NSData* requestdata = [NSData dataWithBytes:[postString UTF8String] length:[postString length]];
        
        [request setHTTPBody:requestdata];
    }
    
    if (connectionType == OSCSendApplication)
    {
        
    }
    
    if (connectionType == OSCSendWithdrawApplication)
    {
        
    }
    
    if (connectionType == OSCGetApplicationsByDeviceAndReference)
    {
        
    }
    
    if (connectionType == OSCGetApplicationsByDevice)
    {
        
    }

    // start connection for requested url and set the connection type
    NSURLConnection* connection = [NSURLConnection connectionWithRequest:request delegate:self];

    // get object of hash key of object
    NSString* hashKey = [NSString stringWithFormat:@"%i",connection.hash];
    // open mutable Data object for this connection
    NSMutableData* connectionData = [[NSMutableData alloc] init];
    [[sharedManager connectionsData] setObject:connectionData forKey:hashKey];
    [[sharedManager connectionsHashTable] setObject:connectionTypeValue forKey:hashKey];
    return YES;// connection started
}


#pragma mark -
#pragma mark connection delegate
//check the response of the connection
/**
 *	delegate function for getting response for connection
 *
 *	@param	theConnection	running connection
 *	@param	response	the response coming (200 mean ok else error)
 */
- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse * httpResponse;
    httpResponse = (NSHTTPURLResponse *)response;
    NSString* hashKey = [NSString stringWithFormat:@"%i",theConnection.hash];
    NSString* connectionType = [[sharedManager connectionsHashTable] objectForKey:hashKey];
    // connection status get error response
    NSLog(@"response is %i",httpResponse.statusCode);
    if ((httpResponse.statusCode / 100) != 2)// response of not success
    {
        // send faild delegate function to parent control
        [delegate connectionFailed:[connectionType intValue]];
        // remove connection from connections hashtable and connections data dictionary
        [connectionsHashTable removeObjectForKey:hashKey];
        
        [connectionsData removeObjectForKey:hashKey];
        // cancel connection
        [theConnection cancel];
        
    }
}

/**
 *	couldn't complete the connection because of and error
 *
 *	@param	theConnection	running connection
 *	@param	error	error occured
 */
- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    NSString* hashKey = [NSString stringWithFormat:@"%i",theConnection.hash];
    NSString* connectionType = [[sharedManager connectionsHashTable] objectForKey:hashKey];
    // send faild delegate function to parent control
    [delegate connectionFailed:[connectionType intValue]];
    // remove connection from connections hashtable and connections data dictionary
    [connectionsHashTable removeObjectForKey:hashKey];
    [connectionsData removeObjectForKey:hashKey];
    // cancel connection
    [theConnection cancel];
}

/**
 *	delegate for get recieve data from connection
 *
 *	@param	connection	running connection
 *	@param	data	the data recieved
 */
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // get mutabledata object for this connection
    NSString* hashKey = [NSString stringWithFormat:@"%i",connection.hash];
    NSMutableData* connectionData = [[NSMutableData alloc]init];
    // append data with original data
    [connectionData appendData:[connectionsData objectForKey:hashKey]];
    [connectionData appendData:data];
    // resign data in dectionary
    [connectionsData setObject:connectionData forKey:hashKey];
}

// delegate for finishing connection loading
/**
 *	delegate for connection finish loading
 *
 *	@param	connection	running connection
 */
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // get connection type
    NSString* hashKey = [NSString stringWithFormat:@"%i",connection.hash];
    NSString* connectionType = [connectionsHashTable objectForKey:hashKey];
    // get data of connection
    NSMutableData* connectionData = [[NSMutableData alloc]init];
    [connectionData appendData:[connectionsData objectForKey:hashKey]];
    // save data of connection on cashing manager
    [delegate connectionSuccess:[connectionType intValue] withData:connectionData];
    // remove connection from connections hashtable and connections data dictionary
    [connectionsHashTable removeObjectForKey:hashKey];
    [connectionsData removeObjectForKey:hashKey];
}


@end
