//
//  AnswerViewController.m
//  NTT Data Job Application App
//
//  Created by Hilal Yavuz on 10/2/13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "AnswerViewController.h"
@interface AnswerViewController()
@property (strong, nonatomic) IBOutlet UITextView *answerText;


@end

@implementation AnswerViewController
@synthesize answerText;
@synthesize text;

@synthesize question;

-(void)viewDidAppear:(BOOL)animated
{
    

    NSString *q = [NSString stringWithFormat:@"%@\n\n",self.question];
    self.answerText.text = [q stringByAppendingString:text];
    
    // self.questionLabel.text = self.question;
    
    
}



@end