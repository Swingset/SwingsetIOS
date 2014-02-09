//
//  SSCreateQuestionViewController.m
//  SwingSet
//
//  Created by Denny Kwon on 2/7/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.


#import "SSCreateQuestionViewController.h"
#import "UIColor+SSColor.h"
#import "AFNetworking.h"


@interface SSCreateQuestionViewController ()
@property (strong, nonatomic) UITextView *questionTextField;
@property (strong, nonatomic) UITextField *option1Field;
@property (strong, nonatomic) UITextField *option2Field;
@property (strong, nonatomic) UITextField *option3Field;
@property (strong, nonatomic) UITextField *option4Field;
@property (strong, nonatomic) SSQuestion *question;

@property (strong, nonatomic) UIImage *questionImg;
@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) NSMutableArray *uploadStrings;
@property (strong, nonatomic) UIButton *btnToggleAnswerType;
@property (nonatomic) int answerType; // 0==text, 1==pics
@end

@implementation SSCreateQuestionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.answerType = 0;
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
    base.tag = 1000;
    base.backgroundColor = [UIColor colorFromHexString:@"#f9f9f9" alpha:1.0f];
    base.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    base.layer.masksToBounds = YES;
    base.layer.cornerRadius = 3.0f;
    base.layer.borderWidth = 0.5f;
    base.layer.borderColor = [[UIColor colorWithRed:0.44f green:0.44f blue:0.44f alpha:1.0f] CGColor];
    
    CGFloat iconDimen = 100.0f;
    CGFloat y = 0.0f;
    
    UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0, y, base.frame.size.width, iconDimen)];
    top.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hb_background_green.png"]];
    [base addSubview:top];
    
    self.questionTextField = [[UITextView alloc] initWithFrame:CGRectMake(0, y, base.frame.size.width-iconDimen, iconDimen)];
    self.questionTextField.delegate = self;
    self.questionTextField.textColor = [UIColor whiteColor];
    self.questionTextField.textAlignment = NSTextAlignmentCenter;
    self.questionTextField.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.questionTextField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hb_background_green.png"]];
    self.questionTextField.font = [UIFont fontWithName:@"ProximaNova-Black" size:16.0f];
    [base addSubview:self.questionTextField];
    
    
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(base.frame.size.width-iconDimen-5.0f, 5.0f, iconDimen-10.0f, iconDimen-10.0f)];
    self.icon.userInteractionEnabled = YES;
    self.icon.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *selectIcon = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectIcon:)];
    [self.icon addGestureRecognizer:selectIcon];
    [base addSubview:self.icon];
    self.questionImg = [UIImage imageNamed:@"selectPhotoIcon.png"];
    self.icon.image = self.questionImg;

    y += iconDimen+padding-5.0f;

    CGFloat rgbMax = 255.0f;
    UIColor *purple = [UIColor colorWithRed:108.0f/rgbMax green:73.0f/rgbMax blue:142.0f/rgbMax alpha:1.0f];
    UIColor *red = [UIColor colorWithRed:249.0f/rgbMax green:48.0f/rgbMax blue:19.0f/rgbMax alpha:1.0f];
    UIColor *orange = [UIColor colorWithRed:255.0f/rgbMax green:133.0f/rgbMax blue:20.0f/rgbMax alpha:1.0f];
    UIColor *green = [UIColor colorWithRed:0.0f/rgbMax green:108.0f/rgbMax blue:128.0f/rgbMax alpha:1.0f];
    NSArray *colors = @[purple, red, orange, green];
    for (int i=0; i<4; i++) {
        UIView *optionView = [[UIView alloc] initWithFrame:CGRectMake(padding, y, base.frame.size.width-2*padding, 36.0f)];
        optionView.backgroundColor = [UIColor whiteColor];
        optionView.layer.borderColor = [[UIColor colorWithRed:0.84f green:0.84f blue:0.84f alpha:1.0f] CGColor];
        optionView.layer.cornerRadius = 6.0f;
        optionView.layer.borderWidth = 0.5f;
        optionView.layer.masksToBounds = YES;
        
        UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(0.5f, 0.5f, 9.5f, optionView.bounds.size.height-1.0f)];
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
        y += optionView.frame.size.height+padding-5.0f;
    }

    UIImage *answerTypePics = [UIImage imageNamed:@"answerTypePics"];
    self.btnToggleAnswerType = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnToggleAnswerType setTitle:@"      Use Pics for Answers" forState:UIControlStateNormal];
    self.btnToggleAnswerType.frame = CGRectMake(0.5f*(base.frame.size.width-answerTypePics.size.width), y, answerTypePics.size.width, answerTypePics.size.height);
    [self.btnToggleAnswerType setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.btnToggleAnswerType.titleLabel.textAlignment = NSTextAlignmentRight;
    self.btnToggleAnswerType.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0f];
    [self.btnToggleAnswerType addTarget:self action:@selector(toggleAnswerType:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnToggleAnswerType setBackgroundImage:answerTypePics forState:UIControlStateNormal];
    [base addSubview:self.btnToggleAnswerType];
    
    
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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btnMenu.png"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:navController
                                                                            action:@selector(toggle)];

}

- (void)setQuestionImg:(UIImage *)questionImg
{
    _questionImg = questionImg;
    
    self.icon.image = questionImg;
    
    CGFloat h = self.icon.frame.size.height;
    double scale = h/questionImg.size.height;
    
    CGFloat w = scale * questionImg.size.width;
    CGRect frame = self.icon.frame;
    frame.size.width = w;
    frame.origin.x = self.icon.superview.frame.size.width-w-5.0f;
    self.icon.frame = frame;
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    [self.questionTextField resignFirstResponder];
    [self shiftBack];
}

- (void)selectIcon:(UITapGestureRecognizer *)tap
{
    NSLog(@"selectIcon:");
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}


- (void)uploadImage:(NSString *)uploadUrl
{
    NSDictionary *imageMeta = @{@"name":@"image.jpg", @"data":UIImageJPEGRepresentation(self.questionImg, 0.5f)};
    [[SSWebServices sharedInstance] uploadImage:imageMeta toUrl:uploadUrl completionBlock:^(id result, NSError *error){
        
        if (error){
            NSLog(@"UPLOAD ERROR: %@", [error localizedDescription]);
        }
        else{
            NSDictionary *response = (NSDictionary *)result;
            NSDictionary *results = response[@"results"];
            NSString *confirmation = results[@"confirmation"];
            
            if ([confirmation isEqualToString:@"success"]){
                NSLog(@"UPLOAD SUCCESS: %@", [results description]);
                NSDictionary *image = [results objectForKey:@"image"];

                /*
                image =         {
                    address = "http://lh6.ggpht.com/KTt2Sa0tymxZn3_0Hfp4UCKgOK0jE5ykedf19lI7xSzzmIq-WTWIRV0tqSnQQ98zx8_2Q3GscLGH-KFTeyAnO43-2w";
                    id = Ya4BnHDA;
                    key = "AMIfv94x_UonItYKH0hvrnPgi4VxW9pmrX-I0Odk-BFFDDgo2BvVDf-BSqSY9OtlHZYR1u0Nns9Gf8PwBPTuSRch61_97c5oMWLZS3g__sewZ2l-akwQO4osXe3kuhg9XHyb-jZxw-O98QMmN9b-aqIQIjYa4BnHDA";
                    name = "image.jpg";
                    timestamp = "Sat Feb 08 12:57:55 UTC 2014";
                };
                 */
                
            }
            else{
                NSLog(@"UPLOAD ERROR: %@", results[@"message"]);
                
                
            }
        }
    }];
    
    
}

- (void)submitQuestion:(UIButton *)btn
{
    NSLog(@"submitQuestion:");
    
    /*
    // fetch upload url if uploading image data
    [[SSWebServices sharedInstance] fetchUploadString:2 completion:^(id result, NSError *error){
        NSDictionary *results = (NSDictionary *)result;
        NSLog(@"%@", [results description]);
        NSString *confirmation = results[@"confirmation"];
        if ([confirmation isEqualToString:@"success"]){
            
            NSArray *uploadUrls = results[@"upload urls"];
            self.uploadStrings = [NSMutableArray array];
            for (NSString *url in uploadUrls) { // strip out the base url
                [self.uploadStrings addObject:[url stringByReplacingOccurrencesOfString:@"http://swingsetlabs.appspot.com" withString:@""]];
            }
            
            if (self.uploadStrings.count > 0)
                [self uploadImage:self.uploadStrings[0]];
            
        }
        else{
            [self showAlert:@"Error" withMessage:results[@"message"]];
        }
    }];
    
     */
    
    
    if (self.question.text.length < 1){
        [self showAlert:@"Missing Question" withMessage:@"Please enter a valid question."];
        return;
    }
    
    if (!self.question.options){
        [self showAlert:@"Missing Options" withMessage:@"Please enter at least two valid options."];
        return;
    }
    
    if (self.question.options.count < 2){
        [self showAlert:@"Missing Options" withMessage:@"Please enter at least two valid options."];
        return;
    }
    
    [self.loadingIndicator startLoading];
    [[SSWebServices sharedInstance] submitQuestion:self.question completionBlock:^(id result, NSError *error){
        [self.loadingIndicator stopLoading];
        
        NSDictionary *results = (NSDictionary *)result;
        NSLog(@"%@", [results description]);
        
    }];
    
    
}

- (void)updateOptions
{
    NSMutableArray *options = [NSMutableArray array];
    for (int i=0; i<4; i++) {
        NSDictionary *entry = nil;
        if (i==0){
            if (self.option1Field.text.length > 0){
                //{"text":"1","percentage":"0.71","votes":[{"id":"30218619","sex":"m","usnerame":"Alex Vallorosi"},{"id":"61797282","sex":"m","usnerame":"Dan k"},...], "image":"none","maleVotes":"0","femaleVotes":"0"}
                
                entry = [self entryDictionaryWithQuestionText:self.option1Field.text];
            }
        }
        if (i==1){
            if (self.option2Field.text.length > 0)
                entry = [self entryDictionaryWithQuestionText:self.option2Field.text];
        }
        if (i==2)
            if (self.option3Field.text.length > 0){
                entry = [self entryDictionaryWithQuestionText:self.option3Field.text];
        }
        if (i==3){
            if (self.option4Field.text.length > 0)
                entry = [self entryDictionaryWithQuestionText:self.option4Field.text];
        }
        
        if (entry)
            [options addObject:entry];
    }
    
    self.question.options = options;
}

- (NSDictionary *)entryDictionaryWithQuestionText:(NSString *)text
{
    NSDictionary *entry = @{@"text":text, @"percentage":@"0", @"votes":@[], @"maleVotes":@"0", @"femaleVotes":@"0", @"image":@"none"};
    return entry;
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

- (void)toggleAnswerType:(UIButton *)btn
{
    if (self.answerType==0){
        UIImage *answerTypeText = [UIImage imageNamed:@"answerTypeText"];
        [self.btnToggleAnswerType setTitle:@"      Use Text for Answers" forState:UIControlStateNormal];
        [self.btnToggleAnswerType setBackgroundImage:answerTypeText forState:UIControlStateNormal];
        self.answerType = 1;
        [self rotateBase];
        return;
    }
    
    UIImage *answerTypeText = [UIImage imageNamed:@"answerTypePics"];
    [self.btnToggleAnswerType setTitle:@"      Use Pics for Answers" forState:UIControlStateNormal];
    [self.btnToggleAnswerType setBackgroundImage:answerTypeText forState:UIControlStateNormal];
    self.answerType = 0;
    [self rotateBase];
    
    
}

- (void)rotateBase
{
    UIView *base = [self.view viewWithTag:1000];
    if (!base)
        return;
    
    
    [UIView transitionWithView:base
                      duration:0.6f
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        base.alpha = 1.0f;
                    }
                    completion:^(BOOL finished){
                        
                    }];
    
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"imagePickerController: didFinishPickingMediaWithInfo: %@", [info description]);
    
    self.questionImg = info[UIImagePickerControllerEditedImage];
//    self.icon.image = self.questionImg;
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
//    NSLog(@"imagePickerControllerDidCancel:");

    [picker dismissViewControllerAnimated:YES completion:^{
        
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
//    NSLog(@"textField shouldChangeCharactersInRange:");
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
//    NSLog(@"textViewDidChange: %@", textView.text);
    if ([textView isEqual:self.questionTextField])
        self.question.text = textView.text;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
