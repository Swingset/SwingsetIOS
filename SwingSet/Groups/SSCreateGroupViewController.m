//
//  SSCreateGroupViewController.m
//  SwingSet
//
//  Created by Denny Kwon on 2/1/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSCreateGroupViewController.h"

@interface SSCreateGroupViewController ()
@property (strong, nonatomic) SSTextField *groupPWField;
@property (strong, nonatomic) SSTextField *groupNameField;
@property (strong, nonatomic) SSTextField *joinGroupNameField;
@end

@implementation SSCreateGroupViewController

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
    
    
    CGFloat h = 0.40f*frame.size.height;
    UIView *bgTop = [SSContentBackground backgroundWithFrame:CGRectMake(-5.0f, 16.0f, frame.size.width+10.0f, h)];
    bgTop.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [view addSubview:bgTop];
    
    CGFloat padding = 0.075f*h;
    CGFloat y = padding;
    UILabel *lblJoin = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, y, frame.size.width, 40.0f)];
    lblJoin.font = [UIFont fontWithName:@"ProximaNova-Bold" size:24.0f];
    lblJoin.text = @"Join An Existing Group";
    lblJoin.textAlignment = NSTextAlignmentCenter;
    lblJoin.textColor = [UIColor blackColor];
    lblJoin.backgroundColor = [UIColor clearColor];
    [bgTop addSubview:lblJoin];
    y += lblJoin.frame.size.height+padding;
    
    CGFloat w = 0.7f*frame.size.width;
    h = 36.0f;
    self.joinGroupNameField = [SSTextField textFieldWithFrame:CGRectMake(0.5f*(frame.size.width-w), y, w, h)
                                       placeholder:@"Enter Group Username"
                                          keyboard:UIKeyboardTypeAlphabet];
    
    self.joinGroupNameField.delegate = self;
    self.joinGroupNameField.text = self.profile.phone;
    [bgTop addSubview:self.joinGroupNameField];
    
    UILabel *atLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.joinGroupNameField.frame.origin.x-h-2.0f, y, h, h)];
    atLabel.text = @"@";
    atLabel.textAlignment = NSTextAlignmentRight;
    [bgTop addSubview:atLabel];
    y += h+padding;
    
    w = 0.5f*frame.size.width;
    SSButton *btnJoin = [SSButton buttonWithFrame:CGRectMake(0.5f*(frame.size.width-w), y, w, h) title:@"Join Group" textMode:TextModeUpperCase];
    btnJoin.backgroundColor = kGreenNext;
    [bgTop addSubview:btnJoin];
    
    
    
    // - - - - - - - - - - - - - - - - - - - - - - - BOTTOM - - - - - - - - - - - - - - - - - - - - - - - - - - - //
    
    
    
    y = bgTop.frame.origin.y+bgTop.frame.size.height+25.0f;
    h = 0.55f*frame.size.height;
    UIView *bgBottom = [SSContentBackground backgroundWithFrame:CGRectMake(-5.0f, y, frame.size.width+10.0f, h)];
    bgBottom.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [view addSubview:bgBottom];
    
    y = padding;
    UILabel *lblCreate = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, y, frame.size.width, 40.0f)];
    lblCreate.font = [UIFont fontWithName:@"ProximaNova-Bold" size:24.0f];
    lblCreate.text = @"Create A New Group";
    lblCreate.textAlignment = NSTextAlignmentCenter;
    lblCreate.textColor = [UIColor blackColor];
    lblCreate.backgroundColor = [UIColor clearColor];
    [bgBottom addSubview:lblCreate];
    y += lblCreate.frame.size.height+padding;
    

    
    w = 0.7f*frame.size.width;
    h = 36.0f;
    self.groupNameField = [SSTextField textFieldWithFrame:CGRectMake(0.5f*(frame.size.width-w), y, w, h)
                                                    placeholder:@"Enter New Group Username"
                                                       keyboard:UIKeyboardTypeAlphabet];
    self.groupNameField.delegate = self;
    [bgBottom addSubview:self.groupNameField];

    atLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.groupNameField.frame.origin.x-h-2.0f, y, h, h)];
    atLabel.text = @"@";
    atLabel.textAlignment = NSTextAlignmentRight;
    [bgBottom addSubview:atLabel];
    y += h+padding;

    self.groupPWField = [SSTextField textFieldWithFrame:CGRectMake(0.5f*(frame.size.width-w), y, w, h)
                                                         placeholder:@"New Group Password"
                                                            keyboard:UIKeyboardTypeAlphabet];
    self.groupPWField.delegate = self;
    [bgBottom addSubview:self.groupPWField];
    y += h+padding;
    
    w = 0.5f*frame.size.width;
    SSButton *btnInvite = [SSButton buttonWithFrame:CGRectMake(0.5f*(frame.size.width-w), y, w, h) title:@"Invite" textMode:TextModeUpperCase];
    btnInvite.backgroundColor = kGreenNext;
    [btnInvite addTarget:self action:@selector(btnInviteAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgBottom addSubview:btnInvite];

    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shiftBack)];
    [view addGestureRecognizer:tap];

    
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



- (void)shiftUp
{
    NSLog(@"SHIFT UP! !");
    if (self.view.frame.origin.y < 0)
        return;
    
    [UIView animateWithDuration:0.25f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect frame = self.view.frame;
                         frame.origin.y = -160.0f;
                         self.view.frame = frame;
                     }
                     completion:^(BOOL finished){
                         
                     }];

}

- (void)shiftBack
{
    [self.groupNameField resignFirstResponder];
    [self.groupPWField resignFirstResponder];
    [self.joinGroupNameField resignFirstResponder];
    
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

- (void)btnInviteAction:(SSButton *)btn
{
    NSLog(@"btnInviteAction:");
    [self shiftBack];
    
    if (self.groupNameField.text.length < 5 || self.groupNameField.text.length > 15){
        [self showAlert:@"Invalid Group Name" withMessage:@"Please enter a valid group name (5 to 15 characters)."];
        return;
    }
    
    if(self.groupPWField.text.length!=4){
        [self showAlert:@"Invalid PIN Number" withMessage:@"Please enter a valid pin number (4 characters)."];
        return;
    }
    
    NSDictionary *group = @{@"name":self.groupNameField.text, @"members":@[self.profile.uniqueId], @"pin":self.groupPWField.text};
    [[SSWebServices sharedInstance] createGroup:group completionBlock:^(id result, NSError *error){
        NSDictionary *results = (NSDictionary *)result;
        NSLog(@"%@", [results description]);
        
        NSString *confirmation = [results objectForKey:@"confirmation"];
        if ([confirmation isEqualToString:@"success"]) {
            //TODO: go to invite members view controller.
            
            NSDictionary *profileInfo = [results objectForKey:@"profile"];
            if (profileInfo)
                [self.profile populate:profileInfo];
            
        }
        else{
            [self showAlert:@"Error" withMessage:[results objectForKey:@"message"]];
        }
    }];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldShouldBeginEditing: %.2f", textField.frame.origin.y );
    if ([textField isEqual:self.groupPWField]==YES || [textField isEqual:self.groupNameField]==YES){
        [self shiftUp];
        
//        NSLog(@"SHIFT UP! !");
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self shiftBack];
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
