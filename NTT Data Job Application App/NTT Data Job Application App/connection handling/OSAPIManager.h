




#import <UIKit/UIKit.h>
@interface OSAPIManager : NSObject
{
    // active objects are the objects that we can fill with what we want as temp parameter
    NSMutableDictionary* flashObjects;
    NSMutableDictionary* searchObject;
}
+(OSAPIManager*)sharedManager;


@property (nonatomic,strong) NSMutableDictionary* flashObjects;
@property (nonatomic,strong) NSMutableDictionary* searchObject;

//active object
// USER SETTINGS
@end
