//
//  SSQuestionPreview.h
//  SwingSet
//
//  Created by Denny Kwon on 1/26/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSQuestionPreviewDelegate <NSObject>
- (void)checkPostion;
- (void)viewComments;
@end

@interface SSQuestionPreview : UIView

@property (assign) id delegate;
@property (strong, nonatomic) UILabel *lblText;
@property (strong, nonatomic) UILabel *lblDate;
@property (strong, nonatomic) UILabel *lblVotes;
@property (strong, nonatomic) UIImageView *imageView;
@end
