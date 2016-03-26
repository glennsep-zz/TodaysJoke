//
//  TJKJokeItemStore.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/19/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import "TJKJokeItemStore.h"
#import "TJKJokeItem.h"
#import "TJKConstants.h"

@interface TJKJokeItemStore()

@property (nonatomic) NSMutableArray *privateItems;
@property (nonatomic) NSMutableArray *favoriteItems;

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
-(TJKJokeItem *)createItem:(NSString *)jokeDescr
              jokeCategory:(NSString*)jokeCategory
             nameSubmitted:(NSString *)nameSubmitted
                 jokeTitle:(NSString *)jokeTitle
        categoryRecordName:(NSString *)categoryRecordName
               jokeCreated:(NSDate *)jokeCreated
            jokeRecordName:(NSString *)jokeId;
{
    TJKJokeItem *item = [[TJKJokeItem alloc] initWithJokeDescr:(NSString *)jokeDescr
                                                  jokeCategory:(NSString *)jokeCategory
                                                 nameSubmitted:(NSString *)nameSubmitted
                                                     jokeTitle:(NSString*)jokeTitle
                                            categoryRecordName:(NSString *)categoryRecordName
                                                   jokeCreated:(NSDate*)jokeCreated
                                                jokeRecordName:(NSString *)jokeId];
    [self.privateItems addObject:item];
    return item;
}

// return all of the jokes stored
-(NSArray *)allItems
{
    return [self.privateItems copy];
}

// get the last item added to the array
-(TJKJokeItem*)lastItem
{
    if ([self.privateItems count] > 0)
    {
        return [self.privateItems objectAtIndex:[self.privateItems count]-1];
    }
    else
    {
        return nil;
    }
}

// remove the joke item
-(void)removeItem:(TJKJokeItem *)jokeItem
{
    [self.privateItems removeObjectIdenticalTo:jokeItem];
}

// remove all items in the array
-(void)removeAllItems
{
    [self.privateItems removeAllObjects];
}

// get a file path to save the favorite jokes
-(NSString *)itemArchivePath
{
    // get a list of paths in the documents folder
    NSArray * documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // get the one document directory from the list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    // return the path
    return [documentDirectory stringByAppendingPathComponent:FILE_NAME_FAVORITES];
}

// insert a joke into the favorites collection
-(void)insertFavoriteJoke:(TJKJokeItem *)jokeItem
{
    // if favorite items is not initialized then init it now
    if (!_favoriteItems)
    {
        _favoriteItems = [[NSMutableArray alloc] init];
    }
    
    // store the joke to the favorites array
    [_favoriteItems addObject:jokeItem];
}

// remove a joke from the favorites collection
-(void)removeFavoriteJoke:(TJKJokeItem *)jokeItem
{
    // remove the joke from the favorites array
    [self.favoriteItems removeObjectIdenticalTo:jokeItem];
}

// save the favorite jokes
-(void)saveFavorites
{
    // get the path to save
    NSString *path = [self itemArchivePath];
    
    // save all favorties
    [NSKeyedArchiver archiveRootObject:self.favoriteItems toFile:path];
    
    //[_favoriteItems writeToFile:path atomically:YES];
}

// retrieve all favorite jokes
-(void)retrieveFavorites
{
    // get the path to save
    NSString *path = [self itemArchivePath];
    
    // retrieve all favorites
    _favoriteItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    // if array was not saved previously create an empty one
    if (!_favoriteItems)
    {
        _favoriteItems = [[NSMutableArray alloc] init];
    }
    
    //_favoriteItems = [NSMutableArray arrayWithContentsOfFile:path];
}

// check if joke is in favorite collection
-(int)checkIfFavorite:(TJKJokeItem *)jokeItem
{
    // define variables
    int isFavorite = -1;
    
    for (int i = 0; i < ([_favoriteItems count]); i++)
    {
        TJKJokeItem * joke = [_favoriteItems objectAtIndex:i];
        if ([joke.jokeId isEqualToString:jokeItem.jokeId])
        {
            isFavorite = i;
            break;
        }
    }   
    
    // return if favorite
    return isFavorite;
}

@end
