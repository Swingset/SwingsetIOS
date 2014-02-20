//
//  SSContainerViewController.m
//  SwingSet
//
//  Created by Denny Kwon on 1/21/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSContainerViewController.h"
#import "SSRegisterViewController.h"
#import "SSNavigationController.h"
#import "SSQuestionsViewController.h"
#import "SSGroupsViewController.h"
#import "SSConfirmViewController.h"
#import "SSTableCell.h"
#import "SSCreateGroupViewController.h"
#import "SSCreateQuestionViewController.h"
#import "SSResultsViewController.h"


@interface SSContainerViewController ()
@property (strong, nonatomic) UIView *baseView;
@property (strong, nonatomic) UITableView *sectionsTable;
@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) SSNavigationController *navCtr;
@property (strong, nonatomic) SSQuestionsViewController *homeVc;
@property (strong, nonatomic) SSQuestionsViewController *groupQuestionsVc;
@property (strong, nonatomic) SSGroupsViewController *groupsVc;
@property (strong, nonatomic) SSCreateGroupViewController *createGroupVc;
@property (strong, nonatomic) SSCreateQuestionViewController *createQuestionVc;
@property (strong, nonatomic) SSResultsViewController *resultsVc;
@property (strong, nonatomic) SSViewController *currentVC;
@property (nonatomic) CGFloat span;

@property (strong, nonatomic) UIImageView *frontPageImage;
@property (strong, nonatomic) UIImageView *groupsImage;
@property (strong, nonatomic) UIImageView *createANewGroupImage;
@property (strong, nonatomic) UIImageView *resultsImage;
@property (strong, nonatomic) UIImageView *askQuestionImage;
@property (strong, nonatomic) NSArray *icons;
@end

@implementation SSContainerViewController

#define kSectionsIndent 200.0f

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.sections = @[@"Front Page", @"Groups", @"Create A New Group", @"Results"];
        self.icons = @[@"Front Pageicon.png", @"GroupsIcon.png", @"plusicon.png", @"Resultsicon.png"];
        self.span = 416.0f-160.0f;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:@"Logout" object:nil];

    }
    return self;
}

- (void)loadView
{
    UIView *view = [self baseView:NO];
    CGRect frame = view.frame;
    
    view.backgroundColor = [UIColor blackColor];
    
    
    self.baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.baseView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight);
    [view addSubview:self.baseView];
    
    self.sectionsTable = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height+20.0f)];
    self.sectionsTable.dataSource = self;
    self.sectionsTable.delegate = self;
    self.sectionsTable.separatorStyle = UITableViewCellSelectionStyleGray;
    self.sectionsTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hb_bg_grey01.png"]];
    
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.sectionsTable.frame.size.width, 150.0f)];
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SwingsetWordmark.png"]];
    double scale = 0.75f;
    logo.frame = CGRectMake(10.0f, 50.0f, scale*logo.frame.size.width, scale*logo.frame.size.height);
    [logoView addSubview:logo];
    self.sectionsTable.tableHeaderView = logoView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0f, self.sectionsTable.frame.size.width, 44.0f)];
    footerView.backgroundColor = [UIColor clearColor];
    self.sectionsTable.tableFooterView = footerView;
    
    
    [self.baseView addSubview:self.sectionsTable];
    
    UIView *questionView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-footerView.frame.size.height+20.0f, self.sectionsTable.frame.size.width, footerView.frame.size.height)];
    questionView.backgroundColor = self.sectionsTable.backgroundColor;
    
    UIButton *btnAskQuestion = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImageView *backgroundCellImageA=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    backgroundCellImageA.image=[UIImage imageNamed:@"Askaquestionicon.png"];
    [btnAskQuestion addSubview:backgroundCellImageA];
    btnAskQuestion.frame = CGRectMake(15.0f, 0, questionView.frame.size.width, questionView.frame.size.height);
    [btnAskQuestion setTitle:@"       Ask Question" forState:UIControlStateNormal];
    [btnAskQuestion addTarget:self action:@selector(createQuestion:) forControlEvents:UIControlEventTouchUpInside];
    btnAskQuestion.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [questionView addSubview:btnAskQuestion];
    [self.baseView addSubview:questionView];
    
    
    self.homeVc = [[SSQuestionsViewController alloc] init];
    self.currentVC = self.homeVc;
    self.navCtr = [[SSNavigationController alloc] initWithRootViewController:self.homeVc];
    self.navCtr.view.frame = CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);
    self.navCtr.container = self;
    [self.navCtr.view addObserver:self forKeyPath:@"center" options:0 context:NULL];
    
    
    [self addChildViewController:self.navCtr];
    [self.navCtr willMoveToParentViewController:self];
    [view addSubview:self.navCtr.view];
    
    [self.profile addObserver:self forKeyPath:@"groups" options:0 context:NULL];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.baseView.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
    
    [[SSWebServices sharedInstance] fetchProfileInfo:^(id result, NSError *error){
        NSDictionary *results = (NSDictionary *)result;
        NSLog(@"%@", [results description]);
        
        NSString *confirmation = [results objectForKey:@"confirmation"];
        if ([confirmation isEqualToString:@"success"]){
            NSDictionary *profileInfo = [results objectForKey:@"profile"];
            [self.profile populate:profileInfo];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.profile.populated){
        if (self.profile.confirmed)
            return;
        
        
        SSConfirmViewController *confirmVc = [[SSConfirmViewController alloc] init];
        confirmVc.mode = (self.profile.email.length > 1) ? 1 : 0;
        SSNavigationController *registerNavController = [[SSNavigationController alloc] initWithRootViewController:confirmVc];
        registerNavController.isMovable = NO;
        [self presentViewController:registerNavController
                           animated:NO
                         completion:NULL];
        return;
    }
    
    SSRegisterViewController *registerVc = [[SSRegisterViewController alloc] init];
    SSNavigationController *registerNavController = [[SSNavigationController alloc] initWithRootViewController:registerVc];
    registerNavController.isMovable = NO;
    [self presentViewController:registerNavController
                       animated:NO
                     completion:NULL];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isEqual:self.navCtr.view]){
        if ([keyPath isEqualToString:@"center"]==NO)
            return;
        
        CGPoint ctr = self.navCtr.view.center;
        
        //min=160, max=416
        CGFloat dist = ctr.x-160.0f;
        double pct = 0.10f*(dist/self.span);
        pct += 0.9f;
        if (pct > 1.0f)
            pct = 1.0f;
        
        //        NSLog(@"PERCENT: %.2f", pct);
        self.baseView.transform = CGAffineTransformMakeScale(pct, pct);
    }
    
    
    
    if ([object isEqual:self.profile]==NO)
        return;
    
    if ([keyPath isEqualToString:@"groups"]==NO)
        return;
    
    [self.sectionsTable reloadData];
    
}

- (void)logout
{
    SSRegisterViewController *registerVc = [[SSRegisterViewController alloc] init];
    SSNavigationController *registerNavController = [[SSNavigationController alloc] initWithRootViewController:registerVc];
    registerNavController.isMovable = NO;
    [self presentViewController:registerNavController
                       animated:YES
                     completion:^{
                         [self.profile clear];
                         [self.navCtr popToRootViewControllerAnimated:NO];
                     }];

}

- (void)createQuestion:(UIButton *)btn
{
    NSLog(@"createQuestion:");
    
    if (!self.createQuestionVc)
        self.createQuestionVc = [[SSCreateQuestionViewController alloc] init];
    [self slideOut:self.createQuestionVc];
}

#pragma mark - TableviewMethods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sections.count+self.profile.groups.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ID";
    SSTableCell *cell = (SSTableCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil){
        cell = [[SSTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = tableView.backgroundColor;
    }
    
    cell.indentationLevel = 0.0f;
    if (indexPath.row == 0){ // Home, Groups
        cell.textLabel.text = self.sections[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"frontPageIcon.png"];
        return cell;
    }
    
    if (indexPath.row == 1){ // Home, Groups
        cell.textLabel.text = self.sections[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"groupsIcon.png"];
        return cell;
    }
    
    
    NSUInteger groupSize = self.profile.groups.count;
    long i = indexPath.row-2;
    if (i < self.profile.groups.count){
        NSDictionary *group = self.profile.groups[i];
        cell.textLabel.text = [NSString stringWithFormat:@"@%@", group[@"displayName"]];
        cell.indentationLevel = 4.0f;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hb_bg_grey01.png"]];
        cell.imageView.image = nil;
        return cell;
    }
    
    int index = indexPath.row-groupSize;
    NSString *section = self.sections[index];
    cell.textLabel.text = section;
    
    if ([section isEqualToString:@"Results"])
        cell.imageView.image = [UIImage imageNamed:@"resultsIcon.png"];
    else if ([section isEqualToString:@"Create A New Group"])
        cell.imageView.image = [UIImage imageNamed:@"plusIcon.png"];
    else
        cell.imageView.image = nil;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 2){
        NSString *section = [self.sections objectAtIndex:indexPath.row];
        [self navigateToSection:section];
        [self performSelector:@selector(resetTable) withObject:nil afterDelay:1.0f];
        return;
    }
    
    NSUInteger groupSize = self.profile.groups.count;
    
    long i = indexPath.row-2;
    if (i < self.profile.groups.count){
        NSDictionary *group = self.profile.groups[i];
        [self navigateToGroup:group];
        [self performSelector:@selector(resetTable) withObject:nil afterDelay:1.0f];
        return;
    }
    
    
    NSString *section = [self.sections objectAtIndex:(indexPath.row-groupSize)];
    [self navigateToSection:section];
    [self performSelector:@selector(resetTable) withObject:nil afterDelay:1.0f];
}


- (void)resetTable
{
    [self.sectionsTable deselectRowAtIndexPath:[self.sectionsTable indexPathForSelectedRow] animated:NO];
    [self.sectionsTable reloadData];
}

- (void)navigateToGroup:(NSDictionary *)group
{
    NSLog(@"NAVIGATE TO GROUP: %@", group[@"displayName"]);
    
    //    if (!self.groupQuestionsVc)
    //        self.groupQuestionsVc = [[SSQuestionsViewController alloc] init];
    
    self.currentVC = nil;
    self.groupQuestionsVc = [[SSQuestionsViewController alloc] init];
    self.groupQuestionsVc.group = [NSMutableDictionary dictionaryWithDictionary:group];
    [self slideOut:self.groupQuestionsVc];
}


- (void)navigateToSection:(NSString *)section
{
    NSLog(@"Navigate to Section: %@", section);
    
    if ([section isEqualToString:@"Front Page"]){
        [self slideOut:self.homeVc];
    }
    
    if ([section isEqualToString:@"Groups"]){
        if (!self.groupsVc)
            self.groupsVc = [[SSGroupsViewController alloc] init];
        [self slideOut:self.groupsVc];
    }
    
    if ([section isEqualToString:@"Results"]){
        if (!self.resultsVc)
            self.resultsVc = [[SSResultsViewController alloc] init];
        [self slideOut:self.resultsVc];
    }
    
    
    if ([section isEqualToString:@"Create A New Group"]){
        if (!self.createGroupVc)
            self.createGroupVc = [[SSCreateGroupViewController alloc] init];
        [self slideOut:self.createGroupVc];
    }
    
}


- (void)slideOut:(SSViewController *)destinationVc
{
    if ([self.currentVC isEqual:destinationVc]){
        [self.navCtr slideIn];
        return;
    }
    
    self.currentVC = destinationVc;
    CGRect frame = self.navCtr.view.frame;
    frame.origin.x = 0.95f*frame.size.width;
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.navCtr.view.frame = frame;
                     }
                     completion:^(BOOL finished){
                         [self.navCtr popToRootViewControllerAnimated:NO];
                         
                         //make this conditional. if user is going to featured page, don't call this.
                         if (![destinationVc isEqual:self.homeVc])
                             [self.navCtr pushViewController:destinationVc animated:NO];
                         
                         [self.navCtr performSelector:@selector(slideIn)
                                           withObject:nil
                                           afterDelay:0.07f];
                     }];
}

- (void)hideMenu
{
    [UIView animateWithDuration:0.2f
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.baseView.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
                     }
                     completion:^(BOOL finisehd){
                         
                     }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
