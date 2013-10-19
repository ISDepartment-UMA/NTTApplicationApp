//
//  ApplicationViewController.h
//  NTT Data Job Application App
//
//  Created by Pavel Kurasov on 20.09.13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>



@interface ApplicationViewController : UIViewController<DBRestClientDelegate>


@property (strong, nonatomic)NSDictionary* openPosition;

@end
