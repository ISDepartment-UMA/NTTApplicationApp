




#import <UIKit/UIKit.h>
@interface OSAPIManager : NSObject

+(OSAPIManager*)sharedManager;
@property (nonatomic,strong) NSMutableDictionary* searchObject;

@end
