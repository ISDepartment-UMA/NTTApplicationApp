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

-(IBAction)changeSliderValue
{
        ratingValue.text = [[NSString alloc] initWithFormat:@"%.0f" ,ratingSlider.value];
}

-(IBAction)selectedRatingButton{
    
    UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Rating" message:[NSString stringWithFormat:@"You rated this answer with %@", ratingValue.text] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [errorMessage show];

}

@end