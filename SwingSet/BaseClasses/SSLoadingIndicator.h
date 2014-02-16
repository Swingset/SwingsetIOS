//
//  SSLoadingIndicator.h
//  SwingSet
//
//  Created by Denny Kwon on 1/20/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSLoadingIndicator : UIView

@property (strong, nonatomic) UILabel *lblTitle;
@property (strong, nonatomic) UILabel *lblMessage;
- (void)stopLoading;
- (void)startLoading;
@end
