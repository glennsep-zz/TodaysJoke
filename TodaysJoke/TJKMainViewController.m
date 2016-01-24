//
//  TJKMainViewController.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/16/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import "TJKMainViewController.h"
#import "TJKDetailJokeViewController.h"
#import "TJKCenterViewController.h"
#import "TJKLeftPanelViewController.h"

#define CENTER_TAG 1
#define LEFT_PANEL_TAG 2
#define CORNER_RADIUS 4
#define SLIDE_TIMING .25
#define PANEL_WIDTH 60

@interface TJKMainViewController() <UIGestureRecognizerDelegate, CenterViewControllerDelegate>

@property (nonatomic, strong) TJKCenterViewController *centerViewController;
@property (nonatomic, strong) TJKLeftPanelViewController *leftPanelViewController;
@property (nonatomic, assign) BOOL showingLeftPanel;
@property (nonatomic, assign) BOOL showPanel;
@property (nonatomic, assign) CGPoint preVelocity;
@property (nonatomic) float senderViewX;

@end

@implementation TJKMainViewController

#pragma View Controler Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
}

// actions to perform before view appears
-(void)viewWillAppear:(BOOL)animated
{
    // get the center of the view to disable moving the view past the left bounds.
    if (self.senderViewX == 0)
    {
        self.senderViewX = _centerViewController.view.center.x;
    }
}

#pragma Methods

// this sets up the navigation bar
-(void)setupNavBar
{
    // setup title of navigation bar
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = @"Today's Joke";
    
    // create a custom button for the left menu
    UIButton *leftMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftMenuButton setImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [leftMenuButton addTarget:self action:@selector(showPanelRight:) forControlEvents:UIControlEventTouchUpInside];
    [leftMenuButton setFrame:CGRectMake(0,0,20,20)];
    
    // create a new bar button to display the menu
    UIBarButtonItem *leftMenu = [[UIBarButtonItem alloc] initWithCustomView:leftMenuButton];
    
    // create a new bar button item to add a new joke
    UIBarButtonItem *addJoke = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(addNewJoke:)];
    
    // setup the left bar button in the navigation bar
    navItem.leftBarButtonItem = leftMenu;
    
    // setup bar buttom as right item in navigation bar
    navItem.rightBarButtonItem = addJoke;
}

#pragma Actions

// display the screen to add a new joke
-(IBAction)addNewJoke:(id)sender
{
    // create a instance of the joke view controller
    TJKDetailJokeViewController *detailJokeViewController = [[TJKDetailJokeViewController alloc] initWithNibName:nil bundle:nil];

    // create a navigation controller
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:detailJokeViewController];
    
    // display joke detail screen
    [self presentViewController:navController animated:YES completion:NULL];
}

// to show or hide left panel

-(IBAction)showPanelRight:(id)sender
{
    [_centerViewController btnMovePanelRight:sender];
}

// setup the center view controller
- (void)setupView
{
    self.centerViewController = [[TJKCenterViewController alloc] initWithNibName:@"TJKCenterViewController" bundle:nil];
    self.centerViewController.view.tag = CENTER_TAG;
    self.centerViewController.delegate = self;
    
    [self.view addSubview:self.centerViewController.view];
    [self addChildViewController:_centerViewController];
    [_centerViewController didMoveToParentViewController:self];
    [self setupGestures];
}

// setp the left panel view controller
- (UIView *)getLeftView
{
    // init view if it doesn't already exist
    if (_leftPanelViewController == nil)
    {
        // this is where you define the view of the left panel
        self.leftPanelViewController = [[TJKLeftPanelViewController alloc] initWithNibName:@"TJKLeftPanelViewController" bundle:nil];
        self.leftPanelViewController.view.tag = LEFT_PANEL_TAG;
        self.leftPanelViewController.delegate = _centerViewController;
        [self.view addSubview:self.leftPanelViewController.view];
        [self addChildViewController:_leftPanelViewController];
        [_leftPanelViewController didMoveToParentViewController:self];
        _leftPanelViewController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
    }
    
    self.showingLeftPanel = YES;
    
    // setup view shadows
    [self showCenterViewWithShadow:YES withOffset:-2];
    
    UIView *view = self.leftPanelViewController.view;
    return view;
}

// define the shadow
- (void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset
{
    if (value)
    {
        [_centerViewController.view.layer setCornerRadius:CORNER_RADIUS];
        [_centerViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [_centerViewController.view.layer setShadowOpacity:0.8];
        [_centerViewController.view.layer setShadowOffset:CGSizeMake(offset,offset)];
    }
    else
    {
        [_centerViewController.view.layer setCornerRadius:0.0f];
        [_centerViewController.view.layer setShadowOffset:CGSizeMake(offset,offset)];
    }
}

- (void)movePanelRight
{
    UIView *childView = [self getLeftView];
    [self.view sendSubviewToBack:childView];
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:
     ^{
         _centerViewController.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH,0,self.view.frame.size.width,self.view.frame.size.height);
     }
                     completion:^(BOOL finished)
     {
         if (finished)
         {
             _centerViewController.leftButton = 0;
         }
     }];
}

// move the panel back to the original position
- (void)movePanelToOriginalPosition
{
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:
     ^{
         _centerViewController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
     }
                     completion:^(BOOL finished)
     {
         if (finished)
         {
             [self resetMainView];
         }
     }];
}

// remove left and right views, and reset variables, if needed
- (void)resetMainView
{

    if (_leftPanelViewController != nil)
    {
        [self.leftPanelViewController.view removeFromSuperview];
        self.leftPanelViewController = nil;
        
        _centerViewController.leftButton = 1;
        self.showingLeftPanel = NO;
    }
    
    // remove view shadows
    [self showCenterViewWithShadow:NO withOffset:0];
}

// respond to gestures
- (void)setupGestures
{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    
    [_centerViewController.view addGestureRecognizer:panRecognizer];
}

// code that moves the panel based on gestures
-(void)movePanel:(id)sender
{
    // disable tap
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    
    // setup gesture
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:[sender view]];
    
    // actions when gesture begins
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        UIView *childView = nil;

        if (!_showingLeftPanel) {
            childView = [self getLeftView];
        }

        // Make sure the view you're working with is front and center.
        [self.view sendSubviewToBack:childView];
        [[sender view] bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    }
    
    // actions when gesture ends
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        if (!_showPanel)
        {
            [self movePanelToOriginalPosition];
        }
        else
        {
            if (_showingLeftPanel)
            {
                [self movePanelRight];
            }
        }
    }
    
    // actions when controller is being moved
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        // prevent center view from moving past the left bounds
        if (_centerViewController.view.center.x >= self.senderViewX)
        {
            // Are you more than halfway? If so, show the panel when done dragging by setting this value to YES (1).
            _showPanel = fabs([sender view].center.x - _centerViewController.view.frame.size.width/2) > _centerViewController.view.frame.size.width/2;
            
            // Allow dragging only in x-coordinates by only updating the x-coordinate with translation position.
            [sender view].center = CGPointMake([sender view].center.x + translatedPoint.x, [sender view].center.y);
            [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
            
            // If you needed to check for a change in direction, you could use this code to do so.
            if(velocity.x*_preVelocity.x + velocity.y*_preVelocity.y > 0) {
                // NSLog(@"same direction");
            } else {
                // NSLog(@"opposite direction");
            }
            _preVelocity = velocity;
        }
    }
}


@end
