//
//  SSTableCell.m
//  SwingSet
//
//  Created by Denny Kwon on 1/21/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSTableCell.h"

@implementation SSTableCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.imageView];
        self.contentView.backgroundColor = [UIColor darkGrayColor];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:20.0f];
        self.imageView.bounds = CGRectMake(0,0,5,5);
        self.imageView.frame = CGRectMake(0,0,5,5);
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.bounds = CGRectMake(10,10,20,20);
    self.imageView.frame = CGRectMake(10,10,20,20);
    CGRect textlabelFrame = self.textLabel.frame;
    textlabelFrame.size.width = textlabelFrame.size.width + textlabelFrame.origin.x - 40;
    textlabelFrame.origin.x = 40;
    self.textLabel.frame = textlabelFrame;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    separatorLineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hb_bg_grey01.png"]];//replace with image
    [self.contentView addSubview:separatorLineView];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
