//
//  TJKContactUsViewController.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 1/25/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import "TJKContactUsViewController.h"
#import "TJKAppDelegate.h"
#import "GHSAlerts.h"
#import "GHSNoSwearing.h"
#import "TJKConstants.h"

// define constants
#define MAX_NUMBER_OF_BAD_WORDS 5
#define MOVE_SCREEN_Y_AXIS_TEXT 100
#define MOVE_SCREEN_Y_AXIS_VIEW 76

@interface TJKContactUsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *contactUsSubject;
@property (weak, nonatomic) IBOutlet UITextView *contactUsMessage;
@property (strong, nonatomic) IBOutlet UIView *contactUsView;

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
    
    // set the delegate of the text and view fields
    self.contactUsMessage.delegate = self;
    self.contactUsSubject.delegate = self;
}

#pragma Methods

// restrict to portrait mode for iphone
-(void) restrictRotation:(BOOL) restriction
{
    TJKAppDelegate* appDelegate = (TJKAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.restrictRotation = restriction;
}

// send a message
-(void)contactUs:(id)sender
{
    // instantiate the alert object
    GHSAlerts *alerts = [[GHSAlerts alloc] initWithViewController:self];
    
    // check if the device can send mail
    if (![MFMailComposeViewController canSendMail])
    {
        [alerts displayErrorMessage:@"Invalid Submission" errorMessage:@"This device cannot send e-mail."];
        return;
    }
 
    // validate the fields
    NSArray *isValid = [NSArray arrayWithArray:self.validateSubmittedJoke];
    if ([isValid count] > 0)
    {
        // display the issues to the user
        NSString *errorMessage = [isValid componentsJoinedByString:@"\r\r"];
        [alerts displayErrorMessage:@"Invalid Submission" errorMessage:errorMessage];
        return;
    }
    
    // check for swear words
    NSMutableString *combineBadWords = [[NSMutableString alloc] init];
    [combineBadWords appendString:self.contactUsSubject.text];
    [combineBadWords appendString:@" "];
    [combineBadWords appendString:self.contactUsMessage.text];
    NSString *checkBadWords = [combineBadWords copy];
    
    GHSNoSwearing *foundBadWords = [[GHSNoSwearing alloc] init];
    NSString *badWords = [foundBadWords checkForSwearing:checkBadWords numberOfWordsReturned:MAX_NUMBER_OF_BAD_WORDS];
    
    // if bad words are found then display them and warn the user the joke might not be accepted, but e-mail the joke anyway
    if (![badWords isEqual: @"OK"])
    {
        NSString *badWordsMessage = [@"You can submit your message, but we might not respond due to the following word(s) found:\r\r" stringByAppendingString:badWords];
        errorActionBlock errorBlock = ^void(UIAlertAction *action) {[self sendMessage];};
        [alerts displayErrorMessage:@"Possible Problem" errorMessage:badWordsMessage errorAction:errorBlock];
    }
    else
    {
        [self sendMessage];
    }
}

// send the e-mail
-(void)sendMessage
{
    // get the e-mail address from the data source
    CKDatabase *jokePublicDatabase = [[CKContainer containerWithIdentifier:JOKE_CONTAINER] publicCloudDatabase];
    CKRecordID *parameterRecordID = [[CKRecordID alloc] initWithRecordName:PARAMETERS_CATEGORY_RECORD_NAME];
    [jokePublicDatabase fetchRecordWithID:parameterRecordID completionHandler:^(CKRecord *parameterRecord, NSError *error)
    {
        if (!error)
        {
            // setup the string for the message body
            NSString *subject = self.contactUsSubject.text;
            subject = [subject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *message = self.contactUsMessage.text;
            NSString *messageBody = [NSString stringWithFormat:@"%@%@\n\n%@%@\n\n",
                                     @"Subject: ", subject,
                                     @"Message: ", message];
            
            // setup recipients
            NSString *jokeSubmittedBy = [parameterRecord objectForKey:PARAMETERS_CONTACT_US_EMAIL];
            NSArray *toRecipents = [NSArray arrayWithObject:jokeSubmittedBy];
            
            // prepare the mail message
            mailComposer = [[MFMailComposeViewController alloc] init];
            mailComposer.mailComposeDelegate = self;
            [mailComposer setSubject:@"Contact Us"];
            [mailComposer setMessageBody:messageBody isHTML:NO];
            [mailComposer setToRecipients:toRecipents];
            
            // present mail on the screen
            [self presentViewController:mailComposer animated:YES completion:nil];
        }
        else
        {
            // display error message
            dispatch_async(dispatch_get_main_queue(), ^{
                GHSAlerts *alert = [[GHSAlerts alloc] initWithViewController:self];
                [alert displayErrorMessage:@"Problem" errorMessage:@"Could not obtain recipient e-mail address. Please try again later."];
            });
        }
    }];
}

// validate the entered text
-(NSArray *)validateSubmittedJoke
{
    // declare an array
    NSMutableArray *valid = [[NSMutableArray alloc] init];
    
    // check if the joke category is not empty as it not set to "NONE"
    if (![self.contactUsSubject hasText])
    {
        // if empty or none indicae this in the array
        [valid addObject:@"Please enter a \"Subject\"."];
    }
    
    // check if a joke was entered
    if (![self.contactUsMessage hasText])
    {
        // if empty indicate there must be a joke present
        [valid addObject:@"Please enter a \"Message\"."];
    }
    
    return [valid copy];
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

// move screen up when editing starts
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag > 1)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3];
        [UIView setAnimationBeginsFromCurrentState:TRUE];
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y -MOVE_SCREEN_Y_AXIS_TEXT, self.view.frame.size.width, self.view.frame.size.height);
        
        [UIView commitAnimations];
    }
}

// move screen down when editing ends
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag > 1)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3];
        [UIView setAnimationBeginsFromCurrentState:TRUE];
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y +MOVE_SCREEN_Y_AXIS_TEXT, self.view.frame.size.width, self.view.frame.size.height);
        
        [UIView commitAnimations];
    }
}

// move screen up when editing begins in joke field
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView.tag == 2)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3];
        [UIView setAnimationBeginsFromCurrentState:TRUE];
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y -MOVE_SCREEN_Y_AXIS_VIEW, self.view.frame.size.width, self.view.frame.size.height);
        
        [UIView commitAnimations];
    }
}

// move screen down when editing ends in joke field
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.tag == 2)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3];
        [UIView setAnimationBeginsFromCurrentState:TRUE];
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y +MOVE_SCREEN_Y_AXIS_VIEW, self.view.frame.size.width, self.view.frame.size.height);
        
        [UIView commitAnimations];
    }
}

// remove keyboard when return key is pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// remove keyboard when the background is tapped
- (IBAction)backgroundTapped:(id)sender
{
    [self.view endEditing:YES];
}



@end
