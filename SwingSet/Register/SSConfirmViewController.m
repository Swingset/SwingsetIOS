//
//  SSConfirmViewController.m
//  SwingSet
//
//  Created by Denny Kwon on 1/19/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSConfirmViewController.h"

@interface SSConfirmViewController ()
@property (strong, nonatomic) SSTextField *pinField;
@end

@implementation SSConfirmViewController
@synthesize mode;

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
    
    CGFloat h = 0.55f*frame.size.height;
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
    
    NSString *instructions = (self.mode==0) ? @"We just texted you a 4-digit code. Enter it below and we're done." : @"We just emailed you a 4-digit code. Enter it below and we're done.";
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
    self.pinField = [SSTextField textFieldWithFrame:CGRectMake(0.5f*(frame.size.width-w), y, w, h)
                                       placeholder:@"4-Digit Password"
                                          keyboard:UIKeyboardTypePhonePad];
    
    self.pinField.delegate = self;
    [view addSubview:self.pinField];
    y += self.pinField.frame.size.height+2*padding;

    
    UIImage *imgNext = [UIImage imageNamed:@"NextButton.png"];
    SSButton *btnNext = [SSButton buttonWithFrame:CGRectMake(0.5f*(frame.size.width-imgNext.size.width), y, imgNext.size.width, 0.70*imgNext.size.height) title:@"All Done!" textMode:TextModeUpperCase];
    btnNext.backgroundColor = kGreenNext;
    [btnNext addTarget:self action:@selector(btnSubmitAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnNext];

    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Restart" style:UIBarButtonItemStyleBordered target:self action:@selector(startOver:)];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationItem.hidesBackButton = YES;
}

- (void)startOver:(UIBarButtonItem *)btn
{
    NSLog(@"startOver:");
    [self.profile clear];
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)btnSubmitAction:(UIButton *)btn
{
    NSLog(@"btnSubmitAction:");
    [self.pinField resignFirstResponder];

    if (self.pinField.text.length != 4){
        [self showAlert:@"Error" withMessage:@"Please enter a valid 4-digit pin number."];
        return;
    }
    
    [[SSWebServices sharedInstance] confirmPIN:@{@"pin":self.pinField.text, @"profile":self.profile.uniqueId} completionBlock:^(id result, NSError *error){
        if (error){
            [self showAlert:@"Error" withMessage:[error localizedDescription]];
        }
        else{
            NSDictionary *results = (NSDictionary *)result;
            NSLog(@"%@", [results description]);
            NSString *confirmation = [results objectForKey:@"confirmation"];
            if ([confirmation isEqualToString:@"success"]){
                NSDictionary *profileInfo = [results objectForKey:@"profile"];
                [self.profile populate:profileInfo];
//                self.profile.confirmed = [[profileInfo objectForKey:@"confirmed"] isEqualToString:@"yes"];
                if (self.profile.confirmed){
                    NSLog(@"PROFILE CONFIRMED");
                    
                    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
                }
                else{
                    [self showAlert:@"Error" withMessage:@"The PIN number does not match. Please try again."];
                }
                
            }
            else{
                [self showAlert:@"Error" withMessage:[results objectForKey:@"message"]];
            }
        }
        
        
    }];
    
}



#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self shiftUp:40.0f];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self shiftBack];
    return YES;
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
    [self.pinField resignFirstResponder];
    
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
