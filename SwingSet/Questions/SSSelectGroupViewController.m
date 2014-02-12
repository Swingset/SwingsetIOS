//
//  SSSelectGroupViewController.m
//  SwingSet
//
//  Created by Denny Kwon on 2/11/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSSelectGroupViewController.h"

@interface SSSelectGroupViewController ()
@property (strong, nonatomic) UITableView *groupsTableView;
@end


@implementation SSSelectGroupViewController
@synthesize question;


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
    
    self.groupsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
    self.groupsTableView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight);
    self.groupsTableView.backgroundColor = kGrayTable;
    self.groupsTableView.delegate = self;
    self.groupsTableView.dataSource = self;
    self.groupsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupsTableView.separatorInset = UIEdgeInsetsZero;
    [view addSubview:self.groupsTableView];

    
    self.view = view;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self.navigationController action:@selector(popViewControllerAnimated:)];

}


#pragma mark UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.profile.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"ProximaNova-Black" size:14.0];
        cell.textLabel.textColor = kLightBlue;
        cell.backgroundColor = kGrayTable;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *group = self.profile.groups[indexPath.row];
    cell.textLabel.text = group[@"name"];
    
    if ([group[@"id"] isEqualToString:self.question.group])
        cell.textLabel.textColor = kGreenNext;
    else
        cell.textLabel.textColor = [UIColor blackColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *group = self.profile.groups[indexPath.row];
//    NSLog(@"%@", [group description]);
    
    self.question.group = group[@"id"];
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end