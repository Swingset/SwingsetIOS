//
//  SSGroupsViewController.m
//  SwingSet
//
//  Created by Denny Kwon on 1/21/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSGroupsViewController.h"

@interface SSGroupsViewController ()

@end

@implementation SSGroupsViewController

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
//    CGRect frame = view.frame;
    
//    CGFloat y = 0.0f;
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

@end
