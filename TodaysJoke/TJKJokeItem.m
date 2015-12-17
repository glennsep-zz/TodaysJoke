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
{
    // call the superclass initializer
    self = [super init];
    
    // if the superclass initalizer succeeded then assign values
    if (self)
    {
        self.jokeDescr = jokeDescr;
        self.jokeCategoryId = &(jokeCategoryId);
        self.jokeTitle = jokeTitle;
        
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
    return [self initWithJokeDescr:@"None" jokeCategoryId:JokeCategoryNone jokeTitle:@"None"];
}

@end
