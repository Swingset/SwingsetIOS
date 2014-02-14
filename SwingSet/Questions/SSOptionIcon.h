//
//  SSOptionIcon.h
//  SwingSet
//
//  Created by Denny Kwon on 2/12/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSOptionIconDelegate
- (void)optionIconSelected:(NSInteger)tag;
@end

@interface SSOptionIcon : UIView

@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UIImage *image;
@property (nonatomic, strong) UIImageView *badge;
@property (nonatomic, strong) UILabel *lblPercentage;
@property (assign) id parent;
- (void)showPercentage:(double)pct;
- (void)showPercentage:(double)pct animated:(BOOL)animate;
@end
