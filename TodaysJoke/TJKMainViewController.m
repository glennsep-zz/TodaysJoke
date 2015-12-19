//
//  TJKMainViewController.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/16/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import "TJKMainViewController.h"
#import "TJKDetailJokeViewController.h"
#import "TJKJokeItemStore.h"
#import "TJKJokeItem.h"

@implementation TJKMainViewController

#pragma Methods
-(void)setupNavBar
{
    // setup title of navigation bar
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = @"Today's Joke";
    
    // create a new bar button item to add a new joke
    UIBarButtonItem *addJoke = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(addNewJoke:)];
    
    // setup bar buttom as right item in navigation bar
    navItem.rightBarButtonItem = addJoke;
}

// display the screen to add a new joke
-(IBAction)addNewJoke:(id)sender
{
    // create a instance of the joke view controller
    TJKDetailJokeViewController *detailJokeViewController = [[TJKDetailJokeViewController alloc] init];
    
    // display joke detail screen
    [self.navigationController pushViewController:detailJokeViewController animated:YES];
}

@end
