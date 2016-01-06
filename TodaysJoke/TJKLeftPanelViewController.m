//
//  TJKLeftPanelViewController.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/31/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import "TJKLeftPanelViewController.h"
#import "TJKCategoriesViewController.h"
#import "TJKJokeItem.h"
#import "TJKJokeItemStore.h"

@interface TJKLeftPanelViewController ()

@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (nonatomic, weak) IBOutlet UITableViewCell *cellMain;
@property (nonatomic, strong) NSMutableArray *tableContents;

@end

@implementation TJKLeftPanelViewController

#pragma Initializers

// inits the NIB
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// called each time view appears
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma Methods

// setup the array that will hold the table's contents
-(void)setupTableContents
{
    // define array with table contents
    NSArray *tableContentsArray = @[@"Categories", @"Contact Us"];
    
    // store to propery and reload table contents
    self.tableContents = [NSMutableArray arrayWithArray:tableContentsArray];
    [self.leftTableView reloadData];
}

// display the list of categories
-(void)callCategoriesTable
{
    // create a new joke item
    TJKJokeItem *newJoke = [[TJKJokeItemStore sharedStore] createItem];
  
    // allocate and create instance of categories view controller
    TJKCategoriesViewController *categoriesViewController = [[TJKCategoriesViewController alloc] init];
    categoriesViewController.jokeItem = newJoke;
    
    // push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:categoriesViewController animated:YES];
}

#pragma Table View Methods

// indicate number of sections
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// indicate number of rows in section
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableContents count];
}

// display the table contents
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellMainNibID = @"cellMain";
    
    _cellMain = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
    if (_cellMain == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"TJKMainCellLeft" owner:self options:nil];
    }

    UILabel *creator = (UILabel *)[_cellMain viewWithTag:3];
    
    if ([_tableContents count] > 0)
    {
        NSString *currentRecord = [self.tableContents objectAtIndex:indexPath.row];

        creator.text = [NSString stringWithFormat:@"%@", currentRecord];
    }
     
    return _cellMain;
}

// display the list of categories
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    // display the selected option
    switch (indexPath.row)
    {
        // display the categories table
        case 0:
            [self callCategoriesTable];
            break;
        default:
            NSLog(@"No options available");
    }
}

@end
