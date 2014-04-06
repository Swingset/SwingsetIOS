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

#define kPadding 10.0f

@interface SSResultCell ()
@property (strong, nonatomic) NSArray *colors;
@property (strong, nonatomic) UILabel *lblMale;
@property (strong, nonatomic) UILabel *lblFemale;
@end

@implementation SSResultCell
@synthesize icon;
@synthesize lblText;
@synthesize lblDetails;
@synthesize iconBase;
@synthesize optionViews;
@synthesize optionsImageViews;
@synthesize btnComments;
@synthesize btnDelete;
@synthesize delegate;
@synthesize malePercentViews;
@synthesize femalePercentViews;

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
        self.malePercentViews = [NSMutableArray array];
        self.femalePercentViews = [NSMutableArray array];
        self.colors = @[kPurple, kRed, kOrange, kGreen];

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
        self.lblDetails = [[UILabel alloc] initWithFrame:CGRectMake(padding, y, self.lblText.frame.size.width, 28.0f)];
        self.lblDetails.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        self.lblDetails.font = [UIFont fontWithName:@"ProximaNova-Light" size:12.0f];
        self.lblDetails.textColor = [UIColor blackColor];
        self.lblDetails.numberOfLines = 2;
        self.lblDetails.lineBreakMode = NSLineBreakByWordWrapping;
        [base addSubview:self.lblDetails];
        
        y = top.frame.origin.y+top.frame.size.height+10.0f;
        
//        NSArray *colors = @[kPurple, kRed, kOrange, kGreen];
        NSArray *badges = @[@"largepurplepercentage.png", @"largeredpercentage.png", @"largeorangepercentage.png", @"largebluepercentage.png"];
        for (int i=0; i<4; i++) {
            SSOptionView *optionView = [SSOptionView optionViewWithFrame:CGRectMake(10.0f, y, base.frame.size.width-20.0f, 36.0f)];
            optionView.userInteractionEnabled = NO;
            optionView.barColor = self.colors[i];
            optionView.badge.image = [UIImage imageNamed:badges[i]];
            [base addSubview:optionView];
            [self.optionViews addObject:optionView];
            y += optionView.frame.size.height+10.0f;
        }
        
        
        static CGFloat iconDimen = 103.0f;
        static CGFloat indent = 41.5f;
        for (int i=0; i<4; i++) {
            CGFloat originY = top.frame.origin.y+top.frame.size.height+3.0f;
            CGRect iconFrame;
            if (i==0)
                iconFrame = CGRectMake(indent, originY, iconDimen, iconDimen);
            
            if (i==1)
                iconFrame = CGRectMake(base.frame.size.width-iconDimen-indent, originY, iconDimen, iconDimen);
            
            if (i==2)
                iconFrame = CGRectMake(indent, originY+iconDimen+1.0f, iconDimen, iconDimen);
            
            if (i==3)
                iconFrame = CGRectMake(base.frame.size.width-iconDimen-indent, originY+iconDimen+1.0f, iconDimen, iconDimen);
            
            SSOptionIcon *optionIcon = [[SSOptionIcon alloc] initWithFrame:iconFrame];
            optionIcon.userInteractionEnabled = YES;
            optionIcon.badge.image = [UIImage imageNamed:badges[i]];
            optionIcon.backgroundColor = [UIColor redColor];
            [base addSubview:optionIcon];
            [self.optionsImageViews addObject:optionIcon];
        }
        
        // reorganize icons so that percentage bubbles display properly:
        [base bringSubviewToFront:self.optionsImageViews[0]];
        [base bringSubviewToFront:self.optionsImageViews[2]];
        
        
        
        UIImage *imgComments = [UIImage imageNamed:@"CommentsButton.png"];
        double scale = 0.4f;
        CGFloat h = scale*imgComments.size.height;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, base.frame.size.height-h-10.0f-0.5f, base.frame.size.width, 1.0f)];
        line.backgroundColor = [UIColor lightGrayColor];
        [base addSubview:line];
        
        self.btnComments = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnComments.backgroundColor = [UIColor whiteColor];
        self.btnComments.frame = CGRectMake(0.0f, base.frame.size.height-h-10.0f, 0.5f*base.frame.size.width, 34.0f);
        [self.btnComments setTitle:@"0 comments" forState:UIControlStateNormal];
        self.btnComments.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.btnComments setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btnComments.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0f];
        [btnComments addTarget:self action:@selector(btnCommentsAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnComments setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        UIImageView *imgComment = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"commentbubble.png"]];
        scale = 34.0f/imgComment.frame.size.height;
        
        imgComment.frame = CGRectMake(0, -0.5f, scale*imgComment.frame.size.width, 35.0f);
        [self.btnComments addSubview:imgComment];
        [base addSubview:self.btnComments];

        
        self.btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnDelete.frame = CGRectMake(0.5f*base.frame.size.width, base.frame.size.height-h-10.0f, 0.5f*base.frame.size.width, 34.0f);
        self.btnDelete.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:18.0f];
        [self.btnDelete setBackgroundColor:kRed];
        [self.btnDelete setTitle:@"DELETE" forState:UIControlStateNormal];
        [self.btnDelete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnDelete addTarget:self action:@selector(btnDeleteAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [base addSubview:self.btnDelete];


        
        // Male / Female labels:
        CGFloat w = 45.0f;
        h = self.btnDelete.frame.size.height-8.0f;

        y = base.frame.size.height-h-kPadding-40.0f;
        self.lblMale = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, y, w, 15.0f)];
        self.lblMale.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        self.lblMale.text = @"Male";
        self.lblMale.font = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0f];
        self.lblMale.backgroundColor = [UIColor greenColor];
        self.lblMale.textColor = [UIColor colorWithRed:56.0f/255.0f green:62.0f/255.0f blue:64.0f/255.0f alpha:1.0f];
//        self.lblMale.alpha = 0;
        [base addSubview:self.lblMale];
        
        CGFloat x = w+kPadding;
        for (int i=0; i<self.colors.count; i++) {
            UILabel *pctView = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 0.0f, self.lblMale.frame.size.height)];
            pctView.backgroundColor = self.colors[i];
            pctView.textColor = [UIColor whiteColor];
            pctView.textAlignment = NSTextAlignmentLeft;
            pctView.font = [UIFont fontWithName:@"ProximaNova-Regular" size:10.0f];
            [base addSubview:pctView];
            [self.malePercentViews addObject:pctView];
        }
        
        y += self.lblMale.frame.size.height;

        
        self.lblFemale = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, y, w, 15.0f)];
        self.lblFemale.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        self.lblFemale.backgroundColor = [UIColor clearColor];
        self.lblFemale.font = self.lblMale.font;
        self.lblFemale.text = @"Female";
        self.lblFemale.textColor = self.lblMale.textColor;
//        self.lblFemale.alpha = 0;
        [base addSubview:self.lblFemale];

        
        for (int i=0; i<self.colors.count; i++) {
            UILabel *pctView = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 0.0f, self.lblFemale.frame.size.height)];
            pctView.backgroundColor = self.colors[i];
            pctView.textColor = [UIColor whiteColor];
            pctView.textAlignment = NSTextAlignmentLeft;
            pctView.font = [UIFont fontWithName:@"ProximaNova-Regular" size:10.0f];
            [base addSubview:pctView];
            [self.femalePercentViews addObject:pctView];
        }

        
        [self.contentView addSubview:base];
        
        
        
        
        
        
        
        
        
        
        
        
        
        x = frame.size.width-dimen-12.0f;
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
    frame.origin.y = 50.0f-self.detailTextLabel.frame.size.height;
    self.lblDetails.frame = frame;
}

- (void)btnCommentsAction:(UIButton *)btn
{
//    NSLog(@"btnCommentsAction:");
    [self.delegate viewComments:(int)self.tag];
}

- (void)btnDeleteAction:(UIButton *)btn
{
//    NSLog(@"btnDeleteAction:");
    [self.delegate deleteQuestion:(int)self.tag];
}



- (void)displayGenderPercents:(NSDictionary *)percents
{
    CGRect frame = [UIScreen mainScreen].applicationFrame;

    CGFloat x = 45.0f+kPadding;
    CGFloat fullWidth = frame.size.width-x-4*kPadding; // this is 100% width
    
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
        
        percentView.frame = frame;
        self.lblMale.alpha = 1;

        percentView.text = [NSString stringWithFormat:@"%.1f", (p*100)];
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
        
        percentView.frame = frame;
        self.lblFemale.alpha = 1;
        
        percentView.text = [NSString stringWithFormat:@"%.1f", (p*100)];
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
