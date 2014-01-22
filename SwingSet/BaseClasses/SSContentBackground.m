//
//  SSContentBackground.m
//  SwingSet
//
//  Created by Denny Kwon on 1/19/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSContentBackground.h"
#import <QuartzCore/QuartzCore.h>

@implementation SSContentBackground

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (SSContentBackground *)backgroundWithFrame:(CGRect)frame
{
    UIImage *bgWhiter = [UIImage imageNamed:@"hb_bg_whiter.png"];
//    CGFloat h = 1.40f*bgWhiter.size.height;
    SSContentBackground *bg = [[SSContentBackground alloc] initWithFrame:frame];
    bg.layer.borderWidth = 1.0f;
    CGFloat gray = 0.80f;
    bg.layer.borderColor = [[UIColor colorWithRed:gray green:gray blue:gray alpha:1.0f] CGColor];
    bg.backgroundColor = [UIColor colorWithPatternImage:bgWhiter];
    return bg;
}

/*
 
 */

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
