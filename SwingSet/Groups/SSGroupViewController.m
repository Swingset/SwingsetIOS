//
//  SSGroupViewController.m
//  SwingSet
//
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSGroupViewController.h"
#import "SSButton.h"
#import "Config.h"
#import "SSInviteMembersViewController.h"


@interface SSGroupViewController ()
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) SSButton *btnAddMember;
@property (strong, nonatomic) SSButton *btnRemoveMember;
@property (strong, nonatomic) SSButton *btnLeaveGroup;
@property (strong, nonatomic) SSButton *btnNotification;
@property (strong, nonatomic) UILabel *lblGroupName;
@property (strong, nonatomic) UILabel *lblGroupMembers;
@property (strong, nonatomic) UITableView *theTableView;
@property (nonatomic) BOOL isDeleteMode;
@end

@implementation SSGroupViewController
@synthesize group;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isDeleteMode = NO;
        self.edgesForExtendedLayout = UIRectEdgeAll;
        
    }
    return self;
}

- (void)loadView
{
    UIView *view = [self baseView:YES];
    CGRect frame = view.frame;
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(-5.0f, 0.0f, frame.size.width+10.0f, 84.0f)];
    self.topView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight);
    self.topView.layer.borderWidth = 1.0f;
    self.topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hb_bg_whiter.png"]];
    self.topView.layer.borderColor = kGrayBorder.CGColor;
    
    CGFloat y = 0.0f;
    self.lblGroupName = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, y, frame.size.width/2.0f, 30.0f)];
    self.lblGroupName.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin);
    self.lblGroupName.text = @"GROUP NAME";
    self.lblGroupName.textColor = [UIColor blackColor];
    self.lblGroupName.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:16.0f];
    [self.topView addSubview:self.lblGroupName];
    
    CGFloat elemWidth = 90.0f;
    self.lblGroupMembers = [[UILabel alloc] initWithFrame:CGRectMake(238.0f, y, elemWidth, 30.0f)];
    self.lblGroupMembers.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin);
    self.lblGroupMembers.textColor = [UIColor grayColor];
    self.lblGroupMembers.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:13.0f];
    self.lblGroupMembers.text = [NSString stringWithFormat:@"15 members"];
    self.lblGroupMembers.backgroundColor = [UIColor clearColor];
    [self.topView addSubview:self.lblGroupMembers];

    // Add Buttons
    elemWidth = 110.0f;
    CGFloat elemHeight = 30.0f;
    
    self.btnAddMember = [SSButton buttonWithFrame:CGRectMake(20.0f, 35.0f, elemWidth, elemHeight) title:@"Add Member" textMode:TextModeDefault];
    self.btnAddMember.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin);
    self.btnAddMember.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0f];
    [self.btnAddMember setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 13.0f, 0.0f, 0.0f)];
    self.btnAddMember.backgroundColor = kMidGrayButton;
    self.btnAddMember.layer.cornerRadius = 2.0f;

    
    UIImage *plusIcon = [UIImage imageNamed:@"plusIconWhite.png"];
    UIImageView *plusImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 7.0f, 15.0f, 15.0f)];
    plusImgView.image = plusIcon;
    [self.btnAddMember addSubview:plusImgView];
    [self.btnAddMember addTarget:self action:@selector(btnAddMemberAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.btnAddMember];
    
    self.btnRemoveMember = [SSButton buttonWithFrame:CGRectMake(180.0f, 35.0f, elemWidth+20.0f, elemHeight) title:@"Remove Member" textMode:TextModeDefault];
    self.btnRemoveMember.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin);
    self.btnRemoveMember.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0f];
    [self.btnRemoveMember setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 13.0f, 0.0f, 0.0f)];
    self.btnRemoveMember.backgroundColor = kMidGrayButton;
    self.btnRemoveMember.layer.cornerRadius = 2.0f;

    UIImageView *plusImgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 7.0f, 15.0f, 15.0f)];
    plusImgView2.image = plusIcon;
    [self.btnRemoveMember addSubview:plusImgView2];
    [self.btnRemoveMember addTarget:self action:@selector(btnRemoveMemberAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.btnRemoveMember];

    [view addSubview:self.topView];
    y += self.topView.frame.size.height;

    
    self.theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, y, frame.size.width, frame.size.height-y-64.0f)];
    self.theTableView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin);
    self.theTableView.backgroundColor = kGrayTable;
    self.theTableView.delegate = self;
    self.theTableView.dataSource = self;
    self.theTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.theTableView.separatorInset = UIEdgeInsetsZero;
    [view addSubview:self.theTableView];
    y += self.theTableView.frame.size.height;
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, y, frame.size.width, frame.size.height-y)];
    self.bottomView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin);
    self.bottomView.backgroundColor = kDarkGray;

    
    self.btnLeaveGroup = [SSButton buttonWithFrame:CGRectMake(15.0f, 10.0f, 80.0f, 20.0f) title:@"Leave Group" textMode:TextModeDefault];
    self.btnLeaveGroup.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0f];
    self.btnLeaveGroup.backgroundColor = kDarkGrayButton;
    self.btnLeaveGroup.layer.cornerRadius = 2.0;
    [self.btnLeaveGroup addTarget:self action:@selector(btnLeaveGroupAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.btnLeaveGroup];

    
    self.btnNotification = [SSButton buttonWithFrame:CGRectMake(180, 10, 120, 20) title:@"Notifications On" textMode:TextModeDefault];
    self.btnNotification.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0f];
    [self.btnNotification setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    self.btnNotification.backgroundColor = kGreenNext;
    self.btnNotification.layer.cornerRadius = 2.0;
    
    UIImageView *bellImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 4.0f, 12.0f, 12.0f)];
    bellImgView.image = [UIImage imageNamed:@"whiteBellIcon@2x.png"];
    [self.btnNotification addSubview:bellImgView];
    
    [_btnNotification addTarget:self action:@selector(btnNotificationAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:self.btnNotification];
    [view addSubview:self.bottomView];

    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self.navigationController action:@selector(popViewControllerAnimated:)];
    
    [self.loadingIndicator startLoading];
    [[SSWebServices sharedInstance] fetchGroupInfo:self.group completionBlock:^(id result, NSError *error){
        [self.loadingIndicator stopLoading];
        if (error) {
            
        }
        else {
            NSDictionary *results = (NSDictionary *)result;
            NSLog(@"results: %@", [results description]);
            NSString *confirmation = [results objectForKey:@"confirmation"];
            
            if ([confirmation isEqualToString:@"success"]){
                self.group = [results objectForKey:@"group"];
                [self.theTableView reloadData];
            }
            else{
                [self showAlert:@"Error" withMessage:[results objectForKey:@"message"]];
            }
        }
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark UITable Delegate/Datasource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *membersArray = self.group[@"members"];
    return membersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellID"];
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hb_background_white@2x.png"]];
        cell.imageView.image = [UIImage imageNamed:@"personIcon.png"];
        cell.textLabel.font = [UIFont fontWithName:@"ProximaNova-Black" size:14.0];
        cell.textLabel.textColor = kLightBlue;
        cell.backgroundColor = kGrayTable;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton *btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDelete.tag = 1000;
        [btnDelete setTitle:@"remove" forState:UIControlStateNormal];
        [btnDelete setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btnDelete.frame = CGRectMake(tableView.frame.size.width-70, 5, 60, 30);
        [btnDelete addTarget:self action:@selector(btnDeleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnDelete];
    }
    
    cell.tag = indexPath.row;
    UIButton *btnDelete = (UIButton *)[cell.contentView viewWithTag:1000];
    btnDelete.alpha = (self.isDeleteMode) ? 1.0f : 0.0f;
    NSArray *membersArray = self.group[@"members"];
    id member = [membersArray objectAtIndex:indexPath.row];
//    NSLog(@"MEMBER: %@", [member description]);
    if ([[member class] isSubclassOfClass:[NSDictionary class]]){
        cell.textLabel.text = member[@"username"];
    }
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Group Cell Tapped");
    
}

#pragma mark button action handlers

- (void)btnAddMemberAction:(UIButton *)btn
{
//    NSLog(@"add member tapped");
    SSInviteMembersViewController *inviteVc = [[SSInviteMembersViewController alloc] init];
    inviteVc.group = self.group;
    [self.navigationController pushViewController:inviteVc animated:YES];
    
    
    
}

- (void)btnRemoveMemberAction:(UIButton *)btn
{
    NSLog(@"remove member tapped");
    self.isDeleteMode = !self.isDeleteMode;
    [self.theTableView reloadData];
    
}

- (void)btnDeleteAction:(UIButton *)btn
{
    int index = (int)btn.superview.superview.superview.tag;
    NSDictionary *member = self.group[@"members"][index];
    
    NSLog(@"btnDeleteAction: %@", [member description]);
    
    [self.loadingIndicator startLoading];
    [[SSWebServices sharedInstance] removeMember:member[@"id"] fromGroup:self.group completionBlock:^(id result, NSError *error){
        [self.loadingIndicator stopLoading];
        if (error){
            [self showAlert:@"Error" withMessage:[error localizedDescription]];
        }
        else{
            NSDictionary *results = (NSDictionary *)result;
            NSLog(@"%@", [results description]);
            NSString *confirmation = [results objectForKey:@"confirmation"];
            if ([confirmation isEqualToString:@"success"]){
                NSDictionary *groupInfo = [results objectForKey:@"group"];
                self.group = groupInfo;
                [self.theTableView reloadData];
            }
            else{
                [self showAlert:@"Error" withMessage:results[@"message"]];
            }
        }
        
    }];

}

- (void)btnLeaveGroupAction:(UIButton *)btn
{
    NSLog(@"leave group tapped");
    
    [self.loadingIndicator startLoading];
    [[SSWebServices sharedInstance] removeMember:self.profile.uniqueId fromGroup:self.group completionBlock:^(id result, NSError *error){
        [self.loadingIndicator stopLoading];
        if (error){
            [self showAlert:@"Error" withMessage:[error localizedDescription]];
        }
        else{
            NSDictionary *results = (NSDictionary *)result;
            NSLog(@"%@", [results description]);
            NSString *confirmation = [results objectForKey:@"confirmation"];
            if ([confirmation isEqualToString:@"success"]){
                NSDictionary *groupInfo = [results objectForKey:@"group"];
                [self.profile removeGroup:groupInfo];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                [self showAlert:@"Error" withMessage:results[@"message"]];
            }
        }
        
    }];
    
}

- (void)btnNotificationAction:(UIButton *)btn
{
    NSLog(@"notification tapped");
    
    
}

@end