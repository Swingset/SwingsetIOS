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
    
    self.lblSelect = [[UILabel alloc] initWithFrame:CGRectMake(0,65,frame.size.width,45)];
    _lblSelect.textColor = [UIColor blackColor];
    _lblSelect.backgroundColor = kLightGray;
    _lblSelect.textAlignment = NSTextAlignmentCenter;
    _lblSelect.font = [UIFont fontWithName:@"ProximaNova-Black" size:18.0f];
    _lblSelect.text = @"Select a group to change settings";
    
    self.groupsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,110,frame.size.width,frame.size.height - 110)];
    _groupsTableView.backgroundColor = kGrayTable;
    _groupsTableView.delegate = self;
    _groupsTableView.dataSource = self;
    _groupsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _groupsTableView.separatorInset = UIEdgeInsetsZero;
    
    int btnWidth = 200;
    self.btnAddNewGroup = [SSButton buttonWithFrame:CGRectMake(0,0,btnWidth,40) title:@"Add a Group" textMode:TextModeUpperCase];
    _btnAddNewGroup.center = CGPointMake(frame.size.width/2,frame.size.height + 30);
    [_btnAddNewGroup addTarget:self
                        action:@selector(btnNewGroupAction:)
              forControlEvents:UIControlEventTouchUpInside];
    _btnAddNewGroup.backgroundColor = kGreenNext;
    
    
    
    [view addSubview:_lblSelect];
    [view addSubview:_groupsTableView];
    [view addSubview:_btnAddNewGroup];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    SSViewController *container = (SSViewController *)self.navigationController.parentViewController;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"menu"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:container
                                                                            action:@selector(toggleSections)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellID"];
        
    }
    
    cell.textLabel.text = [_dummyData objectAtIndex:(indexPath.row % [_dummyData count])];
    cell.textLabel.font = [UIFont fontWithName:@"ProximaNova-Black" size:14.0];
    cell.textLabel.textColor = kLightBlue;
    cell.backgroundColor = kGrayTable;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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