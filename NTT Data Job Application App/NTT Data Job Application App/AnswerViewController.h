//
//  AnswerViewController.h
//  NTT Data Job Application App
//
//  Created by Hilal Yavuz on 10/2/13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AnswerViewController : UIViewController{

    IBOutlet UISlider *ratingSlider;
    IBOutlet UILabel *ratingValue;
    IBOutlet UIButton *ratingButton;
}


@property (nonatomic,strong)NSString* question;
@property (strong, nonatomic)NSString* text;

@end
