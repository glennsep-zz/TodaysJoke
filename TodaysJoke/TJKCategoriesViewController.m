//
//  TJKCategoriesViewController.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 1/3/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import "TJKCategoriesViewController.h"
#import "TJKAppDelegate.h"
#import "GHSAlerts.h"

@interface TJKCategoriesViewController () 

@property (nonatomic, weak) IBOutlet UITableView *categoriesTableView;
@property (nonatomic, weak) IBOutlet UITableViewCell *cellCategories;
@property (nonatomic, strong) NSMutableArray *tableContents;
@property (strong, nonatomic) NSArray *jokeCategories;

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
    
    // get all categories
    CKDatabase *jokePublicDatabase = [[CKContainer containerWithIdentifier:JOKE_CONTAINER] publicCloudDatabase];
    NSPredicate *predicateCategory = [NSPredicate predicateWithValue:YES];
    CKQuery *queryCategory = [[CKQuery alloc] initWithRecordType:@"Categories" predicate:predicateCategory];
    NSSortDescriptor *sortCategory = [[NSSortDescriptor alloc] initWithKey:@"CategoryName" ascending:YES];
    queryCategory.sortDescriptors = [NSArray arrayWithObjects:sortCategory, nil];
    [jokePublicDatabase performQuery:queryCategory inZoneWithID:nil completionHandler:^(NSArray* results, NSError * error)
     {
         if (!error)
         {
             // populate the joke category property
             _jokeCategories = [results valueForKey:@"CategoryName"];
             
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
    self.tableContents = [NSMutableArray arrayWithArray:_jokeCategories];
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
    return [_tableContents count];
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

    UILabel *creator = (UILabel *)[_cellCategories viewWithTag:3];
    
    if ([_tableContents count] > 0)
    {
        NSString *currentRecord = [self.tableContents objectAtIndex:indexPath.row];
        creator.text =  [NSString stringWithFormat:@"%@", currentRecord];
    }
    
    return _cellCategories;
}

@end
