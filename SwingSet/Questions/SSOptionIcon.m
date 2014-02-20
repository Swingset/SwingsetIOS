//
//  SSOptionIcon.m
//  SwingSet
//
//  Created by Denny Kwon on 2/12/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSOptionIcon.h"

@implementation SSOptionIcon
@synthesize icon;
@synthesize badge;
@synthesize lblPercentage;
@synthesize parent;
@synthesize image = _image;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
        [self addSubview:self.icon];
        
        
        self.badge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"largebluepercentage.png"]];
        CGRect badgeFrame = self.badge.frame;
        double scale = 0.40f;
        badgeFrame.size.width *= scale;
        badgeFrame.size.height *= scale;
        badgeFrame.origin.x = frame.size.width-30;
        badgeFrame.origin.y = -0.4*badgeFrame.size.height;
        self.badge.alpha = 0.0f;
        self.badge.frame = badgeFrame;
        
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

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.icon.image = image;
}



- (void)showPercentage:(double)pct
{
    NSLog(@"OPTION ICON: SHOW PERCENTAGE");
    
    [self showPercentage:pct animated:YES];
    
}

- (void)showPercentage:(double)pct animated:(BOOL)animate
{
    
    self.userInteractionEnabled = NO;
    self.lblPercentage.text = [NSString stringWithFormat:@"%.1f", (100*pct)];
    
    if (!animate){
        self.badge.alpha = 1.0f;
        return;
    }
    
    [UIView transitionWithView:self.badge
                      duration:0.35f
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        self.badge.alpha = 1.0f;
                    }
                    completion:NULL];
    
}



#pragma mark - UIResponder
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    NSLog(@"touchesBegan:");
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    NSLog(@"touchesMoved:");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    NSLog(@"touchesEnded:");
    
    CGRect frame = self.badge.frame;
    frame.size.width *= 1.1f;
    frame.size.height *= 1.1f;
    frame.origin.y -= 2.0f;
    self.badge.frame = frame;

    if ([self.parent respondsToSelector:@selector(optionIconSelected:)])
        [self.parent optionIconSelected:self.tag];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    NSLog(@"touchesCancelled:");
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
