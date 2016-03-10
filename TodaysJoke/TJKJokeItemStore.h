//
//  TJKJokeItemStore.h
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/19/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TJKJokeItem;

@interface TJKJokeItemStore : NSObject

#pragma Properties
@property(nonatomic, readonly, copy) NSArray *allItems;
@property(nonatomic,readonly,copy) TJKJokeItem *lastItem;

#pragma Singleton
+(instancetype)sharedStore;

#pragma Methods
-(TJKJokeItem *)createItem:(NSString *)jokeDescr
              jokeCategory:(NSString*)jokeCategory
             nameSubmitted:(NSString *)nameSubmitted
                 jokeTitle:(NSString *)jokeTitle
        categoryRecordName:(NSString *)categoryRecordName
               jokeCreated:(NSDate *)jokeCreated
            jokeRecordName:(NSString *)jokeId
              jokeFavorite:(BOOL) isFavorite;

-(void)removeItem:(TJKJokeItem *)jokeItem;

-(void)RemoveAllItems;

-(TJKJokeItem *)retrieveItem:(TJKJokeItem *)jokeItem;

@end
