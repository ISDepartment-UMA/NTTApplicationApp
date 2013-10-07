

#import "OSConnectionManager.h"
#import "SBJson.h"

@interface OSConnectionManager ()
{
    // dicitonay for saving mutable data for each connection
    NSMutableDictionary* connectionsData;
    // dictinay for saving connection type of each connection
    NSMutableDictionary* connectionsHashTable;
    __weak id<OSConnectionCompletionDelegate> delegate;
}
@end

@implementation OSConnectionManager

@synthesize connectionsData;
@synthesize connectionsHashTable;
@synthesize delegate;
@synthesize searchObject;

#pragma mark -
#pragma mark singilton init methods
// Init shared API singelton
+ (OSConnectionManager*)sharedManager
{
    static OSConnectionManager* sharedManager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedManager = [[OSConnectionManager alloc]init];
        sharedManager.connectionsHashTable = [[NSMutableDictionary alloc] init];
        sharedManager.connectionsData = [[NSMutableDictionary alloc] init];
        sharedManager.searchObject = [[NSMutableDictionary alloc]init];
    });
    return sharedManager;
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
    else if (connectionType == OSCGetFreeTextSearch)
    {
        NSString* freeText = [searchObject objectForKey:@"freeText"];
        freeText = [self preprocessString:freeText];
        
        NSString* postString =[NSString stringWithFormat:@"{\"freetext\":%@}", freeText];
        NSData* requestdata = [NSData dataWithBytes:[postString UTF8String] length:[postString length]];
        
        [request setHTTPBody:requestdata];
    }
    else if (connectionType == OSCSendApplication)
    {
        
    }
    else if (connectionType == OSCSendWithdrawApplication)
    {
        
    }
    else if (connectionType == OSCGetApplicationsByDeviceAndReference)
    {
        
    }
    else if (connectionType == OSCGetApplicationsByDevice)
    {
        
    }

    // start connection for requested url and set the connection type
    NSURLConnection* connection = [NSURLConnection connectionWithRequest:request delegate:self];

    // get object of hash key of object
    NSString* hashKey = [NSString stringWithFormat:@"%i",connection.hash];
    // open mutable Data object for this connection
    NSMutableData* connectionData = [[NSMutableData alloc] init];
    [self.connectionsData setObject:connectionData forKey:hashKey];
    [self.connectionsHashTable setObject:connectionTypeValue forKey:hashKey];
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
    NSString* connectionType = [self.connectionsHashTable objectForKey:hashKey];
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
    NSString* connectionType = [self.connectionsHashTable objectForKey:hashKey];
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
    SBJsonParser* parser = [[SBJsonParser alloc]init];
    // get data of connection
    NSMutableData* connectionData = [[NSMutableData alloc]init];
    [connectionData appendData:[connectionsData objectForKey:hashKey]];
    NSArray* data = [parser objectWithData:[connectionData copy]];
    // save data of connection on cashing manager
    [delegate connectionSuccess:[connectionType intValue] withDataInArray:data];
    // remove connection from connections hashtable and connections data dictionary
    [connectionsHashTable removeObjectForKey:hashKey];
    [connectionsData removeObjectForKey:hashKey];
}
@end
