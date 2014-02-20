//
//  SSViewController.m
//  SwingSet
//
//  Created by Denny Kwon on 1/19/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSViewController.h"

@interface SSViewController ()

@end

@implementation SSViewController
@synthesize profile;
@synthesize loadingIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.profile = [SSProfile sharedProfile];
        
        UIImage *imgLogo = [UIImage imageNamed:@"navLogo.png"];
        UIImageView *logo = [[UIImageView alloc] initWithImage:imgLogo];
        
        CGFloat w = 130.0f;
        double scale = w/imgLogo.size.width;
        logo.frame = CGRectMake(0, 0, w, scale*imgLogo.size.height);
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 44.0f)];
        logo.center = CGPointMake(0.35f*titleView.frame.size.width, 0.5f*titleView.frame.size.height);
        [titleView addSubview:logo];
        
        self.navigationItem.titleView = titleView;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.loadingIndicator = [[SSLoadingIndicator alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    self.loadingIndicator.alpha = 0.0f;
    [self.view addSubview:self.loadingIndicator];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIView *)baseView:(BOOL)navCtr
{
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    frame.origin.x = 0.0f;
    frame.origin.y = 0.0f;
    if (navCtr){
        // account for nav bar height, only necessary in iOS 7!
        frame.size.height -= 44.0f;
    }
    
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin);
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hb_background_white.png"]];
    

    return view;
}


- (void)showAlert:(NSString *)title withMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"ok"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)shiftUp
{
    NSLog(@"SHIFT UP! !");
    [self shiftUp:160.0f];
    
//    if (self.view.frame.origin.y < 0)
//        return;
//    
//    [UIView animateWithDuration:0.25f
//                          delay:0
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         CGRect frame = self.view.frame;
//                         frame.origin.y = -160.0f;
//                         self.view.frame = frame;
//                     }
//                     completion:^(BOOL finished){
//                         
//                     }];
    
}

- (void)shiftUp:(CGFloat)dist
{
    NSLog(@"SHIFT UP! !");
    if (self.view.frame.origin.y < 0)
        return;
    
    [UIView animateWithDuration:0.25f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect frame = self.view.frame;
                         frame.origin.y = -dist;
                         self.view.frame = frame;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void)shiftBack
{
    if (self.view.frame.origin.y == 0)
        return;
    
    
    [UIView animateWithDuration:0.25f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect frame = self.view.frame;
                         frame.origin.y = 0.0f;
                         self.view.frame = frame;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
}




@end
