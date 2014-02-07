//
//  SSCreateQuestionViewController.m
//  SwingSet
//
//  Created by Denny Kwon on 2/7/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSCreateQuestionViewController.h"

@interface SSCreateQuestionViewController ()

@end

@implementation SSCreateQuestionViewController

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
    view.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin);
    
    CGFloat padding = 15.0f;

    UIView *base = [[UIView alloc] initWithFrame:CGRectMake(padding, padding, frame.size.width-2*padding, frame.size.height-2*padding-54.0f)];
//    base.backgroundColor = [self getUIColorObjectFromHexString:@"#f9f9f9" alpha:1];
    base.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    base.backgroundColor = [UIColor lightGrayColor];
    base.layer.masksToBounds = YES;
    base.layer.cornerRadius = 3.0f;
    base.layer.borderWidth = 0.5f;
    base.layer.borderColor = [[UIColor colorWithRed:0.44f green:0.44f blue:0.44f alpha:1] CGColor];
    
    [view addSubview:base];
    
    
    SSButton *btnSubmit = [SSButton buttonWithFrame:CGRectMake(padding, frame.size.height-54.0f, frame.size.width-2*padding, 44.0f) title:@"Submit Question" textMode:TextModeUpperCase];
    btnSubmit.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    btnSubmit.backgroundColor = kGreenNext;
    [view addSubview:btnSubmit];
    
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

@end
