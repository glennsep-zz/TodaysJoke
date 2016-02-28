//
//  TJKDisplayJokesController.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 2/25/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import "TJKDisplayJokesController.h"
#import "TJKJokeGallery.h"
#import "TJKCommonRoutines.h"
#import "TJKAppDelegate.h"

@interface TJKDisplayJokesController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) int currentIndex;
@property (nonatomic) BOOL firstDisplay;

@end

@implementation TJKDisplayJokesController

#pragma Initializers

// designated initializer
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // call super class
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // create navigation bar buttons
        // done button
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                     target:self
                                     action:@selector(closeListJokes:)];
        self.navigationItem.leftBarButtonItem = doneItem;
        
        // change to standard color for right and left buttons
        TJKCommonRoutines *common = [[TJKCommonRoutines alloc] init];
        self.navigationItem.leftBarButtonItem.tintColor = [common StandardSystemColor];
    }
    
    // return view controller
    return self;
}

#pragma View Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup first display switch
    self.firstDisplay = YES;
    
    // restrict to portrait mode if iphone
    [self restrictRotation:YES];
  
    // setup the collection view by setting up how it responds and displays
    [self setupCollectionView];
}

// routines to implement when view appears
-(void)viewWillAppear:(BOOL)animated
{
    // setup scren title
    TJKCommonRoutines *common = [[TJKCommonRoutines alloc] init];
    [common setupNavigationBarTitle:self.navigationItem setImage:@"ListJokes.png"];
    self.navigationController.navigationBar.barTintColor = [common standardNavigationBarColor];
}


#pragma Methods

// setup the collection by setting up how it responds and displays
-(void)setupCollectionView {
    [self.collectionView registerClass:[TJKJokeGallery class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [self.collectionView setPagingEnabled:YES];
    [self.collectionView setCollectionViewLayout:flowLayout];
}

// close list jokes
-(void)closeListJokes:(id)sender
{
    // remove the contact us screen
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

// restrict to portrait mode for iphone
-(void) restrictRotation:(BOOL) restriction
{
    TJKAppDelegate* appDelegate = (TJKAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.restrictRotation = restriction;
}

#pragma Collection View Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.pageJokes count];
}

// load the joke from what was selected in joke list
/*-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:self.jokeIndex];
    
    [self.collectionView scrollToItemAtIndexPath:indexPath
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:YES];
}*/

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // initialize the joke gallery that contains the cell
    TJKJokeGallery *cell = (TJKJokeGallery *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    // retrieve the joke description and category and update the cell
    TJKJokeItem *jokeItem = [self.pageJokes objectAtIndex:indexPath.row];
    
    NSString *jokeDescr = jokeItem.jokeDescr;
    NSString *jokeCategory = jokeItem.jokeCategory;
    
    cell.jokeDescr = jokeDescr;
    cell.jokeCategoryText = [@"~" stringByAppendingString:jokeCategory];
    [cell updateCell];
    
    return cell;
}

// size the cell when device is rotated
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //return self.collectionView.frame.size;
    
    // Adjust cell size for orientation
    if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
    {
        return CGSizeMake(self.collectionView.frame.size.height, self.collectionView.frame.size.width);
    }
    return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
}

#pragma mark Rotation handling methods

// format the cell when device is rotated
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:
(NSTimeInterval)duration {
    
    // Fade the collectionView out
    [self.collectionView setAlpha:0.0f];
    
    // Suppress the layout errors by invalidating the layout
    [self.collectionView.collectionViewLayout invalidateLayout];
    
    // Calculate the index of the item that the collectionView is currently displaying
    CGPoint currentOffset = [self.collectionView contentOffset];
    self.currentIndex = currentOffset.x / self.collectionView.frame.size.width;
}

// format the cell when device is rotated
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    
    // Force realignment of cell being displayed
    CGSize currentSize = self.collectionView.bounds.size;
    float offset = self.currentIndex * currentSize.width;
    [self.collectionView setContentOffset:CGPointMake(offset, 0)];
    
    // Fade the collectionView back in
    [UIView animateWithDuration:0.125f animations:^{
        [self.collectionView setAlpha:1.0f];
    }];
}

@end
