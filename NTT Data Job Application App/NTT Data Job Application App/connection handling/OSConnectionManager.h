
#import "OSURLHelper.h"
#import <Foundation/Foundation.h>
#import "Constants.h"
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
-(void)connectionSuccess:(OSConnectionType)connectionType withDataInArray:(NSArray*)array;
@end

@interface OSConnectionManager : NSObject<NSURLConnectionDataDelegate>


@property (nonatomic,strong)    NSMutableDictionary* connectionsData;
@property (nonatomic,strong)    NSMutableDictionary* connectionsHashTable;
@property (nonatomic,weak)    id<OSConnectionCompletionDelegate> delegate;

@property (nonatomic,strong) NSMutableDictionary* searchObject;
+(OSConnectionManager*)sharedManager;
-(BOOL)StartConnection:(OSConnectionType)connectionType;

@end

