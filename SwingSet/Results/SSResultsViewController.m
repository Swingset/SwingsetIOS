//
//  SSResultsViewController.m
//  SwingSet
//
//  Created by Denny Kwon on 2/13/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSResultsViewController.h"
#import "SSGroupResultsViewController.h"


@interface SSResultsViewController ()
@property (strong, nonatomic) UILabel *lblName;
@property (strong, nonatomic) UITableView *groupsTable;
@end

@implementation SSResultsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.edgesForExtendedLayout = UIRectEdgeAll;
        
    }
    return self;
}

- (void)loadView
{
    UIView *view = [self baseView:YES];
    CGRect frame = view.frame;
    
    CGFloat padding = 15.0f;
    CGFloat y = padding;
    self.lblName = [[UILabel alloc] initWithFrame:CGRectMake(padding, y, frame.size.width-2*padding, 36.0f)];
    self.lblName.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.lblName.font = [UIFont fontWithName:@"ProximaNova-Bold" size:24.0f];
    self.lblName.textColor = [UIColor blackColor];
    self.lblName.text = self.profile.name;
    self.lblName.backgroundColor = [UIColor clearColor];
    [view addSubview:self.lblName];
    y += self.lblName.frame.size.height+80.0f;
    
    
    UILabel *lblSelect = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, y, frame.size.width, 36.0f)];
    lblSelect.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    lblSelect.font = [UIFont fontWithName:@"ProximaNova-Bold" size:16.0f];
    lblSelect.textAlignment = NSTextAlignmentCenter;
    lblSelect.text = @"Select a Group to View Results";
    lblSelect.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:lblSelect];
    y += lblSelect.frame.size.height;
    
    self.groupsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, y, frame.size.width, frame.size.height-y)];
    self.groupsTable.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin);
    self.groupsTable.dataSource = self;
    self.groupsTable.delegate = self;
    self.groupsTable.backgroundColor = kGrayTable;
    self.groupsTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupsTable.separatorInset = UIEdgeInsetsZero;
    self.groupsTable.showsVerticalScrollIndicator = NO;
    [view addSubview:self.groupsTable];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SSNavigationController *navController = (SSNavigationController *)self.navigationController;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btnMenu.png"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:navController
                                                                            action:@selector(toggle)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStyleBordered target:self action:@selector(logout:)];

}

- (void)logout:(UIBarButtonItem *)btn
{
    NSLog(@"logout:");
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"Logout" object:nil]];
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.profile.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.textLabel.font = [UIFont fontWithName:@"ProximaNova-Black" size:14.0];
        cell.textLabel.textColor = kLightBlue;
        cell.backgroundColor = kGrayTable;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *group = self.profile.groups[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"@%@", group[@"name"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *group = self.profile.groups[indexPath.row];
    SSGroupResultsViewController *groupResults = [[SSGroupResultsViewController alloc] init];
    groupResults.group = group;
    [self.navigationController pushViewController:groupResults animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
