//
//  AppSettingsHelper.h
//  NTT Data Job Application App
//
//  Created by Karim Makhlouf on 2/3/14.
//  Copyright (c) 2014 University of Mannheim - NTT Data Team Project. All rights reserved.
//

@interface AppSettingsHelper : NSObject

+(AppSettingsHelper*)sharedHelper;

@property(nonatomic,strong) NSMutableArray* settingsList;

-(void)removeSetting;
-(BOOL)checkSettingFound;
-(BOOL)getSetting;
-(void)setSetting:(BOOL)isOn;
@end
