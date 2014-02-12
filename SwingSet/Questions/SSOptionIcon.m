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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
