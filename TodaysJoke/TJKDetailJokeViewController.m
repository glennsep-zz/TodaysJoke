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

@interface TJKDetailJokeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *jokeTitle;
@property (weak, nonatomic) IBOutlet UITextField *jokeCategory;
@property (weak, nonatomic) IBOutlet UITextView *joke;
@property (weak, nonatomic) IBOutlet UIPickerView *jokeCategoryPicker;
@property (strong, nonatomic) NSArray *jokeCategories;
@property (strong, nonatomic) IBOutlet UIView *jokeDetailView;
@property (weak, nonatomic) IBOutlet UIButton *selectCategoryButton;

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
    
    // setup picker view
    _jokeCategoryPicker.showsSelectionIndicator = YES;
    _jokeCategoryPicker.hidden = YES;
    [_jokeCategoryPicker selectRow:0 inComponent:0 animated:YES];
    _jokeCategory.text = _jokeCategories[0];
}

// submit the joke via e-mail
-(void)submitJoke:(id)sender
{
    // for now we will not send an e-mail we will just close the modal view
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
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

#pragma Actions

// display or hide the category picker.  Do not allow "None" to be selected
- (IBAction)selectCategoryPicker:(id)sender
{
    if (_jokeCategoryPicker.hidden == YES)
    {
        _jokeCategoryPicker.hidden = NO;
        [self.selectCategoryButton setTitle:@"Select Category" forState:UIControlStateNormal];
    }
    else if ([_jokeCategory.text  isEqual: @"None"])
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Invalid Category"
                                                                       message:@"The category \"None\" cannot be used"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        _jokeCategoryPicker.hidden = YES;
        [self.selectCategoryButton setTitle:@"Show Categories" forState:UIControlStateNormal];
    }
}

// dismis keyboard if background is selected
- (IBAction)backgroundTapped:(id)sender
{
    [self.view endEditing:YES];
}

@end
