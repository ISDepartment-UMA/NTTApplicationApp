//
//  TutorialViewController.h
//  NTT Data Job Application App
//
//  Created by Karim Makhlouf on 2/3/14.
//  Copyright (c) 2014 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIPageControl *pager;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@end
