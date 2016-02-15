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
    [navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[self StandardSystemColor]}];
}

// set the navigation bar title image
-(void)setupNavigationBarTitle:(UINavigationItem *)navItem setImage:(NSString *)image
{
    UIImage *img = [UIImage imageNamed:image];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,100,40)];
    [imageView setImage:img];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    navItem.titleView = imageView;
}

// return the stanard color used in the application
-(UIColor *)StandardSystemColor
{
    UIColor *standardColor = [[UIColor alloc] initWithRed:84/256.0 green:174/256.0 blue:166/256.0 alpha:1];
    return standardColor;
}

@end
