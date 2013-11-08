//
//  DropBoxViewController.h
//  NTT Data Job Application App
//
//  Created by Yunhan Cheng on 10/18/13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import "ApplicationViewController.h"
#import "ApplicationViewController.h"


@interface DropBoxViewController : UIViewController<DBRestClientDelegate>
@property (nonatomic,strong)NSArray* dbFile;
@property (strong,nonatomic)DBRestClient* restClient;

@end
