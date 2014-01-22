//
//  SSOptionView.m
//  SwingSet
//
//  Created by Denny Kwon on 1/21/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSOptionView.h"
#import <QuartzCore/QuartzCore.h>

@interface SSOptionView ()
@property (nonatomic, strong) UIView *barView;
@end

@implementation SSOptionView
@synthesize lblText;
@synthesize parent;
//@synthesize barColor = _barColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [[UIColor colorWithRed:0.84f green:0.84f blue:0.84f alpha:1.0f] CGColor];
        self.layer.cornerRadius = 6.0f;
        self.layer.borderWidth = 1.0f;
        self.layer.masksToBounds = YES;
        
        self.barView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, self.bounds.size.height)];
        self.barView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.barView];
        
        CGFloat x = self.barView.frame.size.width+10.0f;
        self.lblText = [[UILabel alloc] initWithFrame:CGRectMake(x, 5.0f, frame.size.width-x-10.0f, frame.size.height-10.0f)];
        self.lblText.font = [UIFont fontWithName:@"ProximaNova-LightIt" size:18.0f];
        self.lblText.lineBreakMode = NSLineBreakByTruncatingTail;
        self.lblText.adjustsFontSizeToFitWidth = YES;
        self.lblText.minimumScaleFactor = 0.80f;
        self.lblText.textColor = [UIColor darkGrayColor];
        self.lblText.backgroundColor = [UIColor clearColor];
        self.lblText.text = @"This is an question response option.";
        [self addSubview:self.lblText];
        
        self.alpha = 0;
        

    }
    return self;
}

+ (SSOptionView *)optionViewWithFrame:(CGRect)frame
{
    SSOptionView *optionView = [[SSOptionView alloc] initWithFrame:frame];
    
    
    
    return optionView;
}


- (void)setBarColor:(UIColor *)barColor
{
	if (_barColor != barColor) {
		_barColor = barColor;
		self.barView.backgroundColor = barColor;
	}
}

- (void)applyTranformAnimation:(CGAffineTransform)transform duration:(double)duration completion:(void (^)(BOOL finished))completion
{
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.transform = transform;
                     }
                     completion:completion];
}

#pragma mark - UIResponder
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan:");
    [self applyTranformAnimation:CGAffineTransformMakeScale(1.05f, 1.1f) duration:0.2f completion:NULL];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesMoved:");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded:");
    [self applyTranformAnimation:CGAffineTransformIdentity duration:0.2f completion:NULL];
    
    if ([self.parent respondsToSelector:@selector(optionViewSelected:)]){
        [self.parent optionViewSelected:self.tag];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesCancelled:");
    [self applyTranformAnimation:CGAffineTransformIdentity duration:0.2f completion:NULL];
}

@end
