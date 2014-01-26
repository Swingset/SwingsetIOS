//
//  SSButton.h
//  SwingSet
//
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.


#import <UIKit/UIKit.h>
#import "Config.h"

typedef enum {
    TextModeDefault = 0,
    TextModeLowerCase,
    TextModeUpperCase
} TextMode;

@interface SSButton : UIButton

+ (SSButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title textMode:(TextMode)textMode;

@property (nonatomic) TextMode *textMode;

@end