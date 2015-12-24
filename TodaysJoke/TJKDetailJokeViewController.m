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
    
    // setup picker view
    //_jokeCategoryPicker.showsSelectionIndicator = YES;
    //_jokeCategoryPicker.hidden = YES;
    //[_jokeCategoryPicker selectRow:0 inComponent:0 animated:YES];
    //_jokeCategory.text = _jokeCategories[0];
    
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
    //self.jokeCategoryPickerToolbar.hidden = YES;
    //self.jokeCategoryPicker.hidden = YES;
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

// dismis keyboard if background is selected
- (IBAction)backgroundTapped:(id)sender
{
    [self.view endEditing:YES];
}

@end
