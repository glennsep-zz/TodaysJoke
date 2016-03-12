//
//  TJKCommonRoutines.h
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 1/30/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJKCommonRoutines : NSObject

#pragma Methods
-(void)setupNavigationBarTitle:(UINavigationController *)navController setTitle:(NSString *)title;
-(void)setupNavigationBarTitle:(UINavigationItem *)navItem setImage:(NSString *)image;
-(void)setupNavigationBarTitle:(UINavigationController *)navController fontName:(NSString *)fontName fontSize:(CGFloat)fontSize;
-(UIColor *)standardSystemColor;
-(UIColor *)standardNavigationBarColor;
-(UIColor *)standardNavigationBarTitleColor;
-(void)retrieveCategories:(NSCache *) cacheLists;
-(void)retrieveCategoriesForPicker:(NSCache *) cacheLists;
@end
