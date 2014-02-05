//
//  TutorialViewController.m
//  NTT Data Job Application App
//
//  Created by Karim Makhlouf on 2/3/14.
//  Copyright (c) 2014 University of Mannheim - NTT Data Team Project. All rights reserved.
//

#import "TutorialViewController.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initStyle];
	// Do any additional setup after loading the view.
}

-(void)initStyle
{
    self.mainView.frame = CGRectMake(0, 0, 2560, 568);
    [self.mainView removeFromSuperview];
    [self.scrollView addSubview:self.mainView];
    [self.scrollView setContentSize:self.mainView.frame.size];
    for (int i =1; i<= 10; i++)
    {
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%i.png",i]]];
        [imageView setFrame:CGRectMake(320*(i-1), 0, 320, 568)];
        [self.mainView addSubview:imageView];
        [self.navigationController setNavigationBarHidden:YES];
        [self.tabBarController.tabBar setHidden:YES];
    }
}

-(IBAction)move:(id)sender
{
    if (self.scrollView.contentOffset.x <320*9) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x +320, 0) animated:YES];
        self.pager.currentPage = self.pager.currentPage +1;
    }
    else
    {
        [self.navigationController setNavigationBarHidden:NO];
        [self.tabBarController.tabBar setHidden:NO];
        
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        [[AppSettingsHelper sharedHelper] setSetting:NO];
    }
}
-(IBAction)remove:(id)sender
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.tabBarController.tabBar setHidden:NO];
    
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [[AppSettingsHelper sharedHelper] setSetting:NO];
}

@end
