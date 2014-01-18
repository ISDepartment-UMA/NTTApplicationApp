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
@property (strong,nonatomic)NSArray* faqArray;
@property (weak, nonatomic) IBOutlet UIImageView *starEmpty1;
@property (weak, nonatomic) IBOutlet UIImageView *starFull1;
@property (weak, nonatomic) IBOutlet UIImageView *starFull2;
@property (weak, nonatomic) IBOutlet UIImageView *starEmpty2;
@property (weak, nonatomic) IBOutlet UIImageView *starEmpty3;
@property (weak, nonatomic) IBOutlet UIImageView *starFull3;
@property (weak, nonatomic) IBOutlet UIImageView *starEmpty4;
@property (weak, nonatomic) IBOutlet UIImageView *starFull4;
@property (weak, nonatomic) IBOutlet UIImageView *starEmpty5;
@property (weak, nonatomic) IBOutlet UIImageView *starFull5;

@end

@implementation AnswerViewController
@synthesize answerText;
@synthesize text;
@synthesize question;
@synthesize faq;
@synthesize faqArray;

-(void)viewDidLoad {
    self.starFull1.hidden=YES;
    self.starFull2.hidden=YES;
    self.starFull3.hidden=YES;
    self.starFull4.hidden=YES;
    self.starFull5.hidden=YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    self.answerQuestion.text = self.question;
    self.answerQuestion.numberOfLines = 3;
    self.answerText.text = self.text;
  
    
}



-(IBAction)changeSliderValue
{
    ratingValue.text = [[NSString alloc] initWithFormat:@"%.0f" ,ratingSlider.value];
    
    if ([ratingValue.text isEqualToString: @"0"]) {
        self.starEmpty1.hidden=NO;
        self.starEmpty2.hidden=NO;
        self.starEmpty3.hidden=NO;
        self.starEmpty4.hidden=NO;
        self.starEmpty5.hidden=NO;
        self.starFull1.hidden=YES;

    }
    else if ([ratingValue.text isEqualToString: @"1"]) {
        self.starEmpty1.hidden=YES;
        self.starEmpty2.hidden=NO;
        self.starEmpty3.hidden=NO;
        self.starEmpty4.hidden=NO;
        self.starEmpty5.hidden=NO;
        self.starFull1.hidden=NO;
        self.starFull2.hidden=YES;
        self.starFull3.hidden=YES;
        self.starFull4.hidden=YES;
        self.starFull5.hidden=YES;
        
    }
    else if ([ratingValue.text isEqualToString: @"2"]) {
        self.starEmpty1.hidden=YES;
        self.starEmpty2.hidden=YES;
        self.starEmpty3.hidden=NO;
        self.starEmpty4.hidden=NO;
        self.starEmpty5.hidden=NO;
        self.starFull1.hidden=NO;
        self.starFull2.hidden=NO;
        self.starFull3.hidden=YES;
        self.starFull4.hidden=YES;
        self.starFull5.hidden=YES;
    }
    else if ([ratingValue.text isEqualToString: @"3"]) {
        self.starEmpty1.hidden=YES;
        self.starEmpty2.hidden=YES;
        self.starEmpty3.hidden=YES;
        self.starEmpty4.hidden=NO;
        self.starEmpty5.hidden=NO;
        self.starFull1.hidden=NO;
        self.starFull2.hidden=NO;
        self.starFull3.hidden=NO;
        self.starFull4.hidden=YES;
        self.starFull5.hidden=YES;
    }
    else if ([ratingValue.text isEqualToString: @"4"]) {
        self.starEmpty1.hidden=YES;
        self.starEmpty2.hidden=YES;
        self.starEmpty3.hidden=YES;
        self.starEmpty4.hidden=YES;
        self.starEmpty5.hidden=NO;
        self.starFull1.hidden=NO;
        self.starFull2.hidden=NO;
        self.starFull3.hidden=NO;
        self.starFull4.hidden=NO;
        self.starFull5.hidden=YES;
    }
    else if ([ratingValue.text isEqualToString: @"5"]) {
        self.starEmpty1.hidden=YES;
        self.starEmpty2.hidden=YES;
        self.starEmpty3.hidden=YES;
        self.starEmpty4.hidden=YES;
        self.starEmpty5.hidden=YES;
        self.starFull1.hidden=NO;
        self.starFull2.hidden=NO;
        self.starFull3.hidden=NO;
        self.starFull4.hidden=NO;
        self.starFull5.hidden=NO;
    }
    
}

- (void)connectionSuccess:(OSConnectionType)connectionType withDataInArray:(NSArray *)array{
    NSLog(@"%@",array);
}

-(IBAction)selectedRatingButton{
    
    NSString* faqId = [NSString stringWithFormat:@"%@",faq.faqId];
    [[OSConnectionManager sharedManager].searchObject setObject:ratingValue.text forKey:@"rate"];
    [[OSConnectionManager sharedManager].searchObject setObject:faqId forKey:@"faq"];
    [OSConnectionManager sharedManager].delegate = self;
    UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Rating" message:[NSString stringWithFormat:@"You rated this answer with %@", ratingValue.text] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [errorMessage show];
    
    //[[OSConnectionManager sharedManager].searchObject setObject:filter.uuid forKey:@"uuid"];
  //  NSNumber* rating = [NSNumber numberWithFloat:ratingSlider.value];
  //  [[DatabaseManager sharedInstance]createRatingForFaq:faq withValue:rating];
    
    [[OSConnectionManager sharedManager]StartConnection:OSCGetFaqRating];

}

@end