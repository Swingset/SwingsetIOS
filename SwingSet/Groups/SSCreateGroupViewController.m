//
//  SSCreateGroupViewController.m
//  SwingSet
//
//  Created by Denny Kwon on 2/1/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSCreateGroupViewController.h"
#import "SSInviteMembersViewController.h"

@interface SSCreateGroupViewController ()
@property (strong, nonatomic) SSTextField *groupPWField;
@property (strong, nonatomic) SSTextField *groupNameField;
@property (strong, nonatomic) SSTextField *joinGroupNameField;
@property (strong, nonatomic) SSTextField *joinGroupPWField;
@property (strong, nonatomic) UIView *passwordEntryView;
@property (strong, nonatomic) UIView *darkScreen;
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
    self.joinGroupNameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    self.joinGroupNameField.delegate = self;
    [bgTop addSubview:self.joinGroupNameField];
    
    UILabel *atLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.joinGroupNameField.frame.origin.x-h-2.0f, y, h, h)];
    atLabel.text = @"@";
    atLabel.textAlignment = NSTextAlignmentRight;
    [bgTop addSubview:atLabel];
    y += h+padding;
    
    w = 0.5f*frame.size.width;
    SSButton *btnJoin = [SSButton buttonWithFrame:CGRectMake(0.5f*(frame.size.width-w), y, w, h) title:@"Join Group" textMode:TextModeUpperCase];
    [btnJoin addTarget:self action:@selector(btnJoinAction:) forControlEvents:UIControlEventTouchUpInside];
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
    self.groupNameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
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
    self.groupPWField.keyboardType = UIKeyboardTypeNumberPad;
    [bgBottom addSubview:self.groupPWField];
    y += h+padding;
    
    w = 0.5f*frame.size.width;
    SSButton *btnInvite = [SSButton buttonWithFrame:CGRectMake(0.5f*(frame.size.width-w), y, w, h) title:@"Invite" textMode:TextModeUpperCase];
    btnInvite.backgroundColor = kGreenNext;
    [btnInvite addTarget:self action:@selector(btnInviteAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgBottom addSubview:btnInvite];

    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shiftBack)];
    [view addGestureRecognizer:tap];

    
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
    
    self.joinGroupPWField = [SSTextField textFieldWithFrame:CGRectMake(10.0f, 30.0f, passwordBox.frame.size.width-20.0f, 36.0f) placeholder:@"Group Password" keyboard:UIKeyboardTypeNumberPad];
    [passwordBox addSubview:self.joinGroupPWField];
    
    [self.passwordEntryView addSubview:passwordBox];
    
    
    y = passwordBox.frame.origin.y+passwordBox.frame.size.height+20.0f;
    SSButton *btnJoinGroup = [SSButton buttonWithFrame:CGRectMake(0.5f*(frame.size.width-w), y, w, h) title:@"Join" textMode:TextModeUpperCase];
    btnJoinGroup.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [btnJoinGroup addTarget:self action:@selector(btnJoinGroupAction:) forControlEvents:UIControlEventTouchUpInside];
    btnJoinGroup.backgroundColor = kGreenNext;
    [self.passwordEntryView addSubview:btnJoinGroup];
    

    [view addSubview:self.passwordEntryView];
    
    
    
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
    [self.joinGroupPWField resignFirstResponder];
    
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
    
    [self.loadingIndicator startLoading];

    
    [[SSWebServices sharedInstance] createGroup:group completionBlock:^(id result, NSError *error){
        [self.loadingIndicator stopLoading];
        NSDictionary *results = (NSDictionary *)result;
        NSLog(@"%@", [results description]);
        
        NSString *confirmation = [results objectForKey:@"confirmation"];
        if ([confirmation isEqualToString:@"success"]) {
            
            NSDictionary *profileInfo = [results objectForKey:@"profile"];
            if (profileInfo)
                [self.profile populate:profileInfo];
            
            // go to invite members view controller.
            SSInviteMembersViewController *inviteVc = [[SSInviteMembersViewController alloc] init];
            [self.navigationController pushViewController:inviteVc animated:YES];
        }
        else{
            [self showAlert:@"Error" withMessage:[results objectForKey:@"message"]];
        }
    }];
}


- (void)btnJoinAction:(SSButton *)btn
{
    [self shiftBack];

    if (self.joinGroupNameField.text.length==0){
        [self showAlert:@"Error" withMessage:@"Please enter a group name."];
        return;
    }
    
    // show password entry
//    self.darkScreen.alpha = 0.45f;
    
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

- (void)btnJoinGroupAction:(SSButton *)btn
{
    [self.joinGroupPWField resignFirstResponder];
    if (self.joinGroupPWField.text.length==0){
        [self showAlert:@"Error" withMessage:@"Please enter the group PIN number."];
        return;
    }
    
    [UIView animateWithDuration:0.20f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         CGRect frame = self.darkScreen.frame;
                         frame.origin.x = -frame.size.width;
                         self.darkScreen.frame = frame;
                         
                         frame = self.passwordEntryView.frame;
                         frame.origin.x = frame.size.width;
                         self.passwordEntryView.frame = frame;
                     }
                     completion:^(BOOL finished){
                         self.darkScreen.alpha = 0.0f;
                         
                         CGRect frame = self.darkScreen.frame;
                         frame.origin.x = frame.size.width;
                         self.darkScreen.frame = frame;
                         
                         frame = self.passwordEntryView.frame;
                         frame.origin.x = -frame.size.width;
                         self.passwordEntryView.frame = frame;
                         
                         
                         [self performSelectorOnMainThread:@selector(joinExistingGroup) withObject:nil waitUntilDone:YES];
                         
                     }];
}

- (void)joinExistingGroup
{
    [self.loadingIndicator startLoading];
    [[SSWebServices sharedInstance] joinGroup:self.joinGroupNameField.text withPin:self.joinGroupPWField.text completionBlock:^(id result, NSError *error){
        [self.loadingIndicator stopLoading];
        
        NSDictionary *results = (NSDictionary *)result;
//        NSLog(@"%@", [results description]);
        NSString *confirmation = [results objectForKey:@"confirmation"];
        if ([confirmation isEqualToString:@"success"]){
            
            NSMutableArray *updatedGroups = [NSMutableArray arrayWithArray:self.profile.groups];
            NSDictionary *newGroup = [results objectForKey:@"group"];
            [updatedGroups addObject:newGroup];
            self.profile.groups = updatedGroups;
            
            NSString *msg = [NSString stringWithFormat:@"You are now part of the %@ group.", newGroup[@"displayName"]];
            [self showAlert:@"Success!" withMessage:msg];
        }
        else{
            [self showAlert:@"Error" withMessage:results[@"message"]];
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
