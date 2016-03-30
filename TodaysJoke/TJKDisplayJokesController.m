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
@property (nonatomic) UIImage *favoriteImage;
@property (nonatomic) CGRect favoriteFrameImg;
@property (nonatomic) UIButton *favoriteButton;

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
        // set the navigation bar to indicate if favorite is selected or not
        [self setupFavoriteButton:YES];
    }
    
    // return view controller
    return self;
}

#pragma View Controller Methods

// routine to run when view loads
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set the automatically adjust scroll view inserts to no
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // setup screen title
    TJKCommonRoutines *common = [[TJKCommonRoutines alloc] init];
    [common setupNavigationBarTitle:self.navigationItem setImage:@"ListJokes.png"];
    self.navigationController.navigationBar.barTintColor = [common standardNavigationBarColor];
    
    // restrict to portrait mode if iphone
    [self restrictRotation:YES];
    
    // setup the collection view by setting up how it responds and displays
    [self setupCollectionView];
}

// routines to implement when view appears
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // set joke to start at joke selected from table.
    NSIndexPath *path = [NSIndexPath indexPathForRow:_jokeIndex inSection:0];
    self.currentIndex = (int)_jokeIndex;
    [self.collectionView scrollToItemAtIndexPath:path
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:NO];
    [self setupFavoriteButton:YES];
}

#pragma Methods

// set navigation bar to indicate if favorite is selected
-(void)setupFavoriteButton:(BOOL)change
{
    // create button to indicate favorite
    // first create the image
    TJKJokeItem *joke = [self.pageJokes objectAtIndex:self.currentIndex];
    if ([[TJKJokeItemStore sharedStore] checkIfFavorite:joke] == -1)
    {
        self.favoriteImage = [UIImage imageNamed:@"favoriteUnSelected.png"];
    }
    else
    {
        self.favoriteImage = [UIImage imageNamed:@"favoriteSelected.png"];
    }
    self.favoriteFrameImg = CGRectMake(0,0,25,25);
    self.favoriteButton = [[UIButton alloc] initWithFrame:self.favoriteFrameImg];
    [self.favoriteButton setBackgroundImage:self.favoriteImage forState:UIControlStateNormal];
    [self.favoriteButton addTarget:self action:@selector(makeFavorite:) forControlEvents:UIControlEventTouchUpInside];
    [self.favoriteButton setShowsTouchWhenHighlighted:NO];
    
    
    UIBarButtonItem *favoriteItem = [[UIBarButtonItem alloc] initWithCustomView:self.favoriteButton];
    self.navigationItem.rightBarButtonItem = favoriteItem;
}

// setup joke as favorite
-(void)makeFavorite:(id)sender
{   
    TJKJokeItem *joke = [self.pageJokes objectAtIndex:self.currentIndex];
    if ([[TJKJokeItemStore sharedStore] checkIfFavorite:joke] == -1)
    {
        // insert into favorite jokes collection
        [[TJKJokeItemStore sharedStore] insertFavoriteJoke:joke];
    }
    else
    {
        // remove from favorite jokes collection
        [[TJKJokeItemStore sharedStore] removeFavoriteJoke:joke];
    }  
    
    // save the favorite jokes
    [[TJKJokeItemStore sharedStore] saveFavoritesToArchive];
    
    [self setupFavoriteButton:YES];
}

// setup the collection by setting up how it responds and displays
-(void)setupCollectionView {
    [self.collectionView registerClass:[TJKJokeGallery class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [self.collectionView setPagingEnabled:YES];
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
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
    
    // update the current index with the joke item
    self.currentIndex = (int)indexPath.row;
    [self setupFavoriteButton:YES];
    
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

@end
