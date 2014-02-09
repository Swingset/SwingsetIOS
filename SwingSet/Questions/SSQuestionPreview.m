//
//  SSQuestionPreview.m
//  SwingSet
//
//  Created by Denny Kwon on 1/26/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSQuestionPreview.h"
#import "Config.h"
#import "SSOptionView.h"
#import "UIColor+SSColor.h"
#import <QuartzCore/QuartzCore.h>

#define kPadding 10.0f

CGFloat randomRGB(){
    UInt32 i = arc4random() % 256;
    i = abs(i);
    CGFloat rgb = i/255.0f;
    return rgb;
}

@interface SSQuestionPreview ()
@property (nonatomic) CGPoint startPoint;
@property (strong, nonatomic) NSArray *colors;
@property (strong, nonatomic) UILabel *lblMale;
@property (strong, nonatomic) UILabel *lblFemale;
@end

@implementation SSQuestionPreview
@synthesize delegate;
@synthesize lblText;
@synthesize imageView;
@synthesize optionsViews;
@synthesize malePercentViews;
@synthesize femalePercentViews;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat rgbMax = 255.0f;
        UIColor *purple = [UIColor colorWithRed:108.0f/rgbMax green:73.0f/rgbMax blue:142.0f/rgbMax alpha:1.0f];
        UIColor *red = [UIColor colorWithRed:249.0f/rgbMax green:48.0f/rgbMax blue:19.0f/rgbMax alpha:1.0f];
        UIColor *orange = [UIColor colorWithRed:255.0f/rgbMax green:133.0f/rgbMax blue:20.0f/rgbMax alpha:1.0f];
        UIColor *green = [UIColor colorWithRed:0.0f/rgbMax green:108.0f/rgbMax blue:128.0f/rgbMax alpha:1.0f];
        
        self.colors = @[purple, red, orange, green];
        self.optionsViews = [NSMutableArray array];
        self.malePercentViews = [NSMutableArray array];
        self.femalePercentViews = [NSMutableArray array];
        
        self.backgroundColor = [UIColor colorFromHexString:@"#f9f9f9" alpha:1];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3.0f;
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = [[UIColor colorWithRed:0.44f green:0.44f blue:0.44f alpha:1] CGColor];
        
        CGFloat iconDimen = 100.0f;
        CGFloat y = 0.0f;
        self.lblText = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, y, frame.size.width-iconDimen, iconDimen)];
        self.lblText.backgroundColor = [UIColor colorWithRed:randomRGB() green:randomRGB() blue:randomRGB() alpha:1.0f];;
        self.lblText.numberOfLines = 0;
        self.lblText.lineBreakMode = NSLineBreakByWordWrapping;
        self.lblText.font = [UIFont fontWithName:@"ProximaNova-Black" size:16.0f];
        self.lblText.textAlignment = NSTextAlignmentCenter;
        self.lblText.text = @"This is the question";
        self.lblText.textColor = kGreenNext;
        [self addSubview:self.lblText];
        y += iconDimen;
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-iconDimen, 0.0f, iconDimen, iconDimen)];
        self.imageView.backgroundColor = [UIColor blackColor];
        self.imageView.image = [UIImage imageNamed:@"placeholder.png"];
        [self addSubview:self.imageView];

        
        CGFloat w = 0.5*frame.size.width;
        self.lblDate = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, y, w, 20.0f)];
        self.lblDate.backgroundColor = [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f];
        self.lblDate.text = @"   Jan 26";
        self.lblDate.font = [UIFont fontWithName:@"ProximaNova-RegularIt" size:12.0f];
        [self addSubview:self.lblDate];

        self.lblVotes = [[UILabel alloc] initWithFrame:CGRectMake(w, y, w, 20.0f)];
        self.lblVotes.font = self.lblDate.font;
        self.lblVotes.textAlignment = NSTextAlignmentRight;
        self.lblVotes.text = @"15 votes";
        self.lblVotes.backgroundColor = self.lblDate.backgroundColor;
        [self addSubview:self.lblVotes];
        y += self.lblVotes.frame.size.height+10.0f;
        

        CGFloat h = 36.0f;
        for (int i=0; i<4; i++) {
            SSOptionView *option = [[SSOptionView alloc] initWithFrame:CGRectMake(kPadding, y, frame.size.width-2*kPadding, h)];
            option.barColor = self.colors[i];
            option.parent = self;
            option.alpha = 0.0f;
            option.tag = 5000+i;
            [self addSubview:option];
            [self.optionsViews addObject:option];
            y += h+10.0f;
        }
        
        
        UIImage *imgComments = [UIImage imageNamed:@"CommentsButton.png"];
        double scale = 0.4f;
        w = scale*imgComments.size.width;
        h = scale*imgComments.size.height;

        UIButton *btnComments = [UIButton buttonWithType:UIButtonTypeCustom];
        btnComments.frame = CGRectMake(kPadding, frame.size.height-h-kPadding, w, h);
        [btnComments setTitle:@"0 comments" forState:UIControlStateNormal];
        [btnComments addTarget:self action:@selector(btnCommentsAction:) forControlEvents:UIControlEventTouchUpInside];
//        [btnComments setTitleColor:[UIColor colorWithRed:0.44f green:0.44f blue:0.44f alpha:1] forState:UIControlStateNormal];
        [btnComments setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnComments setImage:imgComments forState:UIControlStateNormal];
        [self addSubview:btnComments];
        
        
        // Male / Female labels:
        w = 45.0f;
        y = frame.size.height-h-kPadding-40.0f;
        self.lblMale = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, y, w, 15.0f)];
        self.lblMale.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        self.lblMale.text = @"Male";
        self.lblMale.font = [UIFont fontWithName:@"Arial" size:12.0f];
        self.lblMale.backgroundColor = [UIColor clearColor];
        self.lblMale.textColor = [UIColor blackColor];
        self.lblMale.alpha = 0;
        [self addSubview:self.lblMale];
        
        CGFloat x = w+kPadding;
        for (int i=0; i<self.colors.count; i++) {
            UIView *pctView = [[UIView alloc] initWithFrame:CGRectMake(x, y, 0.0f, self.lblMale.frame.size.height)];
            pctView.backgroundColor = self.colors[i];
            [self addSubview:pctView];
            [self.malePercentViews addObject:pctView];
        }
        
        y += self.lblMale.frame.size.height;
        
        self.lblFemale = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, y, w, 15.0f)];
        self.lblFemale.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        self.lblFemale.backgroundColor = [UIColor clearColor];
        self.lblFemale.font = [UIFont fontWithName:@"Arial" size:12.0f];
        self.lblFemale.text = @"Female";
        self.lblFemale.textColor = [UIColor blackColor];
        self.lblFemale.alpha = 0;
        [self addSubview:self.lblFemale];

        for (int i=0; i<self.colors.count; i++) {
            UIView *pctView = [[UIView alloc] initWithFrame:CGRectMake(x, y, 0.0f, self.lblFemale.frame.size.height)];
            pctView.backgroundColor = self.colors[i];
            [self addSubview:pctView];
            [self.femalePercentViews addObject:pctView];
        }
        
        
    }
    return self;
}

- (void)displayGenderPercents:(NSDictionary *)percents
{
    CGFloat x = 45.0f+kPadding;
    CGFloat fullWidth = self.frame.size.width-x-kPadding; // this is 100% width
    
    NSArray *malePercents = percents[@"male"];
    for (int i=0; i<malePercents.count; i++) {
        NSNumber *pct = [malePercents objectAtIndex:i];
        double p = [pct doubleValue];
        UIView *percentView = [self.malePercentViews objectAtIndex:i];
        
        CGRect frame = percentView.frame;
        frame.size.width = p*fullWidth;
        frame.origin.x = x;
        x += frame.size.width;
        
        [UIView animateWithDuration:0.25f
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             percentView.frame = frame;
                             self.lblMale.alpha = 1;
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }
    
    
    x = 45.0f+kPadding;
    NSArray *femalePercents = percents[@"female"];
    for (int i=0; i<femalePercents.count; i++) {
        NSNumber *pct = [femalePercents objectAtIndex:i];
        double p = [pct doubleValue];
        UIView *percentView = [self.femalePercentViews objectAtIndex:i];
        
        CGRect frame = percentView.frame;
        frame.size.width = p*fullWidth;
        frame.origin.x = x;
        x += frame.size.width;
        
        [UIView animateWithDuration:0.25f
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             percentView.frame = frame;
                             self.lblFemale.alpha = 1;
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }

}


- (void)btnCommentsAction:(UIButton *)btn
{
    [self.delegate viewComments];
}


- (void)reset
{
    CGRect frame;
    for (SSOptionView *optionView in self.optionsViews) {
        optionView.alpha = 0;
        
        optionView.badge.alpha = 0;
        optionView.baseView.layer.borderColor = [[UIColor colorWithRed:0.84f green:0.84f blue:0.84f alpha:1.0f] CGColor];
        
        frame = optionView.percentBar.frame;
        frame.size.width = 0.0f;
        optionView.percentBar.frame = frame;
        optionView.isHilighted = NO;
        optionView.userInteractionEnabled = YES;
    }
    
    
    CGFloat x = 45.0f+kPadding;
    for (UIView *percentView in self.malePercentViews) {
        frame = percentView.frame;
        frame.size.width = 0;
        frame.origin.x = x;
        percentView.frame = frame;
    }
    
    for (UIView *percentView in self.femalePercentViews) {
        frame = percentView.frame;
        frame.size.width = 0;
        frame.origin.x = x;
        percentView.frame = frame;
    }
    
    self.lblFemale.alpha = 0;
    self.lblMale.alpha = 0;
}

#pragma mark - SSOptionViewDelegate
- (void)optionViewSelected:(NSInteger)tag
{
//    NSLog(@"optionViewSelected: %d", tag);
    [self.delegate optionSelected:tag];
}


#pragma mark - UIResponder
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan: %@", [self.class description]);
    UITouch *touch = [touches anyObject];
    self.startPoint = [touch locationInView:self.superview];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesMoved: %@", [self.class description]);
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self.superview];
    CGFloat delta = p.x-self.startPoint.x;
//    NSLog(@"touchesMoved: %.2f", delta);
    
    if (delta > 0){ // cannot move to the right:
//        self.userInteractionEnabled = NO;
        
//        return;
    }


    self.center = CGPointMake(self.center.x+delta, self.center.y);
    self.startPoint = p;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded: %@", [self.class description]);
    
    if ([self.delegate respondsToSelector:@selector(checkPostion)])
        [self.delegate checkPostion];
    
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
