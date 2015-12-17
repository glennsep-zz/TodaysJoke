//
//  TJKJokeItem.h
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/16/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, JokeCategory)
{
    JokeCategoryPuns,
    JokeCategoryKnockKnock,
    JokeCategoryFunnyQuotes,
    JokeCategoryIronic,
    JokeCategoryCleanJokes,
    JokeCategoryNone
};

@interface TJKJokeItem : NSObject

#pragma Declare Properties

@property (nonatomic, copy) NSString *jokeId;
@property (nonatomic) JokeCategory *jokeCategoryId;
@property (nonatomic, readonly, strong) NSDate *jokeCreated;
@property (nonatomic, copy) NSString *jokeTitle;
@property (nonatomic, copy) NSString *jokeDescr;

#pragma Declare Initializers

// designated initializer
-(instancetype)initWithJokeDescr:(NSString *)jokeDescr
                  jokeCategoryId:(JokeCategory)jokeCategoryId
                       jokeTitle:(NSString *)jokeTitle;



@end
