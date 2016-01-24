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
{
    // call the superclass initializer
    self = [super init];
    
    // trim leading and trailing spaces from the joke
    jokeDescr = [jokeDescr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // get the title from the joke description
    unsigned long jokeLength = [jokeDescr length];
    if (jokeLength > 0 && jokeLength <= TITLE_LENGTH)
    {
        jokeLength = jokeLength;
    }
    else if (jokeLength > 0 && jokeLength > TITLE_LENGTH && (jokeLength - TITLE_LENGTH) > TITLE_LENGTH)
    {
        jokeLength = jokeLength - (jokeLength - TITLE_LENGTH);
    }
    else if (jokeLength > 0 && jokeLength > TITLE_LENGTH && (jokeLength - TITLE_LENGTH) <= TITLE_LENGTH)
    {
        jokeLength = TITLE_LENGTH;
    }
    else
    {
        jokeLength = 0;
    }
    
    NSString *jokeTitleTemp = [jokeDescr substringToIndex:jokeLength];
    
    // if the superclass initalizer succeeded then assign values
    if (self)
    {
        self.jokeDescr = jokeDescr;
        self.jokeCategory = jokeCategory;
        self.jokeTitle = [jokeTitleTemp stringByAppendingString:@"..."];
        self.nameSubmitted = nameSubmitted;
        
        // define the joke id
        NSUUID *jokeUuid = [[NSUUID alloc] init];
        NSString *jokeId = [jokeUuid UUIDString];
        _jokeId = jokeId;
        
        // get the date the joke is created
        _jokeCreated = [[NSDate alloc] init];
     }
    
    // return the newly initialized object
    return self;
}

// override init
-(instancetype)init
{
    return [self initWithJokeDescr:@"" jokeCategory:@"" nameSubmitted:@""];
}

#pragma Methods

// create a Joke Item
+(instancetype)createJoke:(NSString *)jokeDescr
          JokeCategory:(NSString *)jokeCategory
            nameSubmitted:(NSString *)nameSubmitted
{
    TJKJokeItem *newItem = [[self alloc] initWithJokeDescr:jokeDescr
                                             jokeCategory:jokeCategory
                                                nameSubmitted:nameSubmitted];
    
    // return new joke item
    return newItem;
}

@end
