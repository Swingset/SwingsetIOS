//
//  SSResultCell.m
//  SwingSet
//
//  Created by Denny Kwon on 2/13/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSResultCell.h"
#import "Config.h"
#import "UIColor+SSColor.h"
#import <QuartzCore/QuartzCore.h>
#import "SSOptionView.h"

@interface SSResultCell ()

@end

@implementation SSResultCell
@synthesize icon;
@synthesize lblText;
@synthesize lblDetails;
@synthesize iconBase;
@synthesize optionViews;
@synthesize optionsImageViews;

+ (CGFloat)standardHeight
{
    static CGFloat h = 340.0f;
    return h;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.optionViews = [NSMutableArray array];
        self.optionsImageViews = [NSMutableArray array];
        CGRect frame = [UIScreen mainScreen].applicationFrame;
        
        
        self.backgroundColor = kGrayTable;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat padding = 15.0f;
        
        
        UIView *base = [[UIView alloc] initWithFrame:CGRectMake(padding, padding, frame.size.width-2*padding, [SSResultCell standardHeight]-padding)];
        base.backgroundColor = [UIColor colorFromHexString:@"#f9f9f9" alpha:1];
        base.layer.masksToBounds = YES;
        base.layer.cornerRadius = 3.0f;
        base.layer.borderWidth = 0.5f;
        base.layer.borderColor = [[UIColor colorWithRed:0.44f green:0.44f blue:0.44f alpha:1] CGColor];

        CGFloat dimen = 80.0f;
        padding = 10.0f;
        UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, base.frame.size.width, dimen)];
        top.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hb_background_green.png"]];
        [base addSubview:top];
        
        CGFloat y = dimen;
        
        UIImageView *dropShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropShadow.png"]];
        dropShadow.frame = CGRectMake(0.0f, y, dropShadow.frame.size.width, 0.50f*dropShadow.frame.size.height);
        [base addSubview:dropShadow];
        
        self.lblText = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding, base.frame.size.width-dimen-2*padding, 30.0f)];
        self.lblText.font = [UIFont fontWithName:@"ProximaNova-Black" size:14.0];
        self.lblText.textColor = [UIColor whiteColor];
        self.lblText.shadowColor = [UIColor blackColor];
        self.lblText.shadowOffset = CGSizeMake(-0.5f, 0.5f);
        self.lblText.numberOfLines = 0;
        self.lblText.lineBreakMode = NSLineBreakByWordWrapping;
        [self.lblText addObserver:self forKeyPath:@"text" options:0 context:nil];
        [base addSubview:self.lblText];

        y = self.lblText.frame.origin.y+self.lblText.frame.size.height;
        self.lblDetails = [[UILabel alloc] initWithFrame:CGRectMake(padding, y, self.lblText.frame.size.width, 16.0f)];
        self.lblDetails.font = [UIFont fontWithName:@"ProximaNova-RegularIt" size:12.0f];
        self.lblDetails.textColor = [UIColor blackColor];
        [base addSubview:self.lblDetails];
        
        y = top.frame.origin.y+top.frame.size.height+10.0f;
        
        NSArray *colors = @[kPurple, kRed, kOrange, kGreen];
        for (int i=0; i<4; i++) {
            SSOptionView *optionView = [SSOptionView optionViewWithFrame:CGRectMake(10.0f, y, base.frame.size.width-20.0f, 36.0f)];
            optionView.userInteractionEnabled = NO;
            optionView.barColor = colors[i];
            [base addSubview:optionView];
            [self.optionViews addObject:optionView];
            y += optionView.frame.size.height+10.0f;
        }
        
        
        static CGFloat iconDimen = 82.0f;
        static CGFloat indent = 57.0f;
        for (int i=0; i<4; i++) {
            CGFloat originY = top.frame.origin.y+top.frame.size.height+10.0f;
            CGRect iconFrame;
            if (i==0)
                iconFrame = CGRectMake(indent, originY, iconDimen, iconDimen);
            
            if (i==1)
                iconFrame = CGRectMake(base.frame.size.width-iconDimen-indent, originY, iconDimen, iconDimen);
            
            if (i==2)
                iconFrame = CGRectMake(indent, originY+iconDimen+10.0f, iconDimen, iconDimen);
            
            if (i==3)
                iconFrame = CGRectMake(base.frame.size.width-iconDimen-indent, originY+iconDimen+10.0f, iconDimen, iconDimen);
            
            
            SSOptionIcon *optionIcon = [[SSOptionIcon alloc] initWithFrame:iconFrame];
            optionIcon.userInteractionEnabled = YES;
            optionIcon.backgroundColor = [UIColor redColor];
            [base addSubview:optionIcon];
            [self.optionsImageViews addObject:optionIcon];
        }
        
        
        

        
        

        
        [self.contentView addSubview:base];
        
        CGFloat x = frame.size.width-dimen-12.0f;
        y = 12.0f;
        self.iconBase = [[UIView alloc] initWithFrame:CGRectMake(x, y, dimen, dimen)];
        self.iconBase.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:self.iconBase];
        
        x++;
        y--;
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, dimen, dimen)];
        self.icon.backgroundColor = [UIColor clearColor];
        self.icon.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.icon.layer.borderWidth = 3.0f;
        [self.contentView addSubview:self.icon];
        
        


    }
    return self;
}

- (void)dealloc
{
    [self.lblText removeObserver:self forKeyPath:@"text"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isEqual:self.lblText]==NO)
        return;
    
    if ([keyPath isEqualToString:@"text"]==NO)
        return;
    
    CGRect textRect = [self.lblText.text boundingRectWithSize:CGSizeMake(self.lblText.frame.size.width, 100.0f)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:self.lblText.font}
                                                context:nil];
    
    CGRect frame = self.lblText.frame;
    frame.size.height = textRect.size.height;
    self.lblText.frame = frame;
    
    frame = self.lblDetails.frame;
    frame.origin.y = self.lblText.frame.origin.y+self.lblText.frame.size.height;
    self.lblDetails.frame = frame;

    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end