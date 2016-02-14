//
//  TJKJokeItem.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/16/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import "TJKAppDelegate.h"
#import "TJKJokeItem.h"
#define TITLE_LENGTH 15

@implementation TJKJokeItem

#pragma Implement Initializers

// designated initializer
-(instancetype)initWithJokeDescr:(NSString *)jokeDescr
                  jokeCategory:(NSString *)jokeCategory
                   nameSubmitted:(NSString *)nameSubmitted
                       jokeTitle:(NSString *)jokeTitle
              categoryRecordName:(NSString *)categoryRecordName
                     jokeCreated:(NSDate *)jokeCreated
                  jokeRecordName:(NSString *)jokeId
{
    // call the superclass initializer
    self = [super init];
    
    // if the superclass initalizer succeeded then assign values
    if (self)
    {
        // trim leading and trailing spaces from the joke
        jokeDescr = [jokeDescr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        self.jokeDescr = jokeDescr;
        self.jokeCategory = jokeCategory;
        self.nameSubmitted = nameSubmitted;
        self.jokeTitle = jokeTitle;
        self.categoryRecordName = categoryRecordName;
        _jokeCreated = jokeCreated;
        _jokeId = jokeId;
     }
    
    // return the newly initialized object
    return self;
}

// override init
-(instancetype)init
{
    return [self initWithJokeDescr:@"" jokeCategory:@"" nameSubmitted:@"" jokeTitle:@"" categoryRecordName:@"" jokeCreated:[NSDate date] jokeRecordName:@""];
}

#pragma Methods

// create a Joke Item
+(instancetype)createJoke:(NSString *)jokeDescr
          JokeCategory:(NSString *)jokeCategory
            nameSubmitted:(NSString *)nameSubmitted
                jokeTitle:(NSString *)jokeTitle
    categoryRecordName:(NSString *)categoryRecordName
              jokeCreated:(NSDate *)jokeCreated
           jokeRecordName:(NSString *)jokeId
{
    TJKJokeItem *newItem = [[self alloc] initWithJokeDescr:jokeDescr
                                             jokeCategory:jokeCategory
                                                nameSubmitted:nameSubmitted
                                                 jokeTitle:jokeTitle
                                        categoryRecordName:categoryRecordName
                                               jokeCreated:jokeCreated
                                             jokeRecordName:jokeId];
    
    // return new joke item
    return newItem;
}

@end
