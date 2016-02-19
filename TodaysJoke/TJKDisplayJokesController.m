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
@property (nonatomic, strong) NSMutableArray *pageViews;

#pragma Methods
- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;

@end

@implementation TJKDisplayJokesController

// synthesize properties
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize pageJokes = _pageJokes;
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
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                       target:self
                                       action:@selector(closeListJokes:)];
        self.navigationItem.leftBarButtonItem = doneItem;
        
        // change to standard color for right and left buttons
        TJKCommonRoutines *common = [[TJKCommonRoutines alloc] init];
        self.navigationItem.rightBarButtonItem.tintColor = [common StandardSystemColor];
    }
    
    // return view controller
    return self;
}

#pragma UITextView Methods

// prevents editing and keyboard from showing
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}


#pragma Methods

// load the page
- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= self.pageJokes.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    // Load an individual page, first checking if you've already loaded it
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        
        // create frame
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        frame = CGRectInset(frame, 10.0f, 0.0f);
        
        // create text view
        UITextView *newPageView = [[UITextView alloc] init];
        
        // set the ui text view delegate
        newPageView.delegate = self;
        
        // populate with joke text
        TJKJokeItem *jokeItem = [self.pageJokes objectAtIndex:page];
        newPageView.text = jokeItem.jokeDescr;
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        
        // setup border for text view used to display a joke
        TJKCommonRoutines * common = [[TJKCommonRoutines alloc] init];
        UIColor *borderColor = [common StandardSystemColor];
        newPageView.layer.borderWidth = 1.0f;
        newPageView.layer.borderColor = borderColor.CGColor;
        newPageView.layer.cornerRadius = 5.0;
        
        // scroll text to the top
        [newPageView scrollRangeToVisible:NSMakeRange(0, 0)];
        
        [self.scrollView addSubview:newPageView];
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
}

// remove a page to preserve memory.  We don't want hundreds of items loaded into pages.
- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= self.pageJokes.count) {
        // If it's outside the range of what you have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

// determine what page the scroll view is currently on, update the page control and then load or purge relevant pages
- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.pageControl.currentPage = page;
    
    // Work out which pages you want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    for (NSInteger i=lastPage+1; i<self.pageJokes.count; i++) {
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

    // restrict to portrait mode if iphone
    [self restrictRotation:YES];
    
    // get the number of jokes
    NSInteger pageCount = self.pageJokes.count;
    
    // set the page control to the number of jokes
    self.pageControl.currentPage = self.jokeIndex;
    self.pageControl.numberOfPages = pageCount;
    
    // setup the array to hold the view for each page
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; i++)
    {
        [self.pageViews addObject:[NSNull null]];
    }
}

// routines to implement when view appears
-(void)viewWillAppear:(BOOL)animated
{
    // setup scren title
    TJKCommonRoutines *common = [[TJKCommonRoutines alloc] init];
    [common setupNavigationBarTitle:self.navigationItem setImage:@"ListJokes.png"];
    self.navigationController.navigationBar.tintColor = [common StandardSystemColor];

    
    // Set up the content size of the scroll view
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageJokes.count, pagesScrollViewSize.height);
    
    // Load the initial set of pages that are on screen
    [self loadVisiblePages];
}

// clear everything when view unloads
- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.scrollView = nil;
    self.pageControl = nil;
    self.pageJokes = nil;
    self.pageViews = nil;
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
