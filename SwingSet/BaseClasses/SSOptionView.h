//
//  SSOptionView.h
//  SwingSet
//
//  Created by Denny Kwon on 1/21/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSOptionView : UIView

@property (nonatomic, strong) UIColor *barColor;
@property (nonatomic, strong) UILabel *lblText;
+ (SSOptionView *)optionViewWithFrame:(CGRect)frame;
@end
