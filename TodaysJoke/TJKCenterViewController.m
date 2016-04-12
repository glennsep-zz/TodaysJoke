//
//  TJKCenterViewController.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/31/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import <CloudKit/CloudKit.h>
#import "TJKCenterViewController.h"
#import "TJKAppDelegate.h"
#import "TJKCommonRoutines.h"
#import "TJKConstants.h"
#import "TJKJokeItem.h"
#import "GHSAlerts.h"

@interface TJKCenterViewController ()
@property (weak, nonatomic) IBOutlet UILabel *jokeTitle;
@property (weak, nonatomic) IBOutlet UILabel *jokeCategory;
@property (weak, nonatomic) IBOutlet UILabel *jokeSubmitted;
@property (weak, nonatomic) IBOutlet UITextView *joke;

@end

@implementation TJKCenterViewController

#pragma View Controller Methods

// actions to perform once view loads
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup instance to common routines
    TJKCommonRoutines *common = [[TJKCommonRoutines alloc] init];
    
    // setup the screen fonts, sizes, layout
    [self setupScreenLayout:common];
    
    // initialize property values
    self.leftButton = 1;
   
    // retrieve the latest joke
    [self retrieveLatestJoke];
}

#pragma Methods

// setup fonts, sizes, colors
-(void)setupScreenLayout:(TJKCommonRoutines *)common
{
    [self.jokeTitle setFont:[UIFont fontWithName:FONT_NAME_LABEL size:FONT_SIZE_LABEL]];
    [self.jokeTitle setTextColor:[common textColor]];
    self.jokeTitle.textAlignment = NSTextAlignmentCenter;
    [self.jokeCategory setFont:[UIFont fontWithName:FONT_NAME_LABEL size:FONT_SIZE_LABEL]];
    [self.jokeCategory setTextColor:[common textColor]];
    [self.jokeSubmitted setFont:[UIFont fontWithName:FONT_NAME_LABEL size:FONT_SIZE_LABEL]];
    [self.jokeSubmitted setTextColor:[common textColor]];
    [self.joke setFont:[UIFont fontWithName:FONT_NAME_LABEL size:FONT_SIZE_LABEL]];
    [self.joke setTextColor:[common textColor]];
    [common setBorderForTextView:self.joke];
}

-(void)retrieveLatestJoke
{
    // get the most recent joke added to the database
    CKDatabase *jokePublicDatabase = [[CKContainer containerWithIdentifier:JOKE_CONTAINER] publicCloudDatabase];
    NSPredicate *predicateJokes = [NSPredicate predicateWithFormat:@"creationDate <= %@", [NSDate date]];
    CKQuery *queryJokes = [[CKQuery alloc] initWithRecordType:JOKE_RECORD_TYPE predicate:predicateJokes];
    NSSortDescriptor *sortJokes = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
    queryJokes.sortDescriptors = [NSArray arrayWithObjects:sortJokes, nil];
    [jokePublicDatabase performQuery:queryJokes inZoneWithID:nil completionHandler:^(NSArray<CKRecord*>* results, NSError * error)
     {
         if (!error)
         {
             // get the joke record
             CKRecord *jokeRecord = [results firstObject];
             
             // get the category that belongs to the joke
             if (jokeRecord)
             {
                 // get the category associated with the joke
                 CKReference *referenceToCategory = jokeRecord[CATEGORY_FIELD_NAME];
                 CKRecordID *categoryRecordID = referenceToCategory.recordID;
                 [jokePublicDatabase fetchRecordWithID:categoryRecordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error)
                  {
                      if (!error)
                      {
                          // get the latest joke
                          if (record)
                          {
                              self.latestJoke = [[TJKJokeItem alloc] init];
                              self.latestJoke = [self.latestJoke initWithJokeDescr:[jokeRecord objectForKey:JOKE_DESCR] jokeCategory:[record objectForKey:CATEGORY_FIELD_NAME] nameSubmitted:[jokeRecord objectForKey:JOKE_SUBMITTED_BY] jokeTitle:[jokeRecord objectForKey:JOKE_TITLE] categoryRecordName:nil jokeCreated:[jokeRecord valueForKey:JOKE_CREATED] jokeRecordName:jokeRecord.recordID.recordName];
                              
                              // display the latest joke
                              [self displayLatestJoke];
                          }
                          else
                          {
                              // display alert message and pop the view controller from the stack
                              GHSAlerts *alert = [[GHSAlerts alloc] initWithViewController:self];
                              [alert displayErrorMessage:@"Oops!" errorMessage:@"The joke failed to load. Just try again!"];
                          }
                      }
                      else
                      {
                          NSLog(@"%@",error);
                          // display alert message and pop the view controller from the stack
                          GHSAlerts *alert = [[GHSAlerts alloc] initWithViewController:self];
                          [alert displayErrorMessage:@"Oops!" errorMessage:@"The joke failed to load. Just try again!"];
                      }
                  }];
             }
             else
             {
                 // display alert message and pop the view controller from the stack
                 GHSAlerts *alert = [[GHSAlerts alloc] initWithViewController:self];
                 [alert displayErrorMessage:@"Oops!" errorMessage:@"The joke failed to load. Just try again!"];
             }
         }
     }];
}

// display the latest joke
-(void)displayLatestJoke
{
    // display today's date
    NSDateFormatter *todaysDate = [[NSDateFormatter alloc] init];
    [todaysDate setDateStyle:NSDateFormatterFullStyle];
    NSDate *now = [[NSDate alloc] init];
    NSString *theDate = [todaysDate stringFromDate:now];
    NSString *jokeTitleString = [@"Today's Joke for " stringByAppendingString:theDate];
    self.jokeTitle.text = jokeTitleString;
    
    if (self.latestJoke)
    {
        // display the category
        self.jokeCategory.text = [@"Category: " stringByAppendingString:self.latestJoke.jokeCategory];
        
        // display submitted by
        if ([self.latestJoke.nameSubmitted isEqualToString:@""])
        {
            self.jokeSubmitted.text = @"Submitted by Anonymous";
        }
        else
        {
            self.jokeSubmitted.text = [@"Submitted by " stringByAppendingString:self.latestJoke.nameSubmitted];
        }

        // display the joke
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.joke.text = self.latestJoke.jokeDescr;
        });
    }
}


#pragma Action Methods
- (void)btnMovePanelRight:(id)sender
{
    switch (self.leftButton)
    {
        case 0:
        {
            [_delegate movePanelToOriginalPosition];
            break;
        }
            
        case 1:
        {
            [_delegate movePanelRight];
            break;
        }
            
        default:
            break;
    }
}

@end
