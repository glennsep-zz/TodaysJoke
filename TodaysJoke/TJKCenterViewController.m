//
//  TJKCenterViewController.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/31/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import "TJKCenterViewController.h"

@interface TJKCenterViewController ()
@property (weak, nonatomic) IBOutlet UITextView *jokeTitle;
@property (weak, nonatomic) IBOutlet UILabel *jokeCategory;
@property (weak, nonatomic) IBOutlet UILabel *jokeSubmitted;
@property (weak, nonatomic) IBOutlet UITextView *joke;


@end

@implementation TJKCenterViewController

#pragma View Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // initialize property values
    self.leftButton = 1;
   
    // display today's date
    NSDateFormatter *todaysDate = [[NSDateFormatter alloc] init];
    [todaysDate setDateStyle:NSDateFormatterFullStyle];
    
    NSDate *now = [[NSDate alloc] init];
    
    NSString *theDate = [todaysDate stringFromDate:now];
    NSString *jokeTitleString = [@"Joke of the day for " stringByAppendingString:theDate];
    self.jokeTitle.text = jokeTitleString;
    [self.jokeTitle setTextColor:[[UIColor alloc] initWithRed:84/256.0 green:174/256.0 blue:166/256.0 alpha:1]];
    [self.jokeTitle setFont:[UIFont systemFontOfSize:17]];
    self.jokeTitle.textAlignment = NSTextAlignmentCenter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Action Methods
- (void)btnMovePanelRight:(id)sender
{
    switch (self.leftButton)
    {
        case 0:
        {
            [_delegate movePanelToOriginalPosition];
            break;
        }
            
        case 1:
        {
            [_delegate movePanelRight];
            break;
        }
            
        default:
            break;
    }
}

@end
