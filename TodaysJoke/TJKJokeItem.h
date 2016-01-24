//
//  TJKJokeItem.h
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/16/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJKJokeItem : NSObject

#pragma Declare Properties

@property (nonatomic, copy) NSString *jokeId;
@property (nonatomic, readonly, strong) NSDate *jokeCreated;
@property (nonatomic, copy) NSString *jokeTitle;
@property (nonatomic, copy) NSString *jokeDescr;
@property (nonatomic, copy) NSString *nameSubmitted;
@property (nonatomic, copy) NSString *jokeCategory;

#pragma Declare Initializers

// designated initializer
-(instancetype)initWithJokeDescr:(NSString *)jokeDescr
                  jokeCategory:(NSString *)jokeCategory
                   nameSubmitted:(NSString *)nameSubmitted;


// create a joke item
+(instancetype)createJoke:(NSString *)jokeDescr
           JokeCategory:(NSString *)jokeCategory
            nameSubmitted:(NSString *)nameSubmitted;


@end
