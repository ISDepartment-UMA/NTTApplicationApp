//
//  AppSettingsHelper.m
//  NTT Data Job Application App
//
//  Created by Karim Makhlouf on 2/3/14.
//  Copyright (c) 2014 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "AppSettingsHelper.h"

@implementation AppSettingsHelper

static AppSettingsHelper *sharedHelper = nil;
#pragma mark -
#pragma mark singilton init methods
// alloce shared API singelton
+ (id)alloc
{
	@synchronized(self)
    {
		NSAssert(sharedHelper == nil, @"Attempted to allocate a second instance of a singleton.");
		return [super alloc];
	}
	return nil;
}
// Init shared API singelton
+ (AppSettingsHelper*)sharedHelper
{
	@synchronized(self)
    {
		if (!sharedHelper)
            
			sharedHelper = [[AppSettingsHelper alloc] init];
        
	}
	return sharedHelper;
}
- (id) init
{
	if ((self=[super init]))
    {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        NSString* file= [documentDirectory stringByAppendingPathComponent:@"settings.plist"];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:file])
        {
            self.settingsList = [[NSMutableArray alloc] initWithContentsOfFile:file];
        }
        else
        {
            self.settingsList= [[NSMutableArray alloc]init];
            for (int i =0; i<100;i++)
            {
                [self.settingsList addObject:@"nil"];
            }
        }
	}
	return self;
}
#pragma mark - USER SETTING CONTROL
/**
 *	set user setting value
 *
 *	@param	setting	setting to set
 *	@param	value	setting value
 */
-(void)setSetting:(BOOL)isOn
{
    [self.settingsList replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%i",isOn]];
    [sharedHelper commiteSetting];
}

/**
 *	get setting value
 *
 *	@param	setting	setting to get
 *
 *	@return	string value of this setting
 */
-(BOOL)getSetting
{
    
    return [[self.settingsList objectAtIndex:0]boolValue];
}
/**
 *	check setting option has value
 *
 *	@param	setting	setting to check
 *
 *	@return	if have value
 */
-(BOOL)checkSettingFound
{
    return ![[self.settingsList objectAtIndex:0] isEqualToString:@"nil"];
}
/**
 *	remove setting value from list
 *
 *	@param	setting	option to remove it's value
 */
-(void)removeSetting
{
    [self.settingsList replaceObjectAtIndex:0 withObject:@"nil"];
    [sharedHelper commiteSetting];
}


-(void)commiteSetting
{
    [self.settingsList writeToFile:[sharedHelper getFileDataPath] atomically:YES];
}
// get file name of given type and give full path of that files
/**
 *	get Full path of saved file for this connection type
 *
 *	@param	connectionType	the type of connection we want to get his file path
 *
 *	@return	file path of data file of this connection type
 */
-(NSString*)getFileDataPath
{
    NSString* fileName =[NSString stringWithFormat:@"settings.plist"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [paths objectAtIndex:0];
	return [documentDirectory stringByAppendingPathComponent:fileName];
}
@end
