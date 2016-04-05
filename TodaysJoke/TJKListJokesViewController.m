//
//  TJKListJokesViewController.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 2/11/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import "TJKListJokesViewController.h"
#import "TJKDisplayJokesController.h"
#import "TJKAppDelegate.h"
#import "TJKJokeItemStore.h"
#import "TJKJokeItem.h"
#import "GHSAlerts.h"
#import "TJKConstants.h"
#import "TJKCommonRoutines.h"

@interface TJKListJokesViewController ()

#pragma Properties
@property (weak, nonatomic) IBOutlet UITableView *listJokesTableView;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellJokeList;
@property (nonatomic, strong) NSArray<TJKJokeItem*> *jokeList;
@property (nonatomic, strong) UIColor *jokeTextColor;
@property (nonatomic, strong) UIColor *jokeCategoryColor;
@end

@implementation TJKListJokesViewController

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

#pragma View controller methods

// routines to run when view loads
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // retrieve all of the jokes
    [[TJKJokeItemStore sharedStore] retrieveFavoritesFromArchive];
    
    // restrict to portrait mode if iphone
    [self restrictRotation:YES];
    
    // get all the jokes for the category
    [self fetchJokesForCategory];
}

// routines to run when view appears
-(void)viewWillAppear:(BOOL)animated
{
    // retrieve all of the jokes
    [[TJKJokeItemStore sharedStore] retrieveFavoritesFromArchive];
    
    // set the title
    self.title = self.categoryName;
    TJKCommonRoutines *common = [[TJKCommonRoutines alloc] init];
    self.navigationController.navigationBar.tintColor = [common standardSystemColor];
    [common setupNavigationBarTitle:self.navigationController fontName:FONT_NAME_HEADER fontSize:FONT_SIZE_HEADER];

    
    // set the joke text color in the table
    self.jokeTextColor = [common textColor];
    self.jokeCategoryColor = [common categoryColor];
    
    // reload the table data
    self.jokeList = [[TJKJokeItemStore sharedStore] allItems];
    [self.listJokesTableView reloadData];
}

#pragma Methods
// restrict to portrait mode for iphone
-(void) restrictRotation:(BOOL) restriction
{
    TJKAppDelegate* appDelegate = (TJKAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.restrictRotation = restriction;
}

// set the table contents
-(void)setupTableContents
{
    // store to property and reload the table contents
    dispatch_async(dispatch_get_main_queue(), ^{
        self.jokeList = [[TJKJokeItemStore sharedStore] allItems];
        [self.listJokesTableView reloadData];
    });
}

// retrieve all the jokes that belong to the selected category
-(void)fetchJokesForCategory
{
    // determine if jokes are fetched for a single or all categories
    if ([self.categoryName isEqualToString:CATEGORY_TO_REMOVE_RANDOM])
    {
        [self fetchJokesForAllCategories];
    }
    else if ([self.categoryName isEqualToString:CATEGORY_FIELD_FAVORITE])
    {
        [self fetchFavoriteJokes];
    }
    else
    {
        [self fetchJokesForSingleCategory];
    }
}

// get jokes for a single category
-(void)fetchJokesForSingleCategory
{
    // retrieve the record information for the joke category
    CKDatabase *jokePublicDatabase = [[CKContainer containerWithIdentifier:JOKE_CONTAINER] publicCloudDatabase];
    NSPredicate *predicateCategories = [NSPredicate predicateWithFormat:@"CategoryName == %@", self.categoryName];
    CKQuery *queryCategories = [[CKQuery alloc] initWithRecordType:CATEGORY_RECORD_TYPE predicate:predicateCategories];
    [jokePublicDatabase performQuery:queryCategories inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error)
     {
         if (!error)
         {
             // get the first record as there should only be one record per category
             CKRecord *categoryRecord = [results firstObject];
             
             // setup the table
             [self setupTableContents];
             
             if (categoryRecord)
             {
                 // now that we have the record id for the joke category get the jokes
                 NSPredicate *predicateJokes = [NSPredicate predicateWithFormat:@"CategoryName == %@",categoryRecord];
                 CKQuery *jokeQuery = [[CKQuery alloc] initWithRecordType:JOKE_RECORD_TYPE predicate:predicateJokes];
                 [jokePublicDatabase performQuery:jokeQuery inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * results, NSError * error)
                  {
                      if (!error)
                      {
                          for (CKRecord *jokeRecord in results)
                          {
                              // add the joke to the joke item store (array)
                              [[TJKJokeItemStore sharedStore] createItem:[jokeRecord objectForKey:JOKE_DESCR] jokeCategory:self.categoryName nameSubmitted:[jokeRecord objectForKey:JOKE_SUBMITTED_BY] jokeTitle:[jokeRecord objectForKey:JOKE_TITLE] categoryRecordName:[jokeRecord valueForKey:CATEGORY_FIELD_NAME] jokeCreated:[jokeRecord valueForKey:JOKE_CREATED] jokeRecordName:jokeRecord.recordID.recordName];
                          }
                          
                          // setup the table
                          [self setupTableContents];
                      }
                      else
                      {
                          // instantiate the alert object
                          GHSAlerts *alerts = [[GHSAlerts alloc] initWithViewController:self];
                          [alerts displayErrorMessage:@"Problem" errorMessage:@"Cannot retrieve the jokes for the category."];
                          return;
                      }
                  }];
             }
         }
         else
         {
             // instantiate the alert object
             GHSAlerts *alerts = [[GHSAlerts alloc] initWithViewController:self];
             [alerts displayErrorMessage:@"Problem" errorMessage:@"Cannot retrieve the jokes for the category."];
             return;
         }
     }];
}

// get favorite jokes
-(void)fetchFavoriteJokes
{
    // remove any joke items
    [[TJKJokeItemStore sharedStore] removeAllItems];
    
    // get all the favorite jokes
    NSArray *favorites = [[TJKJokeItemStore sharedStore] retrieveFavoritesFromStore];
    
    // loop through favorites and add jokes to the joke item store
    for (id jokeRecord in favorites)
    {
        // add the joke to the joke item store (array)
        [[TJKJokeItemStore sharedStore] createItem:[jokeRecord valueForKey:JOKE_DESCR] jokeCategory:[jokeRecord valueForKey:JOKE_CATEGORY] nameSubmitted:[jokeRecord valueForKey:JOKE_NAME_SUBMITTED] jokeTitle:[jokeRecord valueForKey:JOKE_TITLE] categoryRecordName:[jokeRecord valueForKey:CATEGORY_RECORD_NAME] jokeCreated:[jokeRecord valueForKey:JOKE_DATE] jokeRecordName:[jokeRecord valueForKey:JOKE_ID]];
    }
    
    // randomize the jokes
    [[TJKJokeItemStore sharedStore] randomizeItems];
    
    // setup the table
    [self setupTableContents];
}

// get jokes for all categories
-(void)fetchJokesForAllCategories
{
    // retrieve the record information for the joke category
    CKDatabase *jokePublicDatabase = [[CKContainer containerWithIdentifier:JOKE_CONTAINER] publicCloudDatabase];
    NSPredicate *predicateCategories = [NSPredicate predicateWithFormat:@"CategoryName != %@", CATEGORY_ALL];
    CKQuery *queryCategories = [[CKQuery alloc] initWithRecordType:CATEGORY_RECORD_TYPE predicate:predicateCategories];
    [jokePublicDatabase performQuery:queryCategories inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error)
     {
         if (!error)
         {
             // get the first record as there should only be one record per category
             for (CKRecord *categoryRecord in results)
             {                
                 // setup the table
                 [self setupTableContents];
                 
                 if (categoryRecord)
                 {
                     // now that we have the record id for the joke category get the jokes
                     NSPredicate *predicateJokes = [NSPredicate predicateWithFormat:@"CategoryName == %@",categoryRecord];
                     CKQuery *jokeQuery = [[CKQuery alloc] initWithRecordType:JOKE_RECORD_TYPE predicate:predicateJokes];
                     [jokePublicDatabase performQuery:jokeQuery inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * results, NSError * error)
                      {
                          if (!error)
                          {
                              for (CKRecord *jokeRecord in results)
                              {
                                  // add the joke to the joke item store (array)
                                  [[TJKJokeItemStore sharedStore] createItem:[jokeRecord objectForKey:JOKE_DESCR] jokeCategory:[categoryRecord objectForKey:CATEGORY_FIELD_NAME] nameSubmitted:[jokeRecord objectForKey:JOKE_SUBMITTED_BY] jokeTitle:[jokeRecord objectForKey:JOKE_TITLE] categoryRecordName:[jokeRecord valueForKey:CATEGORY_FIELD_NAME] jokeCreated:[jokeRecord valueForKey:JOKE_CREATED] jokeRecordName:jokeRecord.recordID.recordName];
                              }
                              
                              // randomize the jokes
                              [[TJKJokeItemStore sharedStore] randomizeItems];
                              
                              // setup the table
                              [self setupTableContents];
                          }
                          else
                          {
                              // instantiate the alert object
                              GHSAlerts *alerts = [[GHSAlerts alloc] initWithViewController:self];
                              [alerts displayErrorMessage:@"Problem" errorMessage:@"Cannot retrieve the jokes for the category."];
                              return;
                          }
                      }];
                 }
             }
         }
         else
         {
             // instantiate the alert object
             GHSAlerts *alerts = [[GHSAlerts alloc] initWithViewController:self];
             [alerts displayErrorMessage:@"Problem" errorMessage:@"Cannot retrieve the jokes for the category."];
             return;
         }
     }];
}

#pragma Table View Methods

// indicate the number of sections in the table
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// indicate the number of rows in the section
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[TJKJokeItemStore sharedStore] allItems] count];
}

// set the row height to fit the images
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

// display the contents of the table
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    // get the cell name
    static NSString *cellMainNibId = @"cellJokeList";
    
    // get a new or recycled cell
    _cellJokeList = [tableView dequeueReusableCellWithIdentifier:cellMainNibId];
    if (_cellJokeList == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"TJKListJokesCell" owner:self options:nil];
    }
    
    // create objects to populate the cell
    UILabel *jokeTitle = (UILabel *)[_cellJokeList viewWithTag:1];
    UILabel *jokeCategory = (UILabel *)[_cellJokeList viewWithTag:2];
    
    // retrieve all jokes
    NSArray *items = [[TJKJokeItemStore sharedStore] allItems];
    if ([items count] > 0)
    {
        TJKJokeItem *jokeItem = items[indexPath.row];
        jokeTitle.text = [NSString stringWithFormat:@"%@", jokeItem.jokeTitle];
        [jokeTitle setFont:[UIFont fontWithName:FONT_NAME_TEXT size:FONT_SIZE_TEXT]];
        [jokeTitle setTextColor:self.jokeTextColor];
        jokeCategory.text = [NSString stringWithFormat:@"%@", jokeItem.jokeCategory];
        [jokeCategory setFont:[UIFont fontWithName:FONT_CATEGORY_TEXT size:FONT_CATEGORY_SIZE]];
        [jokeCategory setTextColor:self.jokeCategoryColor];
    }

    return _cellJokeList;
}

// show screen to list jokes when one is selected
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    // create instance of contact us view controller
    TJKDisplayJokesController *jokeView = [[TJKDisplayJokesController alloc] initWithNibName:nil bundle:nil];
    
    // pass the array with the jokes to the display joke controller
    jokeView.pageJokes = [NSMutableArray arrayWithArray:self.jokeList];
    jokeView.jokeIndex = indexPath.row;
    jokeView.areFavoriteJokes = ([self.categoryName isEqualToString:CATEGORY_FIELD_FAVORITE]) ? YES : NO;
    
    // display the contact us screen
    [self.navigationController pushViewController:jokeView animated:YES];
}


@end
