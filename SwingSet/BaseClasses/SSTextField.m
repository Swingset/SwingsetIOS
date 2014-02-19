//
//  SSTextField.m
//  SwingSet
//
//  Created by Denny Kwon on 1/19/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSTextField.h"

@implementation SSTextField
@synthesize imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.borderStyle = UITextBorderStyleNone;
        self.font = [UIFont fontWithName:@"ProximaNova-Light" size:14.0f];
        self.leftViewMode = UITextFieldViewModeAlways;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.imageView.image = [UIImage imageNamed:@"bg_textfield.png"];
        [self addSubview:self.imageView];
        
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10.0f, frame.size.height)];
        self.leftView = paddingView;
    }
    return self;
}

+ (SSTextField *)textFieldWithFrame:(CGRect)frame placeholder:(NSString *)ph keyboard:(UIKeyboardType)kb
{
    
    SSTextField *textField = [[SSTextField alloc] initWithFrame:frame];
    textField.keyboardType = kb;
    textField.placeholder = ph;
    return textField;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
