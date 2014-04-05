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
@property (strong, nonatomic) UIButton *btnSkip;
@end

@implementation SSQuestionPreview
@synthesize delegate;
@synthesize lblText;
@synthesize imageView;
@synthesize optionsViews;
@synthesize optionsImageViews;
@synthesize malePercentViews;
@synthesize femalePercentViews;
@synthesize btnComments;
@synthesize isMovable;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isMovable = YES;
        self.colors = @[kPurple, kRed, kOrange, kGreen];
        self.optionsViews = [NSMutableArray array];
        self.optionsImageViews = [NSMutableArray array];
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
        self.lblText.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hb_background_green.png"]];
        self.lblText.numberOfLines = 0;
        self.lblText.lineBreakMode = NSLineBreakByWordWrapping;
        self.lblText.font = [UIFont fontWithName:@"ProximaNova-Black" size:16.0f];
        self.lblText.textAlignment = NSTextAlignmentCenter;
        self.lblText.textColor = [UIColor whiteColor];
        [self addSubview:self.lblText];
        y += iconDimen;
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-iconDimen, 0.0f, iconDimen, iconDimen)];
        self.imageView.backgroundColor = self.lblText.backgroundColor;
        [self addSubview:self.imageView];

        
        CGFloat w = 0.5*frame.size.width;
        
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0.0f, y, frame.size.width, 20.0f)];
        bg.backgroundColor = self.lblText.backgroundColor;
        [self addSubview:bg];
        
        UIView *infoBar = [[UIView alloc] initWithFrame:CGRectMake(0.0f, y, frame.size.width, 20.0f)];
        infoBar.backgroundColor = [UIColor blackColor];
        infoBar.alpha = 0.1f;
        [self addSubview:infoBar];
        
        self.lblDate = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, y, w+35, 20.0f)];
        self.lblDate.backgroundColor = [UIColor clearColor];
        self.lblDate.textColor = [UIColor whiteColor];
        self.lblDate.font = [UIFont fontWithName:@"ProximaNova-Light" size:12.0f];
        [self addSubview:self.lblDate];

        self.lblVotes = [[UILabel alloc] initWithFrame:CGRectMake(w, y, w-5, 20.0f)];
        self.lblVotes.font = self.lblDate.font;
        self.lblVotes.textColor = [UIColor whiteColor];
        self.lblVotes.textAlignment = NSTextAlignmentRight;
        self.lblVotes.backgroundColor = self.lblDate.backgroundColor;
        self.lblVotes.alpha = 0.0f;
        [self addSubview:self.lblVotes];
        y += self.lblVotes.frame.size.height+10.0f;
        

        CGFloat h = 36.0f;
        NSArray *badges = @[@"largepurplepercentage.png", @"largeredpercentage.png", @"largeorangepercentage.png", @"largebluepercentage.png"];

        for (int i=0; i<4; i++) {
            SSOptionView *option = [[SSOptionView alloc] initWithFrame:CGRectMake(kPadding, y, frame.size.width-2*kPadding, h)];
            option.barColor = self.colors[i];
            option.badge.image = [UIImage imageNamed:badges[i]];
            option.parent = self;
            option.alpha = 0.0f;
            option.tag = 5000+i;
            [self addSubview:option];
            [self.optionsViews addObject:option];
            y += h+10.0f;
        }
        
        UIImage *cameraIcon = [UIImage imageNamed:@"selectPhotoIcon.png"];
        iconDimen = 114.0f;
        static CGFloat indent = 30.5f;
        for (int i=0; i<4; i++) {
            CGFloat originY = self.lblVotes.frame.origin.y+self.lblVotes.frame.size.height+1.0f;
            CGRect iconFrame;
            if (i==0)
                iconFrame = CGRectMake(indent, originY, iconDimen, iconDimen);

            if (i==1)
                iconFrame = CGRectMake(self.frame.size.width-iconDimen-indent, originY, iconDimen, iconDimen);

            if (i==2)
                iconFrame = CGRectMake(indent, originY+iconDimen+1.0f, iconDimen, iconDimen);

            if (i==3)
                iconFrame = CGRectMake(self.frame.size.width-iconDimen-indent, originY+iconDimen+1.0f, iconDimen, iconDimen);

            
            SSOptionIcon *optionIcon = [[SSOptionIcon alloc] initWithFrame:iconFrame];
            optionIcon.tag = 5000+i;
            optionIcon.badge.image = [UIImage imageNamed:badges[i]];
            optionIcon.parent = self;
            optionIcon.userInteractionEnabled = YES;
            optionIcon.image = cameraIcon;
            optionIcon.alpha = 0.0f;
            [self addSubview:optionIcon];
            [self.optionsImageViews addObject:optionIcon];
        }
        
        // reorganize icons so that percentage bubbles display properly:
        [self bringSubviewToFront:self.optionsImageViews[0]];
        [self bringSubviewToFront:self.optionsImageViews[2]];
        
        UIImage *imgComments = [UIImage imageNamed:@"CommentsButton.png"];
        double scale = 0.4f;
        w = scale*imgComments.size.width;
        h = scale*imgComments.size.height;

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-h-kPadding-0.5f, frame.size.width, 1.0f)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];

        self.btnComments = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnComments.frame = CGRectMake(0.0f, frame.size.height-h-kPadding, 0.5f*frame.size.width, 34.0f);
        
        [self.btnComments setTitle:@"0 comments" forState:UIControlStateNormal];
        self.btnComments.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.btnComments setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btnComments.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0f];
        [self.btnComments addTarget:self action:@selector(btnCommentsAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnComments setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        UIImageView *imgComment = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"commentbubble.png"]];
        scale = 34.0f/imgComment.frame.size.height;
        
        imgComment.frame = CGRectMake(0, -0.5f, scale*imgComment.frame.size.width, 35.0f);
        [self.btnComments addSubview:imgComment];
        
        self.btnComments.backgroundColor = [UIColor whiteColor];
        self.btnComments.alpha = 0.60f;
        [self addSubview:self.btnComments];
        
        
        self.btnSkip = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnSkip.frame = CGRectMake(0.5f*frame.size.width, frame.size.height-h-kPadding, 0.5f*frame.size.width, 34.0f);
        self.btnSkip.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:18.0f];
        [self.btnSkip setBackgroundColor:kGreenNext];
        [self.btnSkip setTitle:@"SKIP" forState:UIControlStateNormal];
        [self.btnSkip setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnSkip addTarget:self action:@selector(btnSkipAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *nextArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nextarrow.png"]];
        h = self.btnSkip.frame.size.height-8.0f;
        
        scale = h/nextArrow.frame.size.height;
        CGRect f = nextArrow.frame;
        f.size.height = h;
        f.origin.y = 4.0f;
        f.size.width *= scale;
        f.origin.x = self.btnSkip.frame.size.width-f.size.width-3.0f;
        nextArrow.frame = f;
        [self.btnSkip addSubview:nextArrow];
        
        
        [self addSubview:self.btnSkip];
        

        
        // Male / Female labels:
        w = 45.0f;
        y = frame.size.height-h-kPadding-40.0f;
        self.lblMale = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, y, w, 15.0f)];
        self.lblMale.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        self.lblMale.text = @"Male";
        self.lblMale.font = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0f];
        self.lblMale.backgroundColor = [UIColor clearColor];
        self.lblMale.textColor = [UIColor colorWithRed:56.0f/255.0f green:62.0f/255.0f blue:64.0f/255.0f alpha:1.0f];
        self.lblMale.alpha = 0;
        [self addSubview:self.lblMale];
        
        CGFloat x = w+kPadding;
        for (int i=0; i<self.colors.count; i++) {
            UILabel *pctView = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 0.0f, self.lblMale.frame.size.height)];
            pctView.backgroundColor = self.colors[i];
            pctView.textColor = [UIColor whiteColor];
            pctView.textAlignment = NSTextAlignmentLeft;
            pctView.font = [UIFont fontWithName:@"ProximaNova-Regular" size:10.0f];
            [self addSubview:pctView];
            [self.malePercentViews addObject:pctView];
        }
        
        y += self.lblMale.frame.size.height;
        
        self.lblFemale = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, y, w, 15.0f)];
        self.lblFemale.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        self.lblFemale.backgroundColor = [UIColor clearColor];
        self.lblFemale.font = self.lblMale.font;
        self.lblFemale.text = @"Female";
        self.lblFemale.textColor = self.lblMale.textColor;
        self.lblFemale.alpha = 0;
        [self addSubview:self.lblFemale];

        for (int i=0; i<self.colors.count; i++) {
            UILabel *pctView = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 0.0f, self.lblFemale.frame.size.height)];
            pctView.backgroundColor = self.colors[i];
            pctView.textColor = [UIColor whiteColor];
            pctView.textAlignment = NSTextAlignmentLeft;
            pctView.font = [UIFont fontWithName:@"ProximaNova-Regular" size:10.0f];
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
    NSUInteger max = (malePercents.count >= 4) ? 4 : malePercents.count;
    for (int i=0; i<max; i++) {
        NSNumber *pct = [malePercents objectAtIndex:i];
        double p = [pct doubleValue];
        UILabel *percentView = (UILabel *)[self.malePercentViews objectAtIndex:i];
        
        CGRect frame = percentView.frame;
        frame.size.width = p*fullWidth;
        frame.origin.x = x;
        x += frame.size.width;
        
        percentView.text = [NSString stringWithFormat:@"%.1f", (p*100)];
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
    max = (femalePercents.count >= 4) ? 4 : femalePercents.count;
    for (int i=0; i<max; i++) {
        NSNumber *pct = [femalePercents objectAtIndex:i];
        double p = [pct doubleValue];
        UILabel *percentView = (UILabel *)[self.femalePercentViews objectAtIndex:i];
        
        CGRect frame = percentView.frame;
        frame.size.width = p*fullWidth;
        frame.origin.x = x;
        x += frame.size.width;
        
        percentView.text = [NSString stringWithFormat:@"%.1f", (p*100)];
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

- (void)btnSkipAction:(UIButton *)btn
{
    [self.delegate skip];
}

- (void)btnCommentsAction:(UIButton *)btn
{
    if (self.btnComments.alpha < 1.0f) {
        [self.delegate viewComments:NO];
        return;
    }

    [self.delegate viewComments:YES];

}


- (void)reset
{
    CGRect frame;
    for (SSOptionView *optionView in self.optionsViews) {
        optionView.alpha = 0;
        
        optionView.badge.alpha = 0;
        optionView.badge.transform = CGAffineTransformIdentity;
        optionView.lblPercentage.transform = CGAffineTransformIdentity;
        optionView.baseView.layer.borderColor = [[UIColor colorWithRed:0.84f green:0.84f blue:0.84f alpha:1.0f] CGColor];
        
        frame = optionView.percentBar.frame;
        frame.size.width = 0.0f;
        optionView.percentBar.frame = frame;
        optionView.isHilighted = NO;
        optionView.userInteractionEnabled = YES;
    }
    
    for (SSOptionIcon *optionIcon in self.optionsImageViews) {
        optionIcon.alpha = 0;
        optionIcon.badge.alpha = 0;
        optionIcon.badge.transform = CGAffineTransformIdentity;
        optionIcon.lblPercentage.transform = CGAffineTransformIdentity;
        optionIcon.userInteractionEnabled = YES;
    }
    
    
    CGFloat x = 45.0f+kPadding;
    for (UILabel *percentView in self.malePercentViews) {
        frame = percentView.frame;
        frame.size.width = 0;
        frame.origin.x = x;
        percentView.frame = frame;
        percentView.text = @"";
    }
    
    for (UILabel *percentView in self.femalePercentViews) {
        frame = percentView.frame;
        frame.size.width = 0;
        frame.origin.x = x;
        percentView.frame = frame;
        percentView.text = @"";
    }
    
    self.lblVotes.alpha = 0.0f;
    self.lblFemale.alpha = 0.0f;
    self.lblMale.alpha = 0.0f;
    self.btnComments.alpha = 0.60f;
    [self.btnSkip setTitle:@"SKIP" forState:UIControlStateNormal];

}

- (void)activateButtons
{
    [self.btnSkip setTitle:@"NEXT" forState:UIControlStateNormal];
    self.btnComments.alpha = 1.0f;
    self.lblVotes.alpha = 1.0f;
}

#pragma mark - SSOptionViewDelegate
- (void)optionViewSelected:(NSInteger)tag
{
//    NSLog(@"optionViewSelected: %d", tag);
    [self.delegate optionSelected:tag];
    [self activateButtons];
}

#pragma mark - SSOptionIconDelegate
- (void)optionIconSelected:(NSInteger)tag
{
    NSLog(@"optionIconSelected: %lu", (long)tag);
    [self.delegate optionSelected:tag];
    [self activateButtons];
}



#pragma mark - UIResponder
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan: %@", [self.class description]);
    if (!self.isMovable)
        return;
    
    UITouch *touch = [touches anyObject];
    self.startPoint = [touch locationInView:self.superview];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesMoved: %@", [self.class description]);
    if (!self.isMovable)
        return;
    
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
    if (!self.isMovable)
        return;
    
    
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
