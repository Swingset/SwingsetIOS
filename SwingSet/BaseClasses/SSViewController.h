//
//  SSViewController.h
//  SwingSet
//
//  Created by Denny Kwon on 1/19/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "SSProfile.h"
#import "SSQuestion.h"
#import "SSWebServices.h"
#import "SSTextField.h"
#import "SSContentBackground.h"
#import "SSLoadingIndicator.h"
#import "SSButton.h"
#import "SSQuestionView.h"


@interface SSViewController : UIViewController

@property (strong, nonatomic) SSProfile *profile;
@property (strong, nonatomic) SSLoadingIndicator *loadingIndicator;
- (UIView *)baseView:(BOOL)navCtr;
- (void)showAlert:(NSString *)title withMessage:(NSString *)message;
@end
