//
//  TJKDisplayJokesController.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 2/14/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import "TJKDisplayJokesController.h"
#import "TJKCommonRoutines.h"
#import "TJKAppDelegate.h"
#import "TJKConstants.h"

@interface TJKDisplayJokesController ()

#pragma Properties
@property (weak, nonatomic) IBOutlet UIButton *leftArrowButton;
@property (weak, nonatomic) IBOutlet UIButton *rightArrowButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIScrollView *displayJokesView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *pageViews;

#pragma Methods
- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;

@end

@implementation TJKDisplayJokesController

// synthesize properties
@synthesize displayJokesView = _displayJokesView;
@synthesize pageControl = _pageControl;
@synthesize jokeList = _jokeList;
@synthesize pageViews = _pageViews;


#pragma Initializers
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // call super class
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // create navigation bar buttons
        // done button
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                       target:self
                                       action:@selector(closeListJokes:)];
        self.navigationItem.leftBarButtonItem = cancelItem;
        
        // change to standard color for right and left buttons
        TJKCommonRoutines *common = [[TJKCommonRoutines alloc] init];
        self.navigationItem.rightBarButtonItem.tintColor = [common StandardSystemColor];
    }
    
    // return view controller
    return self;
}

#pragma Methods

// load the page
-(void)loadPage:(NSInteger)page
{
    // if we are outside the range then do nothing
    if (page < 0 || page >= self.jokeList.count)
    {
        return;
    }
    
    // check if view is already loaded
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*) pageView == [NSNull null])
    {
        // if the view doesn't exist then create a page
        CGRect frame = self.displayJokesView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
    
        // create the new text view and add it to the scroll view
        CGRect textViewRect = CGRectMake(0.0, 0.0, 100.0, 30.0);
        UITextView *textView = [[UITextView alloc] initWithFrame:textViewRect];
        textView.text = self.jokeList[page].jokeDescr;
        textView.contentMode = UIViewContentModeTop;
        textView.frame = frame;
        [self.displayJokesView addSubview:textView];
        
        // replace NSNull in pageViews array so as not to repeat the above code of creating a new page
        [self.pageViews replaceObjectAtIndex:page withObject:textView];
    }
}

// remove a page to preserve memory.  We don't want hundreds of items loaded into pages.
-(void)purgePage:(NSInteger)page
{
    // if out of bounds then do nothing
    if (page < 0 || page >= self.jokeList.count)
    {
        return;
    }
    
    // remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null])
    {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

// determine what page the scroll view is currently on, updat eht page control and then load or purge relevant pages
-(void)loadVisiblePages
{
    // First, determine which page is currently visible
    CGFloat pageWidth = self.displayJokesView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.displayJokesView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.pageControl.currentPage = page;
    
    // Work out which pages you want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    
    // Load pages in our range
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    
    // Purge anything after the last page
    for (NSInteger i=lastPage+1; i<self.jokeList.count; i++) {
        [self purgePage:i];
    }
}

// implement delegate for UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages that are now on screen
    [self loadVisiblePages];
}

#pragma View Controller Methods

// routine to implement after view loads
- (void)viewDidLoad {
    [super viewDidLoad];

    // setup scren title
    TJKCommonRoutines *common = [[TJKCommonRoutines alloc] init];
    [common setupNavigationBarTitle:self.navigationItem setImage:@"ListJokes.png"];

    // restrict to portrait mode if iphone
    [self restrictRotation:YES];
    
    // get the number of jokes
    NSInteger pageCount = self.jokeList.count;
    
    // set the page control to the number of jokes
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = pageCount;
    
    // setup placeholders for the pages
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; i++)
    {
        [self.pageViews addObject:[NSNull null]];
    }
}

// routines to implement when view appears
-(void)viewWillAppear:(BOOL)animated
{
    // determine content size for horizontal scroll view
    CGSize pagesScrollViewSize = self.displayJokesView.frame.size;
    self.displayJokesView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.jokeList.count, pagesScrollViewSize.height);
    
    // load the page
    [self loadVisiblePages];
}

#pragma Methods

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
@end
