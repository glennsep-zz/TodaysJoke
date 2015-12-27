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

// this sets up the navigation bar
-(void)setupNavBar
{
    // setup title of navigation bar
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = @"Today's Joke";
    
    // create a custom button for the left menu
    UIButton *leftMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftMenuButton setImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [leftMenuButton addTarget:self action:@selector(displayLeftMenu:) forControlEvents:UIControlEventTouchUpInside];
    [leftMenuButton setFrame:CGRectMake(0,0,20,20)];
    
    // create a new bar button to display the menu
    UIBarButtonItem *leftMenu = [[UIBarButtonItem alloc] initWithCustomView:leftMenuButton];
    
    // create a new bar button item to add a new joke
    UIBarButtonItem *addJoke = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(addNewJoke:)];
    
    // setup the left bar button in the navigation bar
    navItem.leftBarButtonItem = leftMenu;
    
    // setup bar buttom as right item in navigation bar
    navItem.rightBarButtonItem = addJoke;
}

#pragma Actions

// display the screen to add a new joke
-(IBAction)addNewJoke:(id)sender
{
    // create a new joke item
    TJKJokeItem *newJoke = [[TJKJokeItemStore sharedStore] createItem];
    
    // create a instance of the joke view controller
    TJKDetailJokeViewController *detailJokeViewController = [[TJKDetailJokeViewController alloc] initForNewItem:YES];
    detailJokeViewController.jokeItem = newJoke;
    
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:detailJokeViewController];
    
    // display joke detail screen
    [self presentViewController:navController animated:YES completion:NULL];
}

@end
