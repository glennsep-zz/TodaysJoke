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
    
    // restrict to portrait mode if iphone
    [self restrictRotation:YES];
    
    // get all the jokes for the category
    [self fetchJokesForCategory];
}

// routines to run when view appears
-(void)viewWillAppear:(BOOL)animated
{
    // set the title
    self.title = self.categoryName;
    TJKCommonRoutines *common = [[TJKCommonRoutines alloc] init];
    self.navigationController.navigationBar.tintColor = [common StandardSystemColor];
    [common setupNavigationBarTitle:self.navigationController fontName:FONT_NAME fontSize:FONT_SIZE];
}

// routines to run when view disappears
-(void)viewDidDisappear:(BOOL)animated
{
    // remove all items from joke store
    [[TJKJokeItemStore sharedStore] RemoveAllItems];
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
                          [[TJKJokeItemStore sharedStore] createItem:[jokeRecord objectForKey:JOKE_DESCR] jokeCategory:self.categoryName nameSubmitted:[jokeRecord objectForKey:JOKE_SUBMITTED_BY] jokeTitle:[jokeRecord objectForKey:JOKE_TITLE] categoryRecordName:[jokeRecord valueForKey:CATEGORY_FIELD_NAME] jokeCreated:[jokeRecord valueForKey:JOKE_CREATED] jokeRecordName:jokeRecord.recordID.recordName jokeFavorite:NO];
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
        jokeCategory.text = [NSString stringWithFormat:@"%@", jokeItem.jokeCategory];
    }

    return _cellJokeList;
}

// show screen to list jokes when one is selected
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    // create instance of contact us view controller
    TJKDisplayJokesController *jokeView = [[TJKDisplayJokesController alloc] initWithNibName:nil bundle:nil];
    
    // pass the array with the jokes to the display joke controller
    jokeView.pageJokes = self.jokeList;
    jokeView.jokeIndex = indexPath.row;
    
    // display the contact us screen
    [self.navigationController pushViewController:jokeView animated:YES];
}


@end
