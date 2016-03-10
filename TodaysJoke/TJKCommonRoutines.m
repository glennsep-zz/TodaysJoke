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
    [navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[self standardSystemColor]}];
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

// setup the navigation title and color when a view controller is pushed to the stack
-(void)setupNavigationBarTitle:(UINavigationController *)navController fontName:(NSString *)fontName fontSize:(CGFloat)fontSize
{
    NSArray *keys = [NSArray arrayWithObjects: NSForegroundColorAttributeName, NSFontAttributeName, nil];
    NSArray *objs = [NSArray arrayWithObjects: [self standardNavigationBarTitleColor], [UIFont fontWithName:fontName size:fontSize], nil];
    navController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjects:objs forKeys:keys];
}

// return the stanard color used in the application
-(UIColor *)standardSystemColor
{
    UIColor *standardColor = [[UIColor alloc] initWithRed:84/256.0 green:174/256.0 blue:166/256.0 alpha:1];
    return standardColor;
}

// set the stanard color for the navigation bar
-(UIColor *)standardNavigationBarColor
{
    UIColor *standardColor = [[UIColor alloc] initWithRed:248 green:248 blue:248 alpha:1];
    return standardColor;
}

// set the color for the title in the navigation bar
-(UIColor *)standardNavigationBarTitleColor
{
    UIColor *titleColor = [[UIColor alloc] initWithRed:52/256.0 green:75/256.0 blue:105/256.0 alpha:1];
    return titleColor;
}

@end

// possibly another solution to changing navigation title and color and font size
//UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.view.bounds.size.width - 100, 44)];
//titleLabel.text = self.categoryName;
//titleLabel.font = [UIFont systemFontOfSize:16];
//titleLabel.textColor = [UIColor redColor];
//self.navigationItem.titleView = titleLabel;