//
//  TJKJokeItemStore.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/19/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import "TJKJokeItemStore.h"
#import "TJKJokeItem.h"

@interface TJKJokeItemStore()

@property (nonatomic) NSMutableArray *privateItems;

@end

@implementation TJKJokeItemStore

#pragma Singleton
+(instancetype)sharedStore
{
    // define variables
    static TJKJokeItemStore *sharedStore;
    
    // check if need to create a shared store
    if (!sharedStore)
    {
        sharedStore = [[self alloc] initPrivate];
    }
    
    // return the new object
    return sharedStore;
}

#pragma Initializers

// do not allow use of init
-(instancetype)init
{
    [NSException raise:@"Singleton"
                format:@"Use + [TJKJokeItemStore sharedStore"];
    return nil;
}

// private initializer
-(instancetype)initPrivate
{
    self = [super init];
    if (self)
    {
        _privateItems = [[NSMutableArray alloc] init];
    }
    
    // return new object
    return self;
}

#pragma Methods

// create a new joke item
-(TJKJokeItem *)createItem:(NSString *)jokeDescr jokeCategoryId:(JokeCategory)jokeCategoryId jokeTitle:(NSString *)jokeTitle
{
    TJKJokeItem *item = [TJKJokeItem createJoke:jokeDescr JokeCategoryId:jokeCategoryId jokeTitle:jokeTitle];
    [self.privateItems addObject:item];
    return item;
}

@end
