//
//  TJKJokeItemStore.h
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/19/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJKJokeItem.h"

@interface TJKJokeItemStore : NSObject

#pragma Singleton
+(instancetype)sharedStore;
-(TJKJokeItem *)createItem:(NSString *)jokeDescr jokeCategoryId:(JokeCategory)jokeCategoryId jokeTitle:(NSString *)jokeTitle;

@end
