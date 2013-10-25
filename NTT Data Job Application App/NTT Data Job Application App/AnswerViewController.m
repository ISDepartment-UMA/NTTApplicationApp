//
//  AnswerViewController.m
//  NTT Data Job Application App
//
//  Created by Hilal Yavuz on 10/2/13.
//  Copyright (c) 2013 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "AnswerViewController.h"
#import "DatabaseManager.h"
#import "OSConnectionManager.h"

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

-(IBAction)changeSliderValue {
        ratingValue.text = [[NSString alloc] initWithFormat:@"%.0f" ,ratingSlider.value];
}

-(IBAction)selectedRatingButton{
    
    if (ratingSlider.value == 0) {
        UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Rating" message:@"You rated this answer with 0" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [errorMessage show];
    }
    else if ([ratingValue.text  isEqual: @"1"]) {
         UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Rating" message:@"You rated this answer with 1" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [errorMessage show];
    }
    else if ([ratingValue.text  isEqual: @"2"]) {
        UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Rating" message:@"You rated this answer with 2" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [errorMessage show];
    }
    else if ([ratingValue.text  isEqual: @"3"]) {
        UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Rating" message:@"You rated this answer with 3" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [errorMessage show];
    }
    else if ([ratingValue.text  isEqual: @"4"]) {
        UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Rating" message:@"You rated this answer with 4" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [errorMessage show];
    }
    else if (ratingSlider.value == 5) {
        UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Rating" message:@"You rated this answer with 5" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [errorMessage show];
    }
}

@end