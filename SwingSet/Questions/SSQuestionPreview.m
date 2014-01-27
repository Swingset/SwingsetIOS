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


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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
        self.lblDate.text = @" Jan 26";
        self.lblDate.font = [UIFont fontWithName:@"ProximaNova-RegularIt" size:12.0f];
        [self addSubview:self.lblDate];

        self.lblVotes = [[UILabel alloc] initWithFrame:CGRectMake(w, y, w, 20.0f)];
        self.lblVotes.font = self.lblDate.font;
        self.lblVotes.textAlignment = NSTextAlignmentRight;
        self.lblVotes.text = @"15 votes ";
        self.lblVotes.backgroundColor = self.lblDate.backgroundColor;
        [self addSubview:self.lblVotes];
        y += self.lblVotes.frame.size.height+30.0f;
        

        NSArray *colors = @[[UIColor blueColor], [UIColor redColor], [UIColor greenColor], [UIColor yellowColor]];
        CGFloat h = 36.0f;
        for (int i=0; i<4; i++) {
            SSOptionView *option = [[SSOptionView alloc] initWithFrame:CGRectMake(10, y, frame.size.width-20, h)];
            option.barColor = colors[i];
            option.parent = self;
            option.alpha = 1.0f;
            option.tag = 1000+i;
            [self addSubview:option];
            y += h+10.0f;
        }
        
    }
    return self;
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



#pragma mark - SSOptionViewDelegate
- (void)optionViewSelected:(NSInteger)tag
{
    NSLog(@"optionViewSelected: %d", tag);
}


#pragma mark - UIResponder
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"touchesBegan:");
    UITouch *touch = [touches anyObject];
    self.startPoint = [touch locationInView:self.superview];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self.superview];
    CGFloat delta = p.x-self.startPoint.x;
//    NSLog(@"touchesMoved: %.2f", delta);

    self.center = CGPointMake(self.center.x+delta, self.center.y);

    self.startPoint = p;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"touchesEnded:");
    
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
