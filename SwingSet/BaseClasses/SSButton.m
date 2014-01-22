//
//  SSButton.m
//  SwingSet
//
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSButton.h"

@implementation SSButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:24.0f];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.layer.cornerRadius = 4.0f;
        self.frame = frame;
        
    }
    return self;
}

+ (SSButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title
{
    
    SSButton *button = [[SSButton alloc] initWithFrame:frame];
    [button setTitle:[title uppercaseString] forState:UIControlStateNormal];
    return button;
    
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
