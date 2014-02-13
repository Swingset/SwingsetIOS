//
//  SSResultCell.h
//  SwingSet
//
//  Created by Denny Kwon on 2/13/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSResultCell : UITableViewCell


@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UIView *iconBase;
@property (strong, nonatomic) UILabel *lblText;
@property (strong, nonatomic) UILabel *lblDetails;
+ (CGFloat)standardHeight;
@end
