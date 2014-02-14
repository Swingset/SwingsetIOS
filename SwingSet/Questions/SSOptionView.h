//
//  SSOptionView.h
//  SwingSet
//
//  Created by Denny Kwon on 1/21/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSOptionViewDelegate
- (void)optionViewSelected:(NSInteger)tag;
@end

@interface SSOptionView : UIView

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *percentBar;
@property (nonatomic, strong) UIColor *barColor;
@property (nonatomic, strong) UILabel *lblText;
@property (nonatomic, strong) UIImageView *badge;
@property (nonatomic, strong) UILabel *lblPercentage;
@property (nonatomic) BOOL isHilighted;
@property (assign) id parent;
+ (SSOptionView *)optionViewWithFrame:(CGRect)frame;
- (void)showPercentage:(double)pct;
- (void)showPercentage:(double)pct animated:(BOOL)animate;
@end
