

#import <Foundation/Foundation.h>
#import "OSAPIManager.h"
@interface OSURLHelper : NSObject

+(OSURLHelper*)sharedHelper;
-(NSURL*)getUrl:(OSConnectionType)connectionType;
@end	
