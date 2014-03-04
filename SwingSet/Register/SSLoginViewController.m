//
//  SSLoginViewController.m
//  SwingSet
//
//  Created by Denny Kwon on 2/16/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSLoginViewController.h"

@interface SSLoginViewController ()
@property (strong, nonatomic) SSTextField *emailField;
@property (strong, nonatomic) SSTextField *passcodeField;
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
    
    self.emailField = [SSTextField textFieldWithFrame:CGRectMake(0.5f*(frame.size.width-w), y, w, h)
                                          placeholder:@"Email"
                                             keyboard:UIKeyboardTypeAlphabet];
    self.emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailField.delegate = self;
    [bg addSubview:self.emailField];
    y += self.emailField.frame.size.height+10.0f;

    
    self.passcodeField = [SSTextField textFieldWithFrame:CGRectMake(0.5f*(frame.size.width-w), y, w, h)
                                             placeholder:@"Password"
                                                keyboard:UIKeyboardTypeDefault];
    self.passcodeField.delegate = self;
    self.passcodeField.secureTextEntry = YES;
    self.passcodeField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passcodeField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passcodeField.returnKeyType = UIReturnKeyDone;
    [bg addSubview:self.passcodeField];
    y += self.passcodeField.frame.size.height+10.0f;
    
    UIButton *btnForgot = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnForgot setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btnForgot.frame = CGRectMake(self.passcodeField.frame.origin.x, self.passcodeField.frame.origin.y+self.passcodeField.frame.size.height+5.0f, self.passcodeField.frame.size.width, 36.0f);
    [btnForgot setTitle:@"Forgot Password?" forState:UIControlStateNormal];
    [btnForgot addTarget:self action:@selector(btnForgotAction:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:btnForgot];


    y = bg.frame.origin.y+bg.frame.size.height+10.0f;
    w = 0.5f*frame.size.width;
    CGRect tempFrame = CGRectMake(0.5f*(frame.size.width-w), y, w, 44.0f);

    SSButton *btnNext = [SSButton buttonWithFrame:tempFrame title:@"Login" textMode:TextModeUpperCase];
//    [btnNext addTarget:self action:@selector(btnNextAction:) forControlEvents:UIControlEventTouchUpInside];
    btnNext.backgroundColor = kGreenNext;
    [view addSubview:btnNext];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    self.passwordEntryView.alpha = 1.0f;
}

- (void)btnForgotAction:(UIButton *)btn
{
    NSLog(@"btnForgotAction:");
    [self.loadingIndicator startLoading];
    
    NSMutableDictionary *pkg = [NSMutableDictionary dictionary];
//    if (self.phoneField.text.length > 0){     //defer to phone first
//        pkg[@"type"] = @"phone";
//        
//        // format the phone number (remove hyphens, dashes, etc):
//        NSString *formattedNumber = @"";
//        static NSString *numbers = @"0123456789";
//        NSString *ph = self.phoneField.text;
//        for (int i=0; i<ph.length; i++) {
//            NSString *character = [ph substringWithRange:NSMakeRange(i, 1)];
//            if ([numbers rangeOfString:character].location!=NSNotFound)
//                formattedNumber = [formattedNumber stringByAppendingString:character];
//        }
//        pkg[@"phone"] = formattedNumber;
//    }
//    else{
//        pkg[@"type"] = @"email";
//        pkg[@"email"] = self.emailField.text;
//    }

    
    pkg[@"type"] = @"email";
    pkg[@"email"] = self.emailField.text;

    
    [[SSWebServices sharedInstance] forgotPassword:pkg completionBlock:^(id result, NSError *error){
        [self.loadingIndicator stopLoading];
        
        if (error){
            [self showAlert:@"Error" withMessage:[error localizedDescription]];
        }
        else{
            NSDictionary *results = (NSDictionary *)result;
            NSLog(@"%@", [results description]);
            NSString *confirmation = results[@"confirmation"];
            if ([confirmation isEqualToString:@"success"]){
                
                [self showAlert:@"Password Reset" withMessage:@"A new password was assigned to your profile and sent to you via text or email. Please try logging in again with the new password."];
            }
            else{ // incorrect PIN or user not found:
                [self showAlert:@"Error" withMessage:results[@"message"]];
            }
        }
    }];
    

    
}


- (void)goBack:(UIBarButtonItem *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)btnLoginAction:(UIButton *)btn
{
    NSLog(@"btnLoginAction:");
    
    if(self.passcodeField.text.length==0){
        [self showAlert:@"Missing PIN Number" withMessage:@"Please enter a PIN number."];
        return;
    }
    
    [self.loadingIndicator startLoading];
    
    NSMutableDictionary *pkg = [NSMutableDictionary dictionary];
//    if (self.phoneField.text.length > 0){     //defer to phone first
//        pkg[@"type"] = @"phone";
//        
//        // format the phone number (remove hyphens, dashes, etc):
//        NSString *formattedNumber = @"";
//        static NSString *numbers = @"0123456789";
//        NSString *ph = self.phoneField.text;
//        for (int i=0; i<ph.length; i++) {
//            NSString *character = [ph substringWithRange:NSMakeRange(i, 1)];
//            if ([numbers rangeOfString:character].location!=NSNotFound)
//                formattedNumber = [formattedNumber stringByAppendingString:character];
//        }
//        pkg[@"phone"] = formattedNumber;
//    }
//    else{
//        pkg[@"type"] = @"email";
//        pkg[@"email"] = self.emailField.text;
//    }
    
    pkg[@"type"] = @"email";
    pkg[@"email"] = self.emailField.text;
    pkg[@"pin"] = self.passcodeField.text;

    
    [[SSWebServices sharedInstance] login:pkg completionBlock:^(id result, NSError *error){
        [self.loadingIndicator stopLoading];
        
        if (error){
            [self showAlert:@"Error" withMessage:[error localizedDescription]];
        }
        else{
            NSDictionary *results = (NSDictionary *)result;
            NSLog(@"%@", [results description]);
            NSString *confirmation = results[@"confirmation"];
            if ([confirmation isEqualToString:@"success"]){
                NSDictionary *profileInfo = [results objectForKey:@"profile"];
                [self.profile populate:profileInfo];
                [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
            }
            else{ // incorrect PIN or user not found:
                [self showAlert:@"Error" withMessage:results[@"message"]];
            }
        }
    }];
    
}




#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.passcodeField]){
        [self btnLoginAction:nil];
    }
    
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
//    for (UITextField *textField in @[self.emailField, self.phoneField, self.passcodeField])
    for (UITextField *textField in @[self.emailField, self.passcodeField])
        [textField resignFirstResponder];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded:");
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
