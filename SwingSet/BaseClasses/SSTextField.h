//
//  SSTextField.h
//  SwingSet
//
//  Created by Denny Kwon on 1/19/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSTextField : UITextField

@property (strong, nonatomic) UIImageView *imageView;
+ (SSTextField *)textFieldWithFrame:(CGRect)frame placeholder:(NSString *)ph keyboard:(UIKeyboardType)kb;
@end
