//
//  TJKCategoriesViewController.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 1/3/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import "TJKCategoriesViewController.h"
#import "TJKListJokesViewController.h"
#import "TJKAppDelegate.h"
#import "TJKCategories.h"
#import "GHSAlerts.h"
#import "TJKCommonRoutines.h"

@interface TJKCategoriesViewController () 

@property (nonatomic, weak) IBOutlet UITableView *categoriesTableView;
@property (nonatomic, weak) IBOutlet UITableViewCell *cellCategories;
@property (strong, nonatomic) NSMutableArray *jokeCategories;
@property (strong, nonatomic) NSString * selectedCategoryName;
@end

@implementation TJKCategoriesViewController

#pragma Initializers

// init the NIB
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

#pragma View Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
       
    // restrict to portrait mode if iphone
    [self restrictRotation:YES];
    
    // set the title and color
    self.title = @"Categories";
    TJKCommonRoutines *common = [[TJKCommonRoutines alloc] init];
    self.navigationController.navigationBar.tintColor = [common StandardSystemColor];
    
    // get all categories
    _jokeCategories = [[NSMutableArray alloc] init];
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
                 [_jokeCategories addObject:categories];
             }
             
             // setup table
             [self setupTableContents];
         }
         else
         {
             // display alert message and pop the view controller from the stack
             GHSAlerts *alert = [[GHSAlerts alloc] initWithViewController:self];
             errorActionBlock errorBlock = ^void(UIAlertAction *action) {[self closeCategories:self];};
             [alert displayErrorMessage:@"Oops!" errorMessage:@"The joke categories failed to load. This screen will close. Just try again!" errorAction:errorBlock];
         }
     }];
}

#pragma Methods

// setup the array that will hold the table's contents
-(void)setupTableContents
{   
    // store to property and reload the table contents
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.categoriesTableView reloadData];
    });
}

// close the category screen
-(void)closeCategories:(id)sender
{
    // pop the view controller from the stack
    [self.navigationController popViewControllerAnimated:YES];
}

// restrict to portrait mode for iphone
-(void) restrictRotation:(BOOL) restriction
{
    TJKAppDelegate* appDelegate = (TJKAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.restrictRotation = restriction;
}

#pragma Table View Methods

// indicate the number of sections
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// indicate the number of rows in section
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_jokeCategories count];
}

// set the row height to fit the images
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

// display the contents of the table
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    static NSString *cellMainNibId = @"cellCategories";
    
    _cellCategories = [tableView dequeueReusableCellWithIdentifier:cellMainNibId];
    if (_cellCategories == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"TJKCategoriesCell" owner:self options:nil];
    }
    
    // create the objects to populate the cell
    UIImageView *categoryImage = (UIImageView *)[_cellCategories viewWithTag:1];
    UILabel *categoryName = (UILabel *)[_cellCategories viewWithTag:2];
    
    if ([_jokeCategories count] > 0)
    {
        TJKCategories *currentRecord = [self.jokeCategories objectAtIndex:indexPath.row];
        
        categoryName.text =  [NSString stringWithFormat:@"%@", currentRecord.categoryName];
        categoryImage.image = currentRecord.categoryImage;
        self.selectedCategoryName = categoryName.text;
    }
    
    return _cellCategories;
}

// display the list of categories
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    // setup call to list jokes table
    TJKListJokesViewController *listJokesController = [[TJKListJokesViewController alloc] init];
    TJKCategories *currentCell = [self.jokeCategories objectAtIndex:indexPath.row];
    listJokesController.categoryName = currentCell.categoryName;
    
    // push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:listJokesController animated:YES];
}

@end
