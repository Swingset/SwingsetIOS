//
//  SSQuestionView.h
//  SwingSet
//
//  Created by Denny Kwon on 1/21/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSOptionView.h"

@interface SSQuestionView : UIView


@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *lblQuestion;
@property (strong, nonatomic) UILabel *lblTimestamp;
@property (strong, nonatomic) UILabel *lblVotes;

@property (strong, nonatomic) SSOptionView *option1View;
@property (strong, nonatomic) SSOptionView *option2View;
@property (strong, nonatomic) SSOptionView *option3View;
@property (strong, nonatomic) SSOptionView *option4View;
@property (assign) id target;
@property (nonatomic) SEL action;

- (void)addTarget:(id)t forAction:(SEL)a;
@end
