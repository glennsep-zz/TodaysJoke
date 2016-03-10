//
//  TJKJokeGallery.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 2/25/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import "TJKJokeGallery.h"
#import "TJKCommonRoutines.h"

@interface TJKJokeGallery()

@property (weak, nonatomic) IBOutlet UITextView *jokeText;
@property (weak, nonatomic) IBOutlet UILabel *jokeCateogry;

@end

@implementation TJKJokeGallery

#pragma Initializers

// initialize the cell for the collection view
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {       
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"TJKJokeGallery" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
        [self setupTextView];        
    }
    
    return self;
}

#pragma Collection Cell Methods

#pragma Methods

// format the text view
-(void)setupTextView
{
    // setup color
    TJKCommonRoutines *common = [[TJKCommonRoutines alloc] init];
    UIColor *borderColor = [common standardSystemColor];
    
    // setup border
    self.jokeText.layer.borderWidth = 1.0f;
    self.jokeText.layer.borderColor = borderColor.CGColor;
    self.jokeText.layer.cornerRadius = 5.0;
    
    // scroll text to the top
    [self.jokeText scrollRangeToVisible:NSMakeRange(0, 0)];
}

// populate the cell values
-(void)updateCell {
    
    // populate the joke description
    self.jokeText.text = self.jokeDescr;

    // populate the joke category
    self.jokeCateogry.text = self.jokeCategoryText;
    
    // scroll text to the top
    [self.jokeText scrollRangeToVisible:NSMakeRange(0, 0)];
}

@end
