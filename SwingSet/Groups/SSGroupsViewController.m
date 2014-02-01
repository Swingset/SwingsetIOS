//
//  SSGroupsViewController.m
//  SwingSet
//
//  Created by Denny Kwon on 1/21/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSGroupsViewController.h"
#import "SSGroupViewController.h"
#import "SSButton.h"
#import "SSNavigationController.h"

@interface SSGroupsViewController ()

@property (strong, nonatomic) UITableView *groupsTableView;
@property (strong, nonatomic) UILabel     *lblSelect;
@property (strong, nonatomic) SSButton    *btnAddNewGroup;
@property (strong, nonatomic) NSArray     *dummyData;

@end

@implementation SSGroupsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeAll;
        self.dummyData = [NSArray arrayWithObjects:@"@first lastname",
                          @"@second lastname",
                          @"@third lastname",
                          @"@firstname last",
                          @"@first ln", nil];
    }
    return self;
}

- (void)loadView
{
    UIView *view = [self baseView:YES];
    CGRect frame = view.frame;
    
    view.backgroundColor = kDarkGray;
    
    CGFloat y = 0.0f;
    self.lblSelect = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, y, frame.size.width, 45.0f)];
    self.lblSelect.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin);
    self.lblSelect.textColor = [UIColor blackColor];
    self.lblSelect.backgroundColor = kLightGray;
    self.lblSelect.textAlignment = NSTextAlignmentCenter;
    self.lblSelect.font = [UIFont fontWithName:@"ProximaNova-Black" size:18.0f];
    self.lblSelect.text = @"Select a group to change settings";
    [view addSubview:self.lblSelect];
    y += self.lblSelect.frame.size.height;
    
    self.groupsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, y, frame.size.width, frame.size.height-y-80.0f)];
    self.groupsTableView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin);
    self.groupsTableView.backgroundColor = kGrayTable;
    self.groupsTableView.delegate = self;
    self.groupsTableView.dataSource = self;
    self.groupsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupsTableView.separatorInset = UIEdgeInsetsZero;
    [view addSubview:self.groupsTableView];
    y += self.groupsTableView.frame.size.height;
    
    int btnWidth = 200.0f;
    self.btnAddNewGroup = [SSButton buttonWithFrame:CGRectMake(0.5*(frame.size.width-btnWidth), frame.size.height-60.0f, btnWidth, 40.0f) title:@"Add a Group" textMode:TextModeUpperCase];
    self.btnAddNewGroup.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin);
    [self.btnAddNewGroup addTarget:self action:@selector(btnNewGroupAction:) forControlEvents:UIControlEventTouchUpInside];
    self.btnAddNewGroup.backgroundColor = kGreenNext;
    [view addSubview:self.btnAddNewGroup];
    
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    SSNavigationController *navController = (SSNavigationController *)self.navigationController;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"menu"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:navController
                                                                            action:@selector(toggle)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dummyData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellID"];
        cell.textLabel.font = [UIFont fontWithName:@"ProximaNova-Black" size:14.0];
        cell.textLabel.textColor = kLightBlue;
        cell.backgroundColor = kGrayTable;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [self.dummyData objectAtIndex:(indexPath.row % [self.dummyData count])];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SSGroupViewController *groupViewController = [[SSGroupViewController alloc] init];
    [self.navigationController pushViewController:groupViewController animated:YES];
}

#pragma mark UIButton handlers
- (void)btnNewGroupAction:(UIButton *)btn
{
    
    
    
    
}

@end
