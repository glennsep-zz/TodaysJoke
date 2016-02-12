//
//  TJKListJokesViewController.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 2/11/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import "TJKListJokesViewController.h"
#import "TJKAppDelegate.h"
#import "GHSAlerts.h"

@interface TJKListJokesViewController ()

#pragma Properties
@property (weak, nonatomic) IBOutlet UITableView *listJokesTableView;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellJokeList;
@property (strong, nonatomic) NSMutableArray *jokeList;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // restrict to portrait mode if iphone
    [self restrictRotation:YES];
    
    // set the title
    self.title = self.categoryName;
    
    // get all the jokes for the category
    
}

#pragma Methods
// restrict to portrait mode for iphone
-(void) restrictRotation:(BOOL) restriction
{
    TJKAppDelegate* appDelegate = (TJKAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.restrictRotation = restriction;
}

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
             CKRecord *categoryRecord = [results firstObject];
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
                              NSLog(@"Joke Title = %@", [jokeRecord objectForKey:JOKE_TITLE]);
                              NSLog(@"Joke Submitted By = %@", [jokeRecord objectForKey:JOKE_SUBMITTED_BY]);
                              NSLog(@"Joke = %@", [jokeRecord objectForKey:JOKE_DESCR]);
                              NSLog(@"\n");
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

@end
