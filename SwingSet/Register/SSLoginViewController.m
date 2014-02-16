//
//  SSLoginViewController.m
//  SwingSet
//
//  Created by Denny Kwon on 2/16/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSLoginViewController.h"

@interface SSLoginViewController ()
@property (strong, nonatomic) SSTextField *phoneField;
@property (strong, nonatomic) SSTextField *emailField;
@property (strong, nonatomic) SSTextField *passcodeField;
@property (strong, nonatomic) UIView *passwordEntryView;
@property (strong, nonatomic) UIView *darkScreen;
@end

@implementation SSLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)loadView
{
    UIView *view = [self baseView:YES];
    CGRect frame = view.frame;
    
    
    CGFloat h = 0.75f*frame.size.height;
    UIView *bg = [SSContentBackground backgroundWithFrame:CGRectMake(-5.0f, 20.0f, frame.size.width+10.0f, h-20.0f)];
    bg.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [view addSubview:bg];

    
    CGFloat y = 5.0f;
    UILabel *lblLogin = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, y, frame.size.width, 40.0f)];
    lblLogin.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    lblLogin.font = [UIFont fontWithName:@"ProximaNova-Bold" size:24.0f];
    lblLogin.text = @"Log In";
    lblLogin.textAlignment = NSTextAlignmentCenter;
    lblLogin.textColor = [UIColor blackColor];
    lblLogin.backgroundColor = [UIColor clearColor];
    [bg addSubview:lblLogin];
    y += lblLogin.frame.size.height+5.0f;

    
    CGFloat w = 0.7f*frame.size.width;
    h = 36.0f;
    self.phoneField = [SSTextField textFieldWithFrame:CGRectMake(0.5f*(frame.size.width-w), y, w, h)
                                        placeholder:@"Phone Number"
                                           keyboard:UIKeyboardTypePhonePad];

    self.phoneField.delegate = self;
    [bg addSubview:self.phoneField];
    y += self.phoneField.frame.size.height;

    UILabel *lblOr = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, y, frame.size.width, 40.0f)];
    lblOr.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    lblOr.font = [UIFont fontWithName:@"ProximaNova-RegularIt" size:20.0f];
    lblOr.text = @"OR";
    lblOr.textAlignment = NSTextAlignmentCenter;
    lblOr.textColor = [UIColor blackColor];
    lblOr.backgroundColor = [UIColor clearColor];
    [bg addSubview:lblOr];
    y += lblOr.frame.size.height;
    
    self.emailField = [SSTextField textFieldWithFrame:CGRectMake(0.5f*(frame.size.width-w), y, w, h)
                                          placeholder:@"Email"
                                             keyboard:UIKeyboardTypeAlphabet];
    
    self.emailField.delegate = self;
    [bg addSubview:self.emailField];


    y = bg.frame.origin.y+bg.frame.size.height+10.0f;
    w = 0.5f*frame.size.width;
    CGRect tempFrame = CGRectMake(0.5f*(frame.size.width-w), y, w, 44.0f);

    SSButton *btnNext = [SSButton buttonWithFrame:tempFrame title:@"Next" textMode:TextModeUpperCase];
    [btnNext addTarget:self action:@selector(btnNextAction:) forControlEvents:UIControlEventTouchUpInside];
    btnNext.backgroundColor = kGreenNext;
    [view addSubview:btnNext];
    
    
    self.darkScreen = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height)];
    self.darkScreen.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin);
    self.darkScreen.backgroundColor = [UIColor blackColor];
    self.darkScreen.alpha = 0.0f;
    [view addSubview:self.darkScreen];
    
    
    self.passwordEntryView = [[UIView alloc] initWithFrame:CGRectMake(-frame.size.width, 0, frame.size.width, frame.size.height)];
    self.passwordEntryView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin);
    self.passwordEntryView.backgroundColor = [UIColor clearColor];
    w = 0.70f*frame.size.width;
    UIView *passwordBox = [[UIView alloc] initWithFrame:CGRectMake(0.5f*(frame.size.width-w), 80.0f, w, 120.0f)];
    passwordBox.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    passwordBox.backgroundColor = kGrayTable;
    passwordBox.layer.cornerRadius = 4.0f;
    passwordBox.layer.masksToBounds = YES;
    
    
    self.passcodeField = [SSTextField textFieldWithFrame:CGRectMake(10.0f, 30.0f, passwordBox.frame.size.width-20.0f, 36.0f) placeholder:@"PIN Number" keyboard:UIKeyboardTypeNumberPad];
    [passwordBox addSubview:self.passcodeField];
    [self.passwordEntryView addSubview:passwordBox];


    y = passwordBox.frame.origin.y+passwordBox.frame.size.height+20.0f;
    SSButton *btnLogin = [SSButton buttonWithFrame:CGRectMake(0.5f*(frame.size.width-w), y, w, h) title:@"Log In" textMode:TextModeUpperCase];
    btnLogin.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [btnLogin addTarget:self action:@selector(btnLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    btnLogin.backgroundColor = kGreenNext;
    [self.passwordEntryView addSubview:btnLogin];
    [view addSubview:self.passwordEntryView];

    
    
    
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self.navigationController action:@selector(popViewControllerAnimated:)];

}

- (void)btnNextAction:(UIButton *)btn
{
    
    [UIView animateWithDuration:0.20f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.darkScreen.alpha = 0.45f;
                         
                         CGRect frame = self.darkScreen.frame;
                         frame.origin.x = -10.0f;
                         self.darkScreen.frame = frame;
                         
                         frame = self.passwordEntryView.frame;
                         frame.origin.x = 10.0f;
                         self.passwordEntryView.frame = frame;
                     }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.14f
                                               delay:0.06f
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              CGRect frame = self.darkScreen.frame;
                                              frame.origin.x = 0.0f;
                                              self.darkScreen.frame = frame;
                                              
                                              self.passwordEntryView.frame = frame;
                                              
                                          }
                                          completion:^(BOOL finished){
                                              
                                              
                                          }];
                         
                         
                     }];
}


- (void)btnLoginAction:(UIButton *)btn
{
    NSLog(@"btnLoginAction:");
    
    
    
    
    
    
}

- (void)shiftUp
{
    if (self.view.frame.origin.y < 0)
        return;
    
    [UIView animateWithDuration:0.25f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect frame = self.view.frame;
                         frame.origin.y = -100.0f;
                         self.view.frame = frame;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
}

- (void)shiftBack
{
    [self.emailField resignFirstResponder];
    [self.phoneField resignFirstResponder];
    [self.passcodeField resignFirstResponder];
    
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



#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldShouldBeginEditing: %.2f", textField.frame.origin.y );
    if ([textField isEqual:self.passcodeField]==YES){
//        [self shiftUp];
    }
    return YES;
}





#pragma mark - UIResponder
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan:");
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesMoved:");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded:");
    for (UITextField *textField in @[self.emailField, self.phoneField])
        [textField resignFirstResponder];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self shiftBack];
    NSLog(@"touchesEnded:");
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
