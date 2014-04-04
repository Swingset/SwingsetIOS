//
//  SSTableCell.m
//  SwingSet
//
//  Created by Denny Kwon on 1/21/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSTableCell.h"

@implementation SSTableCell
@synthesize lblBadge;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor darkGrayColor];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:20.0f];
        
        CGRect appFrame = [UIScreen mainScreen].applicationFrame;
        self.lblBadge = [[UILabel alloc] initWithFrame:CGRectMake(0.68f*appFrame.size.width, 9.0f, 24.0f, 24.0f)];
        self.lblBadge.font = [UIFont fontWithName:@"ProximaNova-Regular" size:14.0f];
        self.lblBadge.textColor = [UIColor whiteColor];
        self.lblBadge.textAlignment = NSTextAlignmentCenter;
        self.lblBadge.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"redDot.png"]];
        self.lblBadge.alpha = 0;
        [self.contentView addSubview:self.lblBadge];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
