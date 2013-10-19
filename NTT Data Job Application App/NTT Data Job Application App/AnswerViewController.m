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

@property (weak, nonatomic) IBOutlet UILabel *answerQuestion;

@end

@implementation AnswerViewController
@synthesize answerText;
@synthesize text;

@synthesize question;

-(void)viewDidAppear:(BOOL)animated
{
    self.answerQuestion.text = self.question;
    self.answerQuestion.numberOfLines = 3;
    self.answerText.text = self.text;
}



@end