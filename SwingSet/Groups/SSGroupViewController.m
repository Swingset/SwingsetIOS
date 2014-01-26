//
//  SSGroupViewController.m
//  SwingSet
//
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSGroupViewController.h"
#import "SSButton.h"
#import "Config.h"

@interface SSGroupViewController ()

// UIViews

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *bottomView;

@property (strong, nonatomic) UIImageView *topImageView;
@property (strong, nonatomic) UIImageView *bottomImageView;

// Button

@property (strong, nonatomic) SSButton *btnAddMember;
@property (strong, nonatomic) SSButton *btnRemoveMember;
@property (strong, nonatomic) SSButton *btnLeaveGroup;
@property (strong, nonatomic) SSButton *btnNotification;

// Labels

@property (strong, nonatomic) UILabel *lblGroupName;
@property (strong, nonatomic) UILabel *lblGroupMembers;

// Table

@property (strong, nonatomic) UITableView *theTableView;

// Dummy Data

@property (strong, nonatomic) NSArray *dummyData;
@property (strong, nonatomic) NSString *groupName;

@end

@implementation SSGroupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.edgesForExtendedLayout = UIRectEdgeAll;
        
        // populate dummy data
        
        self.dummyData = [NSArray arrayWithObjects:@"@first lastname",
                          @"@second lastname",
                          @"@third lastname",
                          @"@firstname last",
                          @"@firstname last",
                          @"@firstname lbub",
                          @"@firstname yeah",
                          @"@firstname someone",
                          @"@firstname me",
                          @"@firstname notyou",
                          @"@firstname lucky",
                          @"@firstname okbye",
                          @"@firstname last",
                          @"@first ln", nil];
        
        self.groupName = @"Some Group";
        
    }
    return self;
}

- (void)loadView
{
    UIView *view = [self baseView:YES];
    CGRect frame = view.frame;
    int elemWidth, elemHeight;
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(-5,64,frame.size.width+10, 84)];
    _topView.layer.borderWidth = 1.0;
    _topView.layer.borderColor = kGrayBorder.CGColor;
    
    self.topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,frame.size.width+10, 84)];
    _topImageView.image = [UIImage imageNamed:@"hb_bg_whiter@2x.png"];
    
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,frame.size.height,frame.size.width,64)];
    self.bottomView.backgroundColor = kDarkGray;
    self.bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,frame.size.height,frame.size.width,64)];
    
    self.lblGroupName = [[UILabel alloc] initWithFrame:CGRectMake(20,0,frame.size.width/2,30)];
    self.lblGroupName.text = _groupName;
    self.lblGroupName.textColor = [UIColor blackColor];
    self.lblGroupName.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:16.0f];
    self.lblGroupName.backgroundColor = [UIColor clearColor];
    
    elemWidth = 90;
    self.lblGroupMembers = [[UILabel alloc] initWithFrame:CGRectMake(238, 0, elemWidth, 30)];
    self.lblGroupMembers.text = [NSString stringWithFormat:@"%d Members",[_dummyData count]];
    self.lblGroupMembers.textColor = [UIColor grayColor];
    self.lblGroupMembers.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:13.0f];
    self.lblGroupMembers.backgroundColor = [UIColor clearColor];
    
    // Add Buttons
    
    elemWidth = 110;
    elemHeight = 30;
    
    UIImage *plusImg = [UIImage imageNamed:@"plusIconWhite.png"];
    UIImage *bellImg = [UIImage imageNamed:@"whiteBellIcon@2x.png"];
    
    self.btnAddMember = [SSButton buttonWithFrame:CGRectMake(20, 35, elemWidth, elemHeight) title:@"Add Member" textMode:TextModeDefault];
    _btnAddMember.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0f];
    [_btnAddMember setTitleEdgeInsets:UIEdgeInsetsMake(0, 13, 0, 0)];
    _btnAddMember.backgroundColor = kMidGrayButton;
    _btnAddMember.layer.cornerRadius = 2.0;
    
    
    UIImageView *plusImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5,7,15,15)];
    plusImgView.image = plusImg;
    [_btnAddMember addSubview:plusImgView];
    
    [_btnAddMember addTarget:self
                      action:@selector(btnAddMemberAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    self.btnRemoveMember = [SSButton buttonWithFrame:CGRectMake(180, 35, elemWidth + 20, elemHeight) title:@"Remove Member" textMode:TextModeDefault];
    _btnRemoveMember.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0f];
    [_btnRemoveMember setTitleEdgeInsets:UIEdgeInsetsMake(0, 13, 0, 0)];
    _btnRemoveMember.backgroundColor = kMidGrayButton;
    _btnRemoveMember.layer.cornerRadius = 2.0;
    
    UIImageView *plusImgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(5,7,15,15)];
    plusImgView2.image = plusImg;
    [_btnRemoveMember addSubview:plusImgView2];
    
    [_btnRemoveMember addTarget:self
                         action:@selector(btnRemoveMemberAction:)
               forControlEvents:UIControlEventTouchUpInside];
    
    self.btnLeaveGroup = [SSButton buttonWithFrame:CGRectMake(15, 10, 80, 20) title:@"Leave Group" textMode:TextModeDefault];
    _btnLeaveGroup.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0f];
    _btnLeaveGroup.backgroundColor = kDarkGrayButton;
    _btnLeaveGroup.layer.cornerRadius = 2.0;
    [_btnLeaveGroup addTarget:self
                       action:@selector(btnLeaveGroupAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    self.btnNotification = [SSButton buttonWithFrame:CGRectMake(180, 10, 120, 20) title:@"Notifications On" textMode:TextModeDefault];
    _btnNotification.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0f];
    [_btnNotification setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    _btnNotification.backgroundColor = kGreenNext;
    _btnNotification.layer.cornerRadius = 2.0;
    
    UIImageView *bellImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5,4,12,12)];
    bellImgView.image = bellImg;
    [_btnNotification addSubview:bellImgView];
    
    [_btnNotification addTarget:self
                         action:@selector(btnNotificationAction:)
               forControlEvents:UIControlEventTouchUpInside];
    
    
    self.theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,160,frame.size.width,frame.size.height - 160)];
    _theTableView.backgroundColor = kGrayTable;
    _theTableView.delegate = self;
    _theTableView.dataSource = self;
    _theTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _theTableView.separatorInset = UIEdgeInsetsZero;
    
    [_topView addSubview:_topImageView];
    [_topView addSubview:_lblGroupName];
    [_topView addSubview:_lblGroupMembers];
    [_topView addSubview:_btnAddMember];
    [_topView addSubview:_btnRemoveMember];
    
    [_bottomView addSubview:_btnLeaveGroup];
    [_bottomView addSubview:_btnNotification];
    
    [view addSubview:_topView];
    [view addSubview:_bottomView];
    [view addSubview:_theTableView];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITable Delegate/Datasource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dummyData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellID"];
        
        
        UIImageView *cellBackImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
        cellBackImageView.backgroundColor=[UIColor clearColor];
        
        
        cellBackImageView.image = [UIImage imageNamed:@"hb_background_white@2x.png"];
        cell.backgroundView = cellBackImageView;
        cell.imageView.image = [UIImage imageNamed:@"personIcon.png"];
    }
    
    cell.textLabel.text = [_dummyData objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"ProximaNova-Black" size:14.0];
    cell.textLabel.textColor = kLightBlue;
    cell.backgroundColor = kGrayTable;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Group Cell Tapped");
    
}

#pragma mark button action handlers

- (void)btnAddMemberAction:(UIButton *)btn
{
    NSLog(@"add member tapped");
    
    
    
}

- (void)btnRemoveMemberAction:(UIButton *)btn
{
    NSLog(@"remove member tapped");
    
    
    
}

- (void)btnLeaveGroupAction:(UIButton *)btn
{
    NSLog(@"leave group tapped");
    
    
    
}

- (void)btnNotificationAction:(UIButton *)btn
{
    NSLog(@"notification tapped");
    
    
}

@end