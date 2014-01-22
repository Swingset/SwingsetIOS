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
#import "SSHomeViewController.h"
#import "SSGroupsViewController.h"
#import "SSConfirmViewController.h"
#import "SSTableCell.h"


@interface SSContainerViewController ()
@property (strong, nonatomic) UITableView *sectionsTable;
@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) SSNavigationController *navCtr;
@property (strong, nonatomic) SSHomeViewController *homeVc;
@property (strong, nonatomic) SSGroupsViewController *groupsVc;
@property (strong, nonatomic) SSViewController *currentVC;
@end

@implementation SSContainerViewController

#define kSectionsIndent 200.0f

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.sections = @[@"Home", @"Groups", @"Create A New Group", @"Results"];
    }
    return self;
}

- (void)loadView
{
    UIView *view = [self baseView:NO];
    CGRect frame = view.frame;
    
    self.sectionsTable = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height+20.0f)];
    self.sectionsTable.dataSource = self;
    self.sectionsTable.delegate = self;
    self.sectionsTable.separatorStyle = UITableViewCellSelectionStyleNone;
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

    
    [view addSubview:self.sectionsTable];
    
    UIView *questionView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-footerView.frame.size.height+20.0f, self.sectionsTable.frame.size.width, footerView.frame.size.height)];
    questionView.backgroundColor = [UIColor redColor];
    [view addSubview:questionView];

    
    self.homeVc = [[SSHomeViewController alloc] init];
    self.currentVC = self.homeVc;
    self.navCtr = [[SSNavigationController alloc] initWithRootViewController:self.homeVc];
    self.navCtr.view.frame = CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);
    self.navCtr.container = self;

    [self addChildViewController:self.navCtr];
    [self.navCtr willMoveToParentViewController:self];
    [view addSubview:self.navCtr.view];
    

    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
        [self presentViewController:registerNavController
                           animated:NO
                         completion:NULL];
        return;
    }
    
    SSRegisterViewController *registerVc = [[SSRegisterViewController alloc] init];
    SSNavigationController *registerNavController = [[SSNavigationController alloc] initWithRootViewController:registerVc];
    [self presentViewController:registerNavController
                       animated:NO
                     completion:NULL];

}


#pragma mark - TableviewMethods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sections.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ID";
    SSTableCell *cell = (SSTableCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil){
        cell = [[SSTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = self.sections[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *section = [self.sections objectAtIndex:indexPath.row];
    [self navigateToSection:section];
}


#pragma mark - ContainerProtocol
- (void)childViewControllerMoved:(UIViewController *)vc distance:(CGFloat)delta
{
    CGPoint ctr = self.navCtr.view.center;
    ctr.x += delta;
    
    if (ctr.x < self.view.center.x)
        return;
    
    self.navCtr.view.center = ctr;
}

- (void)childViewControllerStopped:(UIViewController *)vc velocity:(double)vel;
{
    //    NSLog(@"childViewControllerStopped: velocity = %.2f", vel);
    if (self.navCtr.view.frame.origin.x==0)
        return;
    
    double threshold = 15.0f;
    if (vel < -threshold){
        [self slideIn];
        return;
    }
    
    if (vel > threshold){
        [self showSections];
        return;
    }
    
    (self.navCtr.view.center.x >= 0.8f*self.view.frame.size.width) ? [self showSections] : [self slideIn];
}


- (void)toggleSections
{
    (self.navCtr.view.frame.origin.x > 0) ? [self slideIn] : [self showSections];
}

- (void)slidingStopped
{
    (self.navCtr.view.frame.origin.x < 0.5*kSectionsIndent) ? [self slideIn] : [self showSections];
}



- (void)showSections
{
    CGPoint ctr = self.navCtr.view.center;
    ctr.x = 1.4f*self.view.frame.size.width;
    
    [UIView animateWithDuration:0.20f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.navCtr.view.center = ctr;
                     }
                     completion:^(BOOL finished){
                         if (finished){
                             [UIView animateWithDuration:0.20f
                                                   delay:0.06f
                                                 options:UIViewAnimationOptionCurveEaseIn
                                              animations:^{
                                                  CGPoint ctr = self.navCtr.view.center;
                                                  ctr.x = 1.3f*self.view.frame.size.width;
                                                  self.navCtr.view.center = ctr;
                                              }
                                              completion:^(BOOL finished){
                                                  self.currentVC.view.userInteractionEnabled = NO;
                                              }];
                         }
                         
                     }];
}


- (void)slideIn
{
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect frame = self.navCtr.view.frame;
                         frame.origin.x = 0.0f;
                         self.navCtr.view.frame = frame;
                     }
                     completion:^(BOOL finished){
                         
                         //bounce out:
                         [UIView animateWithDuration:0.06f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              CGRect frame = self.navCtr.view.frame;
                                              frame.origin.x = 8.0f;
                                              self.navCtr.view.frame = frame;
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.06f
                                                                    delay:0.0f
                                                                  options:UIViewAnimationOptionCurveLinear
                                                               animations:^{
                                                                   CGRect frame = self.navCtr.view.frame;
                                                                   frame.origin.x = 0.0f;
                                                                   self.navCtr.view.frame = frame;
                                                               }
                                                               completion:^(BOOL finished){
                                                                   self.currentVC.view.userInteractionEnabled = YES;
                                                                   [self.sectionsTable deselectRowAtIndexPath:[self.sectionsTable indexPathForSelectedRow] animated:NO];
                                                                   [self.sectionsTable reloadData];
                                                               }];
                                          }];
                     }];
}



- (void)navigateToSection:(NSString *)section
{
    //        self.sections = @[@"Home", @"Groups", @"Create A New Group", @"Results"];

    if ([section isEqualToString:@"Home"])
        [self slideOut:self.homeVc];
    
    if ([section isEqualToString:@"Groups"]){
        if (!self.groupsVc)
            self.groupsVc = [[SSGroupsViewController alloc] init];
        [self slideOut:self.groupsVc];
    }
    
//    if ([section isEqualToString:about]){
//        if (!self.aboutVc)
//            self.aboutVc = [[[AboutViewController alloc] initWithManager:self.butterflyMgr] autorelease];
//        [self slideOut:self.aboutVc];
//    }
//    
//    if ([section isEqualToString:tracks]){
//        if (!self.topTracksVc)
//            self.topTracksVc = [[[TopTracksViewController alloc] initWithManager:self.butterflyMgr] autorelease];
//        [self slideOut:self.topTracksVc];
//    }
    
    /*
    if ([section isEqualToString:account]){
        
        [UIView animateWithDuration:0.25f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.view.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
                         }
                         completion:^(BOOL finished){
                             
                             if (self.butterflyMgr.host.loggedIn){
                                 HostViewController *hostVC = [[HostViewController alloc] initWithManager:self.butterflyMgr];
                                 UINavigationController *acctNavCtr = [[UINavigationController alloc] initWithRootViewController:hostVC];
                                 [hostVC release];
                                 
                                 acctNavCtr.navigationBar.tintColor = [UIColor orangeColor];
                                 [self presentViewController:acctNavCtr animated:YES completion:NULL];
                                 [acctNavCtr release];
                             }
                             else{
                                 LoginViewController *login = [[LoginViewController alloc] initWithManager:self.butterflyMgr];
                                 UINavigationController *loginNavCtr = [[UINavigationController alloc] initWithRootViewController:login];
                                 loginNavCtr.navigationBar.tintColor = [UIColor orangeColor];
                                 [login release];
                                 
                                 [self presentViewController:loginNavCtr animated:YES completion:NULL];
                                 [loginNavCtr release];
                             }
                             
                         }];
    }*/
    
}


- (void)slideOut:(SSViewController *)destinationVc
{
    if ([self.currentVC isEqual:destinationVc]){
        [self slideIn];
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
                         
                         [self performSelector:@selector(slideIn)
                                    withObject:nil
                                    afterDelay:0.07f];
                     }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
