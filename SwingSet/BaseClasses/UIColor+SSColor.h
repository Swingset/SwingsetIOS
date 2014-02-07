//
//  UIColor+SSColor.h
//  SwingSet
//
//  Created by Denny Kwon on 2/7/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (SSColor)


+ (UIColor *)colorFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha;
@end
