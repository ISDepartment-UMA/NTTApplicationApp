

#import <Foundation/Foundation.h>
#import "OSAPIManager.h"
#import "Constants.h"
@interface OSURLHelper : NSObject

+(OSURLHelper*)sharedHelper;
-(NSURL*)getUrl:(OSConnectionType)connectionType;
@end	
