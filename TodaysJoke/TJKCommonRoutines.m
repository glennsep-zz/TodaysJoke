//
//  TJKCommonRoutines.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 1/30/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import "TJKCommonRoutines.h"

@implementation TJKCommonRoutines

#pragma Methods

// set the navigation title and color
-(void)setupNavigationBarTitle:(UINavigationController *)navController setTitle:(NSString *)title
{
    [navController.navigationBar.topItem setTitle:title];
    [navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[[UIColor alloc] initWithRed:84/256.0 green:174/256.0 blue:166/256.0 alpha:1]}];
}

@end
