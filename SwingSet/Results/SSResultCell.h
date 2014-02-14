//
//  SSResultCell.h
//  SwingSet
//
//  Created by Denny Kwon on 2/13/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSOptionIcon.h"

@interface SSResultCell : UITableViewCell


@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UIView *iconBase;
@property (strong, nonatomic) UILabel *lblText;
@property (strong, nonatomic) UILabel *lblDetails;
@property (strong, nonatomic) NSMutableArray *optionViews;
@property (strong, nonatomic) NSMutableArray *optionsImageViews;
@property (strong, nonatomic) UIButton *btnComments;
@property (strong, nonatomic) UIButton *btnDelete;
+ (CGFloat)standardHeight;
@end
