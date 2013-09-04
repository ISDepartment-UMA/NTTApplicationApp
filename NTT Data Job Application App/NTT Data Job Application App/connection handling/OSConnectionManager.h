
#import "OSURLHelper.h"
#import <Foundation/Foundation.h>
/**
 *	Protocol for finishing connection with result
 */
@protocol OSConnectionCompletionDelegate <NSObject>
/**
 *	Connection is completed with fail so we need to tell connection parent of it (cashing manager)
 *
 *	@param	connectionType	the type of completed connection
 */
-(void)connectionFailed:(OSConnectionType)connectionType;
/**
 *	connection compeleted and get data so we call this delegate to send data
 *
 *	@param	connectionType	the type of completed connection
 *	@param	data	the data of connection response
 */
-(void)connectionSuccess:(OSConnectionType)connectionType withData:(NSData*)data;
@end

@interface OSConnectionManager : NSObject<NSURLConnectionDataDelegate>
{
    // dicitonay for saving mutable data for each connection
    NSMutableDictionary* connectionsData;
    // dictinay for saving connection type of each connection
    NSMutableDictionary* connectionsHashTable;
    __weak id<OSConnectionCompletionDelegate> delegate;
}

@property (nonatomic,strong)    NSMutableDictionary* connectionsData;
@property (nonatomic,strong)    NSMutableDictionary* connectionsHashTable;
@property (nonatomic,weak)    id<OSConnectionCompletionDelegate> delegate;

+(OSConnectionManager*)sharedManager;
-(BOOL)StartConnection:(OSConnectionType)connectionType;

@end

