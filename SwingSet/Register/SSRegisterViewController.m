//
//  SSRegisterViewController.m
//  SwingSet
//
//  Created by Denny Kwon on 1/18/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSRegisterViewController.h"
#import "SSConfirmViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SSRegisterViewController ()
@property (strong, nonatomic) SSTextField *idField;
@property (strong, nonatomic) SSTextField *passcodeField;
@property (strong, nonatomic) SSTextField *nameField;
@property (strong, nonatomic) UIImageView *idConfirmation;
@property (strong, nonatomic) UIImageView *passcodeConfirmation;
@property (strong, nonatomic) UIButton *btnToggle;
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
    UIView *bg = [SSContentBackground backgroundWithFrame:CGRectMake(-5.0f, 20.0f, frame.size.width+10.0f, h)];
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
    
    NSString *instructions = @"The best way to use Swingset is to sign up with your phone number.\nWe will never abuse this.";
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
    
    UIImage *imgRedX = [UIImage imageNamed:@"redX.png"];
    self.idConfirmation = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-h-5.0f, y, h, h)];
    self.idConfirmation.image = imgRedX;
    [view addSubview:self.idConfirmation];
    y += self.idField.frame.size.height+padding;
    
    self.passcodeField = [SSTextField textFieldWithFrame:CGRectMake(0.5f*(frame.size.width-w), y, w, h)
                                             placeholder:@"Passcode"
                                                keyboard:UIKeyboardTypeDefault];
    
    self.passcodeField.delegate = self;
    self.passcodeField.secureTextEntry = YES;
    [view addSubview:self.passcodeField];
    
    self.passcodeConfirmation = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-h-5.0f, y, h, h)];
    self.passcodeConfirmation.image = imgRedX;
    [view addSubview:self.passcodeConfirmation];
    y += self.passcodeField.frame.size.height+padding;

    self.nameField = [SSTextField textFieldWithFrame:CGRectMake(0.5f*(frame.size.width-w), y, w, h)
                                         placeholder:@"Full Name"
                                            keyboard:UIKeyboardTypeDefault];
    
    self.nameField.delegate = self;
    [view addSubview:self.nameField];
    y += self.nameField.frame.size.height+padding;
    
    UILabel *lblGender = [[UILabel alloc] initWithFrame:CGRectMake(self.nameField.frame.origin.x, y, 80.0f, h)];
    lblGender.font = kBaseFont;
    lblGender.text = @"Gender";
    lblGender.textColor = [UIColor blackColor];
    [view addSubview:lblGender];
    
    CGFloat dimen = 44.0f;
    UIButton *btnMale = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnMale addTarget:self action:@selector(btnGenderAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnMale setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnMale setBackgroundColor:[UIColor yellowColor]];
    [btnMale setTitle:@"M" forState:UIControlStateNormal];
    btnMale.frame = CGRectMake(0, y, dimen, dimen);
    btnMale.center = CGPointMake(0.6f*frame.size.width, btnMale.center.y);
    [view addSubview:btnMale];

    UIButton *btnFemale = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnFemale addTarget:self action:@selector(btnGenderAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnFemale setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnFemale setBackgroundColor:[UIColor yellowColor]];
    [btnFemale setTitle:@"F" forState:UIControlStateNormal];
    btnFemale.frame = CGRectMake(0, y, dimen, dimen);
    btnFemale.center = CGPointMake(0.77f*frame.size.width, btnMale.center.y);
    [view addSubview:btnFemale];

    y += btnMale.frame.size.height+2*padding;
    
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

    [self.profile addObserver:self forKeyPath:@"phone" options:0 context:nil];
    [self.profile addObserver:self forKeyPath:@"name" options:0 context:nil];
    [self.profile addObserver:self forKeyPath:@"email" options:0 context:nil];
    [self.profile addObserver:self forKeyPath:@"pw" options:0 context:nil];
    
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

- (void)btnGenderAction:(UIButton *)btn
{
    NSString *gender = [btn titleForState:UIControlStateNormal];
    self.profile.sex = [gender lowercaseString];
    NSLog(@"btnGenderAction: %@", self.profile.sex);
}

- (void)toggleMode
{
    self.mode = (self.mode==0) ? 1 : 0;
}

- (void)btnNextAction:(UIButton *)btn
{
    if (self.mode==0){
        if (self.profile.phone.length < 10){
            [self showAlert:@"Error" withMessage:@"Please enter a valid phone number (10 digits, no dashes or parentheses)."];
            return;
        }
    }
    else{
        if ( [self isValidEmail] == NO ){
            [self showAlert:@"Error" withMessage:@"Please enter a valid email address."];
            return;
        }
    }
    
    if ( [self isValidPasscode] == NO ) {
        [self showAlert:@"Error" withMessage:@"Please enter a valid password (between 5 and 15 characters)"];
        return;
    }
    
    
    if (self.profile.name.length < 1){
        [self showAlert:@"Error" withMessage:@"Please enter a valid name."];
        return;
    }
    
    // Temporary - only here for UI setup/testing:
//    SSConfirmViewController *confirmVc = [[SSConfirmViewController alloc] init];
//    confirmVc.mode = self.mode;
//    [self.navigationController pushViewController:confirmVc animated:YES];
//    return;

    
    // TODO: show loading indicator
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



#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
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
