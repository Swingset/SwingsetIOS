//
//  SSLoadingIndicator.m
//  SwingSet
//
//  Created by Denny Kwon on 1/20/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSLoadingIndicator.h"
#import <QuartzCore/QuartzCore.h>

@interface SSLoadingIndicator ()
@property (strong, nonatomic) UIView *darkScreen;
@end

@implementation SSLoadingIndicator


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        
        self.darkScreen = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.6f*frame.size.width, 0.6f*frame.size.width)];
        self.darkScreen.center = CGPointMake(0.5f*frame.size.width, 0.3f*frame.size.height);
        self.darkScreen.backgroundColor = [UIColor blackColor];
        self.darkScreen.alpha = 0.7f;
        self.darkScreen.layer.cornerRadius = 4.0f;
        [self addSubview:self.darkScreen];
        
    }
    return self;
}

- (void)startLoading
{
    if (self.alpha > 0)
        return;
    
    [UIView animateWithDuration:0.4f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.alpha = 1.0f;
                     }
                     completion:NULL];
    
}

- (void)stopLoading
{
    if (self.alpha < 1)
        return;
    
    [UIView animateWithDuration:0.4f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.alpha = 0.0f;
                     }
                     completion:NULL];
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
