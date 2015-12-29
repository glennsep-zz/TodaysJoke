//
//  TJKDetailJokeViewController.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/19/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import "TJKDetailJokeViewController.h"
#import "TJKJokeItem.h"
#import "TJKJokeItemStore.h"
#import "GHSNoSwearing.h"
#import "GHSAlerts.h"

@interface TJKDetailJokeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *jokeTitle;
@property (weak, nonatomic) IBOutlet UITextField *jokeCategory;
@property (weak, nonatomic) IBOutlet UITextView *joke;
@property (strong, nonatomic) UIPickerView *jokeCategoryPicker;
@property (strong, nonatomic) NSArray *jokeCategories;
@property (strong, nonatomic) IBOutlet UIView *jokeDetailView;
@property (strong, nonatomic) UIToolbar * jokeCategoryPickerToolbar;

@end

@implementation TJKDetailJokeViewController

#pragma Initializers

// check if this is displaying a new joke item or an existing one
-(instancetype)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self)
    {
        if (isNew)
        {
            // create button to submit an e-mail
            UIBarButtonItem *submitItem = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                           target:self
                                           action:@selector(submitJoke:)];
            self.navigationItem.rightBarButtonItem = submitItem;
            
            // create button to cancel the item
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                           target:self
                                           action:@selector(cancelJoke:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
            
        }
    }
    
    return self;
}

// override the UIViewController's designated initializer to prevent its use, we want to
// use initForNewItem instead
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    [NSException raise:@"Wrong Initializer"
                format:@"Use initForNewItem:"];
    return nil;
}


#pragma Methods

// implement actions when the view is loaded
-(void)viewDidLoad
{
    // call super method
    [super viewDidLoad];
    
    // setup border for text view (used to type in joke)
    UIColor *borderColor = [UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1.0];
    self.joke.layer.borderWidth = 1.0f;
    self.joke.layer.borderColor = borderColor.CGColor;
    self.joke.layer.cornerRadius = 5.0;
    
    // populate the array with category values
    _jokeCategories = @[@"None", @"Puns", @"Knock Knock Jokes", @"Funny Quotes", @"Ironic Jokes",
                        @"Clean Jokes"];
    
    // set initial value for joke category
    _jokeCategory.text = _jokeCategories[0];
    
    // set up the picker for the joke categories
    self.jokeCategoryPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 43, self.view.frame.size.width,self.view.frame.size.height / 4)];
    
    self.jokeCategoryPicker.delegate = self;
    self.jokeCategoryPicker.dataSource = self;
    [self.jokeCategoryPicker setShowsSelectionIndicator:YES];
    self.jokeCategory.inputView = _jokeCategoryPicker;
   
    
    // setup done button in picker
    self.jokeCategoryPickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,56)];
    self.jokeCategoryPickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [self.jokeCategoryPickerToolbar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                       target:self
                                                       action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                target:self
                                action:@selector(pickerDoneClicked)];
    [barItems addObject:doneBtn];
    [self.jokeCategoryPickerToolbar setItems:barItems animated:YES];
    self.jokeCategory.inputAccessoryView = self.jokeCategoryPickerToolbar;
}

// action to take when done button is pressed on picker toolbar
-(void)pickerDoneClicked
{
    [self.jokeCategory resignFirstResponder];
}

// submit the joke via e-mail
-(void)submitJoke:(id)sender
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
    [combineBadWords appendString:self.jokeTitle.text];
    [combineBadWords appendString:@" "];
    [combineBadWords appendString:self.joke.text];
    NSString *checkBadWords = [combineBadWords copy];
        
    GHSNoSwearing *foundBadWords = [[GHSNoSwearing alloc] init];
    NSString *badWords = [foundBadWords checkForSwearing:checkBadWords numberOfWordsReturned:10];
    
    // if bad words are found then display them and warn the user the joke might not be accepted, but e-mail the joke anyway
    if (![badWords isEqual: @"OK"])
    {
        NSString *badWordsMessage = [@"You can submit your joke, but it might not be accepted due to the following word(s) found: " stringByAppendingString:badWords];
        errorActionBlock errorBlock = ^void(UIAlertAction *action) {[self sendJokeViaEmail];};
        [alerts displayErrorMessage:@"Possible Problem" errorMessage:badWordsMessage errorAction:errorBlock];
    }
    else
    {
        [self sendJokeViaEmail];
    }
}

// send the e-mail
-(void)sendJokeViaEmail
{
    // setup the string for the message body
    NSString *jokeTitle = self.jokeTitle.text;
    NSString *jokeCategory = self.jokeTitle.text;
    NSString *joke = self.joke.text;
    NSString *messageBody = [NSString stringWithFormat:@"%@%@\n\n%@%@\n\n%@\n%@",
                             @"Joke Title: ", jokeTitle,
                             @"Joke Category: ", jokeCategory,
                             @"Joke:", joke];
    
    // setup recipients
    NSArray *toRecipents = [NSArray arrayWithObject:@"todaysjoke@glennseplowitz.com"];
    
    // prepare the mail message
    mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setSubject:@"Joke Submission"];
    [mailComposer setMessageBody:messageBody isHTML:NO];
    [mailComposer setToRecipients:toRecipents];
    
    // present mail on the screen
    [self presentViewController:mailComposer animated:YES completion:nil];
}

// cancel the adding of a new joke
-(void)cancelJoke:(id)sender
{
    // since the user cancelled remove the joke from the store
    [[TJKJokeItemStore sharedStore] removeItem:self.jokeItem];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

// indicate the number of items that can be selected in picker view
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// indicate the number of rows in the picker view
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _jokeCategories.count;
}

// return selected item in picker view
-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _jokeCategories[row];
}

// display the selected item in the picker view in the text field
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _jokeCategory.text = _jokeCategories[row];
}

// remove keyboard when return key is pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(NSArray *)validateSubmittedJoke
{
    // declare an array
    NSMutableArray *valid = [[NSMutableArray alloc] init];
    
    // check if the joke title field is empty
    if (![self.jokeTitle hasText])
    {
        // if empty indicate this in the array
        [valid addObject:@"Must enter a Joke Title."];
    }
    
    // check if the joke category is not empty as it not set to "NONE"
    if (![self.jokeCategory hasText] || [self.jokeCategory.text  isEqual: @"None"])
    {
        // if empty or none indicae this in the array
        [valid addObject:@"The Joke Category must contain a value and cannot be \"None\"."];
    }
    
    // check if a joke was entered
    if (![self.joke hasText])
    {
        // if empty indicate there must be a joke present
        [valid addObject:@"You must enter a Joke!"];
    }
    
    return [valid copy];
}

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

#pragma Actions

// dismis keyboard if background is selected
- (IBAction)backgroundTapped:(id)sender
{
    [self.view endEditing:YES];
}

@end
