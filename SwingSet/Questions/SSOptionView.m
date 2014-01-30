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
@synthesize baseView;
@synthesize percentBar;
@synthesize lblText;
@synthesize parent;
@synthesize badge;
@synthesize lblPercentage;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        self.isHilighted = NO;
        
        self.baseView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
        self.baseView.backgroundColor = [UIColor whiteColor];
        self.baseView.layer.borderColor = [[UIColor colorWithRed:0.84f green:0.84f blue:0.84f alpha:1.0f] CGColor];
        self.baseView.layer.cornerRadius = 6.0f;
        self.baseView.layer.borderWidth = 0.5f;
        self.baseView.layer.masksToBounds = YES;
        
        self.percentBar = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, self.bounds.size.height)];
        self.percentBar.backgroundColor = [UIColor lightGrayColor];
        [self.baseView addSubview:self.percentBar];
        
        self.barView = [[UIView alloc] initWithFrame:CGRectMake(1.0f, 1.0f, 9.0f, self.bounds.size.height-2.0f)];
        self.barView.backgroundColor = [UIColor clearColor];
        [self.baseView addSubview:self.barView];
        
        [self addSubview:self.baseView];
        
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
        
        self.badge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"largebluepercentage.png"]];
        CGRect badgeFrame = self.badge.frame;
        double scale = 0.40f;
        badgeFrame.size.width *= scale;
        badgeFrame.size.height *= scale;
        badgeFrame.origin.x = frame.size.width-30;
        badgeFrame.origin.y = 0.5*(frame.size.height-badgeFrame.size.height);
        self.badge.frame = badgeFrame;
        self.badge.alpha = 0;
        
        self.lblPercentage = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, badgeFrame.size.width, badgeFrame.size.height)];
        self.lblPercentage.backgroundColor = [UIColor clearColor];
        self.lblPercentage.textColor = [UIColor whiteColor];
        self.lblPercentage.text = @"50.0";
        self.lblPercentage.adjustsFontSizeToFitWidth = YES;
        self.lblPercentage.textAlignment = NSTextAlignmentCenter;
        self.lblPercentage.font = [UIFont fontWithName:@"ProximaNova-Bold" size:12.0f];
        [self.badge addSubview:self.lblPercentage];

        [self addSubview:self.badge];
        
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
        
        CGColorRef color = [barColor CGColor];
        

        if (CGColorGetNumberOfComponents(color) != 4)
            return;

        const CGFloat *components = CGColorGetComponents(color);
        CGFloat red = components[0];
        CGFloat green = components[1];
        CGFloat blue = components[2];
        self.percentBar.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.20f];
	}
}

- (void)showPercentage:(double)pct
{
    NSLog(@"SHOW PERCENTAGE");
    
    self.userInteractionEnabled = NO;
    self.lblPercentage.text = [NSString stringWithFormat:@"%.1f", (100*pct)];
//    double duration = 0.65f;
    double duration = 0.25f;
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect frame = self.percentBar.frame;
                         frame.size.width = pct*self.bounds.size.width;
                         self.percentBar.frame = frame;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    
    [UIView transitionWithView:self.badge
                      duration:duration+0.1f
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        self.badge.alpha = 1.0f;
                    }
                    completion:NULL];
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

- (void)setIsHilighted:(BOOL)isHilighted
{
    if (_isHilighted==isHilighted)
        return;
    
    _isHilighted = isHilighted;
}

#pragma mark - UIResponder
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"touchesBegan:");
    [self applyTranformAnimation:CGAffineTransformMakeScale(1.05f, 1.1f) duration:0.2f completion:NULL];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"touchesMoved:");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"touchesEnded:");
    [self applyTranformAnimation:CGAffineTransformIdentity duration:0.2f completion:^(BOOL finisehd){
        self.baseView.layer.borderColor = [self.barView.backgroundColor CGColor];

    }];
    
    self.isHilighted = YES;
    if ([self.parent respondsToSelector:@selector(optionViewSelected:)])
        [self.parent optionViewSelected:self.tag];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"touchesCancelled:");
    [self applyTranformAnimation:CGAffineTransformIdentity duration:0.2f completion:NULL];
}

@end
