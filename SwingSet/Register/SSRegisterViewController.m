//
//  SSRegisterViewController.m
//  SwingSet
//
//  Created by Denny Kwon on 1/18/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSRegisterViewController.h"
#import "SSConfirmViewController.h"
#import "SSLoginViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SSRegisterViewController ()
@property (strong, nonatomic) SSTextField *idField;
@property (strong, nonatomic) SSTextField *passcodeField;
@property (strong, nonatomic) SSTextField *nameField;
@property (strong, nonatomic) UIImageView *idConfirmation;
@property (strong, nonatomic) UIImageView *passcodeConfirmation;
@property (strong, nonatomic) UIButton *btnToggle;
@property (strong, nonatomic) UIButton *btnMale;
@property (strong, nonatomic) UIButton *btnFemale;
@property (nonatomic) int mode; //0=phone, 1=email
@end

@implementation SSRegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mode = 0;
        
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
    
    CGFloat y = 25.0f;
    UILabel *lblSignup = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, y, frame.size.width, 40.0f)];
    lblSignup.font = [UIFont fontWithName:@"ProximaNova-Bold" size:24.0f];
    lblSignup.text = @"Sign Up";
    lblSignup.textAlignment = NSTextAlignmentCenter;
    lblSignup.textColor = [UIColor blackColor];
    lblSignup.backgroundColor = [UIColor clearColor];
    [view addSubview:lblSignup];
    y += lblSignup.frame.size.height;
    
    NSString *instructions = @"Sign up with your phone number to connect with friends.";
    UILabel *lblInstructions = [[UILabel alloc] initWithFrame:CGRectZero];
    lblInstructions.font = kBaseFont;
    lblInstructions.textColor = [UIColor blackColor];
    lblInstructions.backgroundColor = [UIColor clearColor];
    lblInstructions.textAlignment = NSTextAlignmentCenter;
    lblInstructions.lineBreakMode = NSLineBreakByWordWrapping;
    lblInstructions.numberOfLines = 0;
    lblInstructions.text = instructions;
    CGFloat w = 0.9f*frame.size.width;
    CGSize expectedSize = [lblInstructions sizeThatFits:CGSizeMake(w, 300.0f)];
    lblInstructions.frame = CGRectMake(0.5f*(frame.size.width-w), y, w, expectedSize.height);
    [view addSubview:lblInstructions];
    CGFloat padding = 10.0f;
    y += lblInstructions.frame.size.height+2*padding;
    
    w = 0.7f*frame.size.width;
    h = 36.0f;
    self.idField = [SSTextField textFieldWithFrame:CGRectMake(0.5f*(frame.size.width-w), y, w, h)
                                       placeholder:@"Phone Number"
                                          keyboard:UIKeyboardTypePhonePad];
    
    self.idField.delegate = self;
    self.idField.text = self.profile.phone;
    [view addSubview:self.idField];
    
    self.idConfirmation = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-h+3.0f, y+7.0f, h/2, h/2)];
    [view addSubview:self.idConfirmation];
    y += self.idField.frame.size.height+padding;
    
    self.passcodeField = [SSTextField textFieldWithFrame:CGRectMake(0.5f*(frame.size.width-w), y, w, h)
                                             placeholder:@"Password"
                                                keyboard:UIKeyboardTypeDefault];
    
    self.passcodeField.delegate = self;
    self.passcodeField.secureTextEntry = YES;
    [view addSubview:self.passcodeField];
    
    self.passcodeConfirmation = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-h+3.0f, y+7.0f, h/2, h/2)];
    [view addSubview:self.passcodeConfirmation];
    y += self.passcodeField.frame.size.height+padding;
    
    self.nameField = [SSTextField textFieldWithFrame:CGRectMake(0.5f*(frame.size.width-w), y, w, h)
                                         placeholder:@"Full Name"
                                            keyboard:UIKeyboardTypeDefault];
    
    self.nameField.delegate = self;
    [view addSubview:self.nameField];
    y += self.nameField.frame.size.height+padding;
    
    UILabel *lblMale = [[UILabel alloc] initWithFrame:CGRectMake(self.nameField.frame.origin.x, y+5.0f, 40.0f, h)];
    
    lblMale.font = kBaseFont;
    lblMale.text = @"Male";
    lblMale.backgroundColor = [UIColor clearColor];
    lblMale.textColor = [UIColor blackColor];
    [view addSubview:lblMale];
    
    CGFloat dimen = 44.0f;
    self.btnMale = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnMale addTarget:self action:@selector(btnMaleAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnMale setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btnMale setBackgroundColor:[UIColor clearColor]];
    self.btnMale.frame = CGRectMake(0, y, dimen, dimen);
    self.btnMale.center = CGPointMake(self.nameField.frame.origin.x+75.0f, self.btnMale.center.y);
    [self.btnMale setBackgroundImage:[UIImage imageNamed:@"uncheckedBox.png"] forState:UIControlStateNormal];
    [self.btnMale setBackgroundImage:[UIImage imageNamed:@"uncheckedBox.png"] forState:UIControlStateHighlighted];
    [view addSubview:self.btnMale];
    
    
    
    
    UILabel *lblFemale = [[UILabel alloc] initWithFrame:CGRectMake(0.5f*frame.size.width+10.0f, y+5.0f, 60.0f, h)];
    lblFemale.font = kBaseFont;
    lblFemale.text = @"Female";
    lblFemale.backgroundColor = [UIColor clearColor];
    lblFemale.textColor = [UIColor blackColor];
    [view addSubview:lblFemale];
    
    self.btnFemale = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnFemale addTarget:self action:@selector(btnFemaleAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnFemale setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btnFemale setBackgroundColor:[UIColor clearColor]];
    self.btnFemale.frame = CGRectMake(0, y, dimen, dimen);
    self.btnFemale.center = CGPointMake(0.77f*frame.size.width+10.0f, self.btnMale.center.y);
    [self.btnFemale setBackgroundImage:[UIImage imageNamed:@"uncheckedBox.png"] forState:UIControlStateNormal];
    [self.btnFemale setBackgroundImage:[UIImage imageNamed:@"uncheckedBox.png"] forState:UIControlStateHighlighted];
    [view addSubview:self.btnFemale];
    
    y += self.btnMale.frame.size.height+2*padding;
    
    UIImage *imgNext = [UIImage imageNamed:@"NextButton.png"];
    CGRect tempFrame = CGRectMake(0.5f*(frame.size.width-imgNext.size.width), y, imgNext.size.width, 0.70*imgNext.size.height);
    
    SSButton *btnNext = [SSButton buttonWithFrame:tempFrame title:@"Next" textMode:TextModeUpperCase];
    [btnNext addTarget:self action:@selector(btnNextAction:) forControlEvents:UIControlEventTouchUpInside];
    btnNext.backgroundColor = kGreenNext;
    
    [view addSubview:btnNext];
    y += btnNext.frame.size.height+padding;
    
    
    w = 0.8f*frame.size.width;
    self.btnToggle = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnToggle.titleLabel.font = kBaseFont;
    [self.btnToggle addTarget:self action:@selector(toggleMode) forControlEvents:UIControlEventTouchUpInside];
    [self.btnToggle setBackgroundColor:[UIColor clearColor]];
    [self.btnToggle setTitleColor:kGreenNext forState:UIControlStateNormal];
    [self.btnToggle setTitle:@"Or signup with email" forState:UIControlStateNormal];
    h = 44.0f;
    self.btnToggle.frame = CGRectMake(0.5f*(frame.size.width-w), frame.size.height-h, w, h);
    [view addSubview:self.btnToggle];
    
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleBordered target:self action:@selector(showLogin)];

    [self.profile addObserver:self forKeyPath:@"phone" options:0 context:nil];
    [self.profile addObserver:self forKeyPath:@"name" options:0 context:nil];
    [self.profile addObserver:self forKeyPath:@"email" options:0 context:nil];
    [self.profile addObserver:self forKeyPath:@"pw" options:0 context:nil];
    
}

- (void)dealloc {
    
    [self.profile removeObserver:self forKeyPath:@"phone"];
    [self.profile removeObserver:self forKeyPath:@"name"];
    [self.profile removeObserver:self forKeyPath:@"email"];
    [self.profile removeObserver:self forKeyPath:@"pw"];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![object isEqual:self.profile])
        return;
    
    if ([keyPath isEqualToString:@"phone"]){
        if (self.profile.phone.length >= 10)
            self.idConfirmation.image = [UIImage imageNamed:@"greencheck.png"];
        else
            self.idConfirmation.image = [UIImage imageNamed:@"redX.png"];
    }
    
    if ([keyPath isEqualToString:@"email"]){
        if ( [self isValidEmail] == YES )
            self.idConfirmation.image = [UIImage imageNamed:@"greencheck.png"];
        else
            self.idConfirmation.image = [UIImage imageNamed:@"redX.png"];
    }
    
    if ([keyPath isEqualToString:@"pw"]){
        if ( [self isValidPasscode] == YES )
            self.passcodeConfirmation.image = [UIImage imageNamed:@"greencheck.png"];
        else
            self.passcodeConfirmation.image = [UIImage imageNamed:@"redX.png"];
    }
}

- (void)setMode:(int)mode
{
    _mode = mode;
    if (_mode==0){
        self.idField.placeholder = @"Phone Number";
        [self.btnToggle setTitle:@"Or signup with email" forState:UIControlStateNormal];
        self.idField.text = self.profile.phone;
        self.idField.keyboardType = UIKeyboardTypePhonePad;
    }
    else{
        self.idField.placeholder = @"Email";
        [self.btnToggle setTitle:@"Or signup with phone number" forState:UIControlStateNormal];
        self.idField.text = self.profile.email;
        self.idField.keyboardType = UIKeyboardTypeDefault;
    }
    
    [UIView transitionWithView:self.view
                      duration:0.65f
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        self.view.alpha = 1.0f;
                    }
                    completion:^(BOOL finisehd){
                        
                    }];
}

- (void)showLogin
{
    SSLoginViewController *loginVc = [[SSLoginViewController alloc] init];
    [self.navigationController pushViewController:loginVc animated:YES];
}

- (void)btnMaleAction:(UIButton *)btn
{
    //NSString *gender = [btn titleForState:UIControlStateNormal];
    self.profile.sex = [@"M" lowercaseString];
    NSLog(@"btnGenderAction: %@", self.profile.sex);
    [self.btnMale setBackgroundImage:[UIImage imageNamed:@"checkedBoxRegister.png"] forState:UIControlStateNormal];
    [self.btnMale setBackgroundImage:[UIImage imageNamed:@"checkedBoxRegister.png"] forState:UIControlStateSelected];
    [self.btnFemale setBackgroundImage:[UIImage imageNamed:@"uncheckedBox.png"] forState:UIControlStateNormal];
    [self.btnFemale setBackgroundImage:[UIImage imageNamed:@"uncheckedBox.png"] forState:UIControlStateSelected];
    
}
- (void)btnFemaleAction:(UIButton *)btn
{
    //NSString *gender = [btn titleForState:UIControlStateNormal];
    self.profile.sex = [@"F" lowercaseString];
    NSLog(@"btnGenderAction: %@", self.profile.sex);
    [self.btnFemale setBackgroundImage:[UIImage imageNamed:@"checkedBoxRegister.png"] forState:UIControlStateNormal];
    [self.btnFemale setBackgroundImage:[UIImage imageNamed:@"checkedBoxRegister.png"] forState:UIControlStateSelected];
    [self.btnMale setBackgroundImage:[UIImage imageNamed:@"uncheckedBox.png"] forState:UIControlStateNormal];
    [self.btnMale setBackgroundImage:[UIImage imageNamed:@"uncheckedBox.png"] forState:UIControlStateSelected];
}

- (void)toggleMode
{
    self.mode = (self.mode==0) ? 1 : 0;
}

- (void)btnNextAction:(UIButton *)btn
{
    if (self.profile.sex.length < 1){
        [self showAlert:@"Missing Gender" withMessage:@"Please select a gender."];
        return;
    }
    
    if (self.mode==0){
        if (self.profile.phone.length < 10){
            [self showAlert:@"Phone Number Error" withMessage:@"The Swingset robot can't read your number. Please type it in like: 9171234567"];
            return;
        }
    }
    else{
        if ( [self isValidEmail] == NO ){
            [self showAlert:@"Email Error" withMessage:@"Please enter your email address"];
            return;
        }
    }
    
    if ( [self isValidPasscode] == NO ) {
        [self showAlert:@"Password Error" withMessage:@"Please enter a password between 5 and 15 characters"];
        return;
    }
    
    
    if (self.profile.name.length < 1){
        [self showAlert:@"Full Name Error" withMessage:@"I think you forgot to enter your full name :)"];
        return;
    }
    
    
    [self.loadingIndicator startLoading];
    [[SSWebServices sharedInstance] registerProfile:self.profile
                                    completionBlock:^(id result, NSError *error){
                                        [self.loadingIndicator stopLoading];
                                        if (error){
                                            NSLog(@"COMPLETION: %@", [error localizedDescription]);
                                        }
                                        else{
                                            NSDictionary *results = (NSDictionary *)result;
                                            NSLog(@"COMPLETION: %@", [results description]);
                                            NSString *confirmation = [results objectForKey:@"confirmation"];
                                            if ([confirmation isEqualToString:@"success"]){
                                                NSDictionary *profileInfo = [results objectForKey:@"profile"];
                                                [self.profile populate:profileInfo];
                                                
                                                SSConfirmViewController *confirmVc = [[SSConfirmViewController alloc] init];
                                                confirmVc.mode = self.mode;
                                                [self.navigationController pushViewController:confirmVc animated:YES];
                                            }
                                            else{
                                                [self showAlert:@"Error" withMessage:[results objectForKey:@"message"]];
                                            }
                                        }
                                        
                                    }];
    
}

- (void)updateProfile
{
    if (self.mode==0)
        self.profile.phone = self.idField.text;
    else
        self.profile.email = self.idField.text;
    
    self.profile.name = self.nameField.text;
    self.profile.pw = self.passcodeField.text;
}

- (void)shiftBack
{
    NSLog(@"SHIFT BACK: %.2f", self.view.frame.origin.y);
    if (self.view.frame.origin.y == 0)
        return;
    
    
    [UIView animateWithDuration:0.25f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect frame = self.view.frame;
                         frame.origin.y = 64.0f;
                         self.view.frame = frame;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self shiftUp:40.0f];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self shiftBack];
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self performSelector:@selector(updateProfile) withObject:nil afterDelay:0.01f];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
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
    [self shiftBack];
    for (UITextField *textField in @[self.idField, self.nameField, self.passcodeField])
        [textField resignFirstResponder];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded:");
    
}

#pragma mark  - Field Validation
- (BOOL)isValidEmail
{
    NSString *lastFour;
    NSRange  tempRange;
    
    if ( self.profile.email.length < 4 )
    {
        return NO;
    }
    
    // check if string contains "@" symbol
    
    tempRange = [self.profile.email rangeOfString:@"@"];
    
    if ( tempRange.location == NSNotFound )
    {
        return NO;
    }
    
    // check last four characters, to see if period exists:
    NSUInteger startPoint = self.profile.email.length - 4;
    lastFour = [self.profile.email substringWithRange:NSMakeRange(startPoint, 4)];
    
    tempRange = [lastFour rangeOfString:@"."];
    
    if ( tempRange.location == NSNotFound )
    {
        return NO;
    }
    
    return YES;
    
}

- (BOOL)isValidPasscode
{
    if ( self.passcodeField.text.length > 15 ||
        self.passcodeField.text.length < 5 )
    {
        return NO;
    }
    
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
