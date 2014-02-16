//
//  SSQuestionPreview.h
//  SwingSet
//
//  Created by Denny Kwon on 1/26/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSOptionIcon.h"

@protocol SSQuestionPreviewDelegate <NSObject>
- (void)checkPostion;
- (void)viewComments;
- (void)optionSelected:(NSInteger)tag;
- (void)skip;
@end

@interface SSQuestionPreview : UIView

@property (assign) id delegate;
@property (strong, nonatomic) UILabel *lblText;
@property (strong, nonatomic) UILabel *lblDate;
@property (strong, nonatomic) UILabel *lblVotes;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *btnComments;
@property (strong, nonatomic) NSMutableArray *optionsViews;
@property (strong, nonatomic) NSMutableArray *optionsImageViews;
@property (strong, nonatomic) NSMutableArray *malePercentViews;
@property (strong, nonatomic) NSMutableArray *femalePercentViews;
@property (nonatomic) BOOL isMovable;
- (void)displayGenderPercents:(NSDictionary *)percents;
- (void)reset;
@end
