//
//  SSResultCell.m
//  SwingSet
//
//  Created by Denny Kwon on 2/13/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSResultCell.h"
#import "Config.h"

@implementation SSResultCell
@synthesize icon;
@synthesize lblText;
@synthesize lblDetails;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect frame = [UIScreen mainScreen].applicationFrame;
        
        self.backgroundColor = kGrayTable;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat dimen = 60.0f;
        CGFloat padding = 5.0f;
        
        self.lblText = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding, frame.size.width-dimen-2*padding, 30.0f)];
        self.lblText.font = [UIFont fontWithName:@"ProximaNova-Black" size:14.0];
        self.lblText.textColor = kLightBlue;
        self.lblText.numberOfLines = 0;
        self.lblText.lineBreakMode = NSLineBreakByWordWrapping;
        [self.lblText addObserver:self forKeyPath:@"text" options:0 context:nil];
        [self.contentView addSubview:self.lblText];

        CGFloat y = self.lblText.frame.origin.y+self.lblText.frame.size.height;
        self.lblDetails = [[UILabel alloc] initWithFrame:CGRectMake(padding, y, self.lblText.frame.size.width, 16.0f)];
        self.lblDetails.font = [UIFont fontWithName:@"ProximaNova-RegularIt" size:12.0f];
        self.lblDetails.textColor = kGreenNext;
        [self.contentView addSubview:self.lblDetails];
        
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-dimen-padding, padding, dimen, dimen)];
        self.icon.backgroundColor = [UIColor clearColor];
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
    frame.origin.y = self.lblText.frame.origin.y+self.lblText.frame.size.height+5.0f;
    self.lblDetails.frame = frame;

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
