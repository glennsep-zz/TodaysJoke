//
//  TJKCategoriesViewController.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 1/3/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import "TJKCategoriesViewController.h"
#import "TJKJokeItem.h"

@interface TJKCategoriesViewController () 

@property (nonatomic, weak) IBOutlet UITableView *categoriesTableView;
@property (nonatomic, weak) IBOutlet UITableViewCell *cellCategories;
@property (nonatomic, strong) NSMutableArray *tableContents;
@property (strong, nonatomic) NSArray *jokeCategories;

@end

@implementation TJKCategoriesViewController

#pragma Initializers

// init the NIB
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

#pragma View Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableContents];
}

#pragma Methods

// setup the array that will hold the table's contents
-(void)setupTableContents
{
    // define the array with the table contents
    _jokeCategories = [[NSArray alloc] initWithArray:_jokeItem.jokeCategories];
    
    // store to property and reload the table contents
    self.tableContents = [NSMutableArray arrayWithArray:_jokeCategories];
    [self.tableContents removeObjectAtIndex:0];
    [self.categoriesTableView reloadData];
}

#pragma Table View Methods

// indicate the number of sections
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// indicate the number of rows in section
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableContents count];
}

// display the contents of the table
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    static NSString *cellMainNibId = @"cellCategories";
    
    _cellCategories = [tableView dequeueReusableCellWithIdentifier:cellMainNibId];
    if (_cellCategories == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"TJKCategoriesCell" owner:self options:nil];
    }

    UILabel *creator = (UILabel *)[_cellCategories viewWithTag:3];
    
    if ([_tableContents count] > 0)
    {
        NSString *currentRecord = [self.tableContents objectAtIndex:indexPath.row];
        creator.text =  [NSString stringWithFormat:@"%@", currentRecord];
    }
    
    return _cellCategories;
}

@end
