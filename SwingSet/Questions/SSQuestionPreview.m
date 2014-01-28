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
#import <QuartzCore/QuartzCore.h>


CGFloat randomRGB(){
    UInt32 i = arc4random() % 256;
    i = abs(i);
    CGFloat rgb = i/255.0f;
    return rgb;
}

@interface SSQuestionPreview ()
@property (nonatomic) CGPoint startPoint;
@end

@implementation SSQuestionPreview
@synthesize delegate;
@synthesize lblText;
@synthesize imageView;
@synthesize optionsViews;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.optionsViews = [NSMutableArray array];
        
        self.backgroundColor = [self getUIColorObjectFromHexString:@"#f9f9f9" alpha:1];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.0f;
        self.layer.borderWidth = 1.0f;
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
        y += self.lblVotes.frame.size.height+30.0f;
        

        NSArray *colors = @[[UIColor blueColor], [UIColor redColor], [UIColor greenColor], [UIColor yellowColor]];
        CGFloat h = 36.0f;
        CGFloat padding = 10.0f;
        for (int i=0; i<4; i++) {
            SSOptionView *option = [[SSOptionView alloc] initWithFrame:CGRectMake(padding, y, frame.size.width-2*padding, h)];
            option.barColor = colors[i];
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
        btnComments.frame = CGRectMake(padding, frame.size.height-h-padding, w, h);
        [btnComments setTitle:@"0 comments" forState:UIControlStateNormal];
        [btnComments addTarget:self action:@selector(btnCommentsAction:) forControlEvents:UIControlEventTouchUpInside];
//        [btnComments setTitleColor:[UIColor colorWithRed:0.44f green:0.44f blue:0.44f alpha:1] forState:UIControlStateNormal];
        [btnComments setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnComments setImage:imgComments forState:UIControlStateNormal];
        [self addSubview:btnComments];
        
        
    }
    return self;
}


- (void)btnCommentsAction:(UIButton *)btn
{
    [self.delegate viewComments];
}

- (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
    // Convert hex string to an integer
    unsigned int hexint = [self intFromHexString:hexStr];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}



- (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
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
    }
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
        self.userInteractionEnabled = NO;
        
        return;
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
