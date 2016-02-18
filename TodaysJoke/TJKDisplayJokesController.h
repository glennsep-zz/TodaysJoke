//
//  TJKDisplayJokesController.h
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 2/14/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJKJokeItem.h"
#import "TJKJokeItemStore.h"

@interface TJKDisplayJokesController : UIViewController

#pragma Properties
@property (nonatomic, strong) NSArray<TJKJokeItem *> *jokeList;
@property (nonatomic) NSInteger jokeIndex;

@end
