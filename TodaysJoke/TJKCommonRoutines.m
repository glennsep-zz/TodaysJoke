//
//  TJKCommonRoutines.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 1/30/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import <CloudKit/Cloudkit.h>
#import "TJKCommonRoutines.h"
#import "TJKConstants.h"
#import "TJKCategories.h"

@interface TJKCommonRoutines()

#pragma Properties
@property (nonatomic, strong) NSArray *jokeCategories;

@end

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

// retrieve categories to list in table
-(void)retrieveCategories:(NSCache *)cacheLists
{
    // get all categories
    NSMutableArray *jokeCategories = [[NSMutableArray alloc] init];
    CKDatabase *jokePublicDatabase = [[CKContainer containerWithIdentifier:JOKE_CONTAINER] publicCloudDatabase];
    NSPredicate *predicateCategory = [NSPredicate predicateWithFormat:@"CategoryName != %@", CATEGORY_TO_REMOVE_OTHER];
    CKQuery *queryCategory = [[CKQuery alloc] initWithRecordType:CATEGORY_RECORD_TYPE predicate:predicateCategory];
    NSSortDescriptor *sortCategory = [[NSSortDescriptor alloc] initWithKey:CATEGORY_FIELD_NAME ascending:YES];
    queryCategory.sortDescriptors = [NSArray arrayWithObjects:sortCategory, nil];
    [jokePublicDatabase performQuery:queryCategory inZoneWithID:nil completionHandler:^(NSArray<CKRecord*>* results, NSError * error)
     {
         if (!error)
         {
             // add all categories to array
             for (CKRecord* jokeCategory in results)
             {
                 TJKCategories *categories = [TJKCategories initWithCategory:[jokeCategory valueForKey:CATEGORY_FIELD_NAME] categoryImage:[jokeCategory valueForKey:CATEGORY_FIELD_IMAGE]];
                 [jokeCategories addObject:categories];
             }
             
             // store categories to cache
             [cacheLists setObject:jokeCategories forKey:CACHE_CATEGORY_LIST];
         }
     }];
}

// retrieve categories to list in picker when submitting a joke
-(void)retrieveCategoriesForPicker:(NSCache *)cacheLists
{
    // get all categories
    CKDatabase *jokePublicDatabase = [[CKContainer containerWithIdentifier:JOKE_CONTAINER] publicCloudDatabase];
    NSPredicate *predicateCategory = [NSPredicate predicateWithFormat:@"CategoryName != %@ && CategoryName != %@", CATEGORY_TO_REMOVE_RANDOM, CATEGORY_TO_REMOVE_FAVORITE];
    CKQuery *queryCategory = [[CKQuery alloc] initWithRecordType:CATEGORY_RECORD_TYPE predicate:predicateCategory];
    NSSortDescriptor *sortCategory = [[NSSortDescriptor alloc] initWithKey:CATEGORY_FIELD_NAME ascending:YES];
    queryCategory.sortDescriptors = [NSArray arrayWithObjects:sortCategory, nil];
    [jokePublicDatabase performQuery:queryCategory inZoneWithID:nil completionHandler:^(NSArray *results, NSError * error)
     {
         if (!error)
         {
             // load the array with joke categories
             _jokeCategories = [results valueForKey:CATEGORY_FIELD_NAME];
             
             // store categories to cache
             [cacheLists setObject:_jokeCategories forKey:CACHE_CATEGORY_PICKER];
             
         }
     }];
}

@end

// possibly another solution to changing navigation title and color and font size
//UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.view.bounds.size.width - 100, 44)];
//titleLabel.text = self.categoryName;
//titleLabel.font = [UIFont systemFontOfSize:16];
//titleLabel.textColor = [UIColor redColor];
//self.navigationItem.titleView = titleLabel;