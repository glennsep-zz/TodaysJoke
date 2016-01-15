//
//  TJKJokeSubmission.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 1/11/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import "TJKJokeSubmissionController.h"

@interface TJKJokeSubmissionController ()

@end

@implementation TJKJokeSubmissionController

#pragma Initializers

// setup the navigation bar for the joke submission help screen
-(instancetype)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self)
    {
        if (isNew)
        {
            // create done button
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                           target:self
                                           action:@selector(closeJokeHelp:)];
            self.navigationItem.leftBarButtonItem = doneItem;
        }
    }
    
    return self;
}

// override the UIViewController's designated initializer to prevent its use, we want to
// use initForNewItem instead
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    [NSException raise:@"Wrong Initializer"
                format:@"Use initForNewItem:"];
    return nil;
}


#pragma View Controller Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Methods
// close the help screen
-(void)closeJokeHelp:(id)sender
{
    // close the screen
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end
