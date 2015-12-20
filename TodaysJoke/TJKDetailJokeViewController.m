//
//  TJKDetailJokeViewController.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/19/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import "TJKDetailJokeViewController.h"

@interface TJKDetailJokeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *jokeTitle;
@property (weak, nonatomic) IBOutlet UITextField *jokeCategory;
@property (weak, nonatomic) IBOutlet UITextView *joke;

@end

@implementation TJKDetailJokeViewController

-(void)viewDidLoad
{
    UIColor *borderColor = [UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1.0];

    self.joke.layer.borderWidth = 1.0f;
    self.joke.layer.borderColor = borderColor.CGColor;
    self.joke.layer.cornerRadius = 5.0;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
