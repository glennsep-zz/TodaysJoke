//
//  TJKJokeItem.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/16/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import "TJKJokeItem.h"

@implementation TJKJokeItem

#pragma Implement Initializers

// designated initializer
-(instancetype)initWithJokeDescr:(NSString *)jokeDescr
                  jokeCategoryId:(JokeCategory)jokeCategoryId
                       jokeTitle:(NSString *)jokeTitle
                   nameSubmitted:(NSString *)nameSubmitted
{
    // call the superclass initializer
    self = [super init];
    
    // if the superclass initalizer succeeded then assign values
    if (self)
    {
        self.jokeDescr = jokeDescr;
        self.jokeCategoryId = &(jokeCategoryId);
        self.jokeTitle = jokeTitle;
        self.nameSubmitted = nameSubmitted;
        
        // define the joke id
        NSUUID *jokeUuid = [[NSUUID alloc] init];
        NSString *jokeId = [jokeUuid UUIDString];
        _jokeId = jokeId;
        
        // get the date the joke is created
        _jokeCreated = [[NSDate alloc] init];
        
        // define the array for the joke categories
        _jokeCategories = @[@"None", @"Puns", @"Knock Knock Jokes", @"Funny Quotes", @"Ironic Jokes",
                              @"Clean Jokes"];
        
    }
    
    // return the newly initialized object
    return self;
}

// override init
-(instancetype)init
{
    return [self initWithJokeDescr:@"None" jokeCategoryId:JokeCategoryNone jokeTitle:@"None" nameSubmitted:@""];
}

#pragma Methods

// create a Joke Item
+(instancetype)createJoke:(NSString *)jokeDescr
          JokeCategoryId:(JokeCategory)jokeCategoryId
               jokeTitle:(NSString *)jokeTitle
            nameSubmitted:(NSString *)nameSubmitted
{
    TJKJokeItem *newItem = [[self alloc] initWithJokeDescr:jokeDescr
                                             jokeCategoryId:jokeCategoryId
                                                  jokeTitle:jokeTitle
                                                nameSubmitted:nameSubmitted];
    
    // return new joke item
    return newItem;
}

@end
