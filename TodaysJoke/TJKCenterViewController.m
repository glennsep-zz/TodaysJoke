//
//  TJKCenterViewController.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/31/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import "TJKCenterViewController.h"
#import "TJKAppDelegate.h"
#import "TJKCommonRoutines.h"
#import "TJKConstants.h"

@interface TJKCenterViewController ()
@property (weak, nonatomic) IBOutlet UILabel *jokeTitle;
@property (weak, nonatomic) IBOutlet UILabel *jokeCategory;
@property (weak, nonatomic) IBOutlet UILabel *jokeSubmitted;
@property (weak, nonatomic) IBOutlet UITextView *joke;


@end

@implementation TJKCenterViewController

#pragma View Controller Methods

// actions to perform once view loads
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup instance to common routines
    TJKCommonRoutines *common = [[TJKCommonRoutines alloc] init];
    
    // setup the screen fonts, sizes, layout
    [self setupScreenLayout:common];
    
    // initialize property values
    self.leftButton = 1;
   
    // display today's date
    NSDateFormatter *todaysDate = [[NSDateFormatter alloc] init];
    [todaysDate setDateStyle:NSDateFormatterFullStyle];
    
    NSDate *now = [[NSDate alloc] init];
    
    NSString *theDate = [todaysDate stringFromDate:now];
    NSString *jokeTitleString = [@"Today's Joke for " stringByAppendingString:theDate];
    self.jokeTitle.text = jokeTitleString;
}

#pragma Methods

// setup fonts, sizes, colors
-(void)setupScreenLayout:(TJKCommonRoutines *)common
{
    [self.jokeTitle setFont:[UIFont fontWithName:FONT_NAME_LABEL size:FONT_SIZE_LABEL]];
    [self.jokeTitle setTextColor:[common textColor]];
    self.jokeTitle.textAlignment = NSTextAlignmentCenter;
    [self.jokeCategory setFont:[UIFont fontWithName:FONT_NAME_LABEL size:FONT_SIZE_LABEL]];
    [self.jokeCategory setTextColor:[common textColor]];
    [self.jokeSubmitted setFont:[UIFont fontWithName:FONT_NAME_LABEL size:FONT_SIZE_LABEL]];
    [self.jokeSubmitted setTextColor:[common textColor]];
    [self.joke setFont:[UIFont fontWithName:FONT_NAME_LABEL size:FONT_SIZE_LABEL]];
    [self.joke setTextColor:[common textColor]];
    [common setBorderForTextView:self.joke];
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
