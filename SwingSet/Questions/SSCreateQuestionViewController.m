//
//  SSCreateQuestionViewController.m
//  SwingSet
//
//  Created by Denny Kwon on 2/7/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.


#import "SSCreateQuestionViewController.h"
#import "UIColor+SSColor.h"

@interface SSCreateQuestionViewController ()
@property (strong, nonatomic) UITextView *questionTextField;
@property (strong, nonatomic) UITextField *option1Field;
@property (strong, nonatomic) UITextField *option2Field;
@property (strong, nonatomic) UITextField *option3Field;
@property (strong, nonatomic) UITextField *option4Field;
@property (strong, nonatomic) SSQuestion *question;
@end

@implementation SSCreateQuestionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.edgesForExtendedLayout = UIRectEdgeAll;
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        self.question = [[SSQuestion alloc] init];
        self.question.author = self.profile.uniqueId;
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
    base.backgroundColor = [UIColor colorFromHexString:@"#f9f9f9" alpha:1.0f];
    base.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    base.layer.masksToBounds = YES;
    base.layer.cornerRadius = 3.0f;
    base.layer.borderWidth = 0.5f;
    base.layer.borderColor = [[UIColor colorWithRed:0.44f green:0.44f blue:0.44f alpha:1.0f] CGColor];
    
    CGFloat iconDimen = 100.0f;
    CGFloat y = 0.0f;
    self.questionTextField = [[UITextView alloc] initWithFrame:CGRectMake(0, y, base.frame.size.width-iconDimen, iconDimen)];
    self.questionTextField.delegate = self;
    self.questionTextField.textAlignment = NSTextAlignmentCenter;
    self.questionTextField.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.questionTextField.backgroundColor = [UIColor redColor];
    self.questionTextField.font = [UIFont fontWithName:@"ProximaNova-Black" size:16.0f];
    [base addSubview:self.questionTextField];
    
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(base.frame.size.width-iconDimen, 0.0f, iconDimen, iconDimen)];
    icon.userInteractionEnabled = YES;
    icon.backgroundColor = [UIColor blackColor];
    icon.image = [UIImage imageNamed:@"placeholder.png"];
    [base addSubview:icon];
    y += iconDimen+padding;

    
    NSArray *colors = @[[UIColor blueColor], [UIColor redColor], [UIColor greenColor], [UIColor yellowColor]];
    for (int i=0; i<4; i++) {
        UIView *optionView = [[UIView alloc] initWithFrame:CGRectMake(padding, y, base.frame.size.width-2*padding, 36.0f)];
        optionView.backgroundColor = [UIColor whiteColor];
        optionView.layer.borderColor = [[UIColor colorWithRed:0.84f green:0.84f blue:0.84f alpha:1.0f] CGColor];
        optionView.layer.cornerRadius = 6.0f;
        optionView.layer.borderWidth = 0.5f;
        optionView.layer.masksToBounds = YES;
        
        UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(1.0f, 1.0f, 9.0f, optionView.bounds.size.height-2.0f)];
        bar.backgroundColor = colors[i];
        [optionView addSubview:bar];

        if (i==0){
            self.option1Field = [[UITextField alloc] initWithFrame:CGRectMake(15.0f, 0, optionView.frame.size.width-15.0f, optionView.frame.size.height)];
            self.option1Field.delegate = self;
            [optionView addSubview:self.option1Field];
        }
        if (i==1){
            self.option2Field = [[UITextField alloc] initWithFrame:CGRectMake(15.0f, 0, optionView.frame.size.width-15.0f, optionView.frame.size.height)];
            self.option2Field.delegate = self;
            [optionView addSubview:self.option2Field];
        }
        if (i==2){
            self.option3Field = [[UITextField alloc] initWithFrame:CGRectMake(15.0f, 0, optionView.frame.size.width-15.0f, optionView.frame.size.height)];
            self.option3Field.delegate = self;
            [optionView addSubview:self.option3Field];
        }
        if (i==3){
            self.option4Field = [[UITextField alloc] initWithFrame:CGRectMake(15.0f, 0, optionView.frame.size.width-15.0f, optionView.frame.size.height)];
            self.option4Field.delegate = self;
            [optionView addSubview:self.option4Field];
        }
        
        [base addSubview:optionView];
        y += optionView.frame.size.height+padding;
    }

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [base addGestureRecognizer:tap];
    
    [view addSubview:base];
    
    
    SSButton *btnSubmit = [SSButton buttonWithFrame:CGRectMake(padding, frame.size.height-54.0f, frame.size.width-2*padding, 44.0f) title:@"Submit Question" textMode:TextModeUpperCase];
    [btnSubmit addTarget:self action:@selector(submitQuestion:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    [self.questionTextField resignFirstResponder];
    [self shiftBack];
}

- (void)submitQuestion:(UIButton *)btn
{
    NSLog(@"submitQuestion:");
}

- (void)updateOptions
{
    NSMutableArray *options = [NSMutableArray array];
    for (int i=0; i<4; i++) {
        if (i==0)
            [options addObject:self.option1Field.text];
        if (i==1)
            [options addObject:self.option2Field.text];
        if (i==3)
            [options addObject:self.option3Field.text];
        if (i==4)
            [options addObject:self.option4Field.text];
    }
    
    self.question.options = options;
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
    [self.questionTextField resignFirstResponder];
    [self.option1Field resignFirstResponder];
    [self.option2Field resignFirstResponder];
    [self.option3Field resignFirstResponder];
    [self.option4Field resignFirstResponder];
    
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


#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self shiftUp];
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
    NSLog(@"textField shouldChangeCharactersInRange:");
    [self performSelector:@selector(updateOptions) withObject:nil afterDelay:0.25f];
    return YES;
}


#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
//    NSLog(@"textViewShouldBeginEditing: %@", textView.text);
    return YES;
    
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
//    NSLog(@"textViewShouldEndEditing: %@", textView.text);
    [textView resignFirstResponder];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
//    NSLog(@"textViewDidEndEditing: %@", textView.text);
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"textViewDidChange: %@", textView.text);
    if ([textView isEqual:self.questionTextField])
        self.question.text = textView.text;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
