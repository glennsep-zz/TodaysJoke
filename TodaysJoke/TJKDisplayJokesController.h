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

@interface TJKDisplayJokesController : UIViewController <UIScrollViewDelegate, UITextViewDelegate>

#pragma Properties
@property (nonatomic, strong) NSArray<TJKJokeItem *> *pageJokes;
@property (nonatomic) NSInteger jokeIndex;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

@end
