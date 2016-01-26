//
//  TJKContactUsViewController.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 1/25/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import "TJKContactUsViewController.h"
#import "TJKAppDelegate.h"

// define constants
#define MOVE_SCREEN_Y_AXIS_TEXT 125
#define MOVE_SCREEN_Y_AXIS_VIEW 186

@interface TJKContactUsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *contactUsSubject;
@property (weak, nonatomic) IBOutlet UITextView *contactUsMessage;

@end

@implementation TJKContactUsViewController

#pragma Initializers
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // call super class
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // create navigation bar buttons
        // submit e-mail button
        UIBarButtonItem *submitItem = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                       target:self
                                       action:@selector(contactUs:)];
        self.navigationItem.rightBarButtonItem = submitItem;
        
        // cancel button
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                       target:self
                                       action:@selector(cancelContactUs:)];
        self.navigationItem.leftBarButtonItem = cancelItem;
    }
    
    
    // return view controller
    return self;
}

#pragma View Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];

    // restrict to portrait mode if iphone
    [self restrictRotation:YES];

    // setup border for text view (used to type in joke)
    UIColor *borderColor = [UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1.0];
    self.contactUsMessage.layer.borderWidth = 1.0f;
    self.contactUsMessage.layer.borderColor = borderColor.CGColor;
    self.contactUsMessage.layer.cornerRadius = 5.0;
    
}

#pragma Methods

// restrict to portrait mode for iphone
-(void) restrictRotation:(BOOL) restriction
{
    TJKAppDelegate* appDelegate = (TJKAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.restrictRotation = restriction;
}

// cancel contact us
-(void)cancelContactUs:(id)sender
{
    // remove the contact us screen
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

// actions to perform when message sent via e-mail
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
