//
//  SSQuestionView.m
//  SwingSet
//
//  Created by Denny Kwon on 1/21/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSQuestionView.h"

@implementation SSQuestionView
@synthesize headerView;
@synthesize imageView;
@synthesize lblQuestion;
@synthesize lblTimestamp;
@synthesize lblVotes;

@synthesize option1View;
@synthesize option2View;
@synthesize option3View;
@synthesize option4View;
@synthesize target;
@synthesize action;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight);

        self.backgroundColor = [UIColor clearColor];
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, 0.3f*frame.size.height)];
        self.headerView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight);
        self.headerView.backgroundColor = [UIColor yellowColor];
        
        CGFloat padding = 10.0f;
        CGFloat dimen = 100.0f;
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.headerView.frame.size.width-dimen-padding, padding, dimen, dimen)];
        self.imageView.backgroundColor = [UIColor redColor];
        [self.headerView addSubview:self.imageView];
        
        self.lblQuestion = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding, frame.size.width-dimen-3*padding, 30.0f)];
        self.lblQuestion.font = [UIFont fontWithName:@"ProximaNova-Bold" size:16.0f];
        self.lblQuestion.numberOfLines = 0;
        self.lblQuestion.lineBreakMode = NSLineBreakByWordWrapping;
        self.lblQuestion.textColor = [UIColor whiteColor];
        self.lblQuestion.backgroundColor = [UIColor grayColor];
        [self.headerView addSubview:self.lblQuestion];
        
        static CGFloat h = 20.0f;
        self.lblTimestamp = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.headerView.frame.size.height-h, 0.5f*self.headerView.frame.size.width, h)];
        self.lblTimestamp.backgroundColor = [UIColor blackColor];
        self.lblTimestamp.textColor = [UIColor whiteColor];
        self.lblTimestamp.text = @"1 Day";
        [self.headerView addSubview:self.lblTimestamp];

        self.lblVotes = [[UILabel alloc] initWithFrame:CGRectMake(self.lblTimestamp.frame.size.width, self.headerView.frame.size.height-h, 0.5f*self.headerView.frame.size.width, h)];
        self.lblVotes.textAlignment = NSTextAlignmentRight;
        self.lblVotes.backgroundColor = [UIColor blackColor];
        self.lblVotes.textColor = [UIColor whiteColor];
        self.lblVotes.text = @"1 Votes";
        [self.headerView addSubview:self.lblVotes];

        
        [self addSubview:self.headerView];
        
        CGFloat y = self.headerView.frame.size.height+padding;
        h = 44.0f;
        CGFloat w = frame.size.width-2*padding;
        
        self.option1View = [SSOptionView optionViewWithFrame:CGRectMake(padding, y, w, h)];
        self.option1View.tag = 1000;
        self.option1View.barColor = [UIColor blueColor];
        self.option1View.parent = self;
        [self addSubview:self.option1View];
        y += h+padding;
        
        self.option2View = [SSOptionView optionViewWithFrame:CGRectMake(padding, y, w, h)];
        self.option2View.tag = 1001;
        self.option2View.parent = self;
        self.option2View.barColor = [UIColor redColor];
        [self addSubview:self.option2View];
        y += h+padding;

        self.option3View = [SSOptionView optionViewWithFrame:CGRectMake(padding, y, w, h)];
        self.option3View.tag = 1002;
        self.option3View.parent = self;
        self.option3View.barColor = [UIColor blackColor];
        [self addSubview:self.option3View];
        y += h+padding;

        self.option4View = [SSOptionView optionViewWithFrame:CGRectMake(padding, y, w, h)];
        self.option4View.tag = 1003;
        self.option4View.parent = self;
        self.option4View.barColor = [UIColor greenColor];
        [self addSubview:self.option4View];

    }
    return self;
}

- (void)addTarget:(id)t forAction:(SEL)a
{
    self.target = t;
    self.action = a;
}


#pragma mark - SSOptionViewDelegate
- (void)optionViewSelected:(NSInteger)tag
{
    NSLog(@"optionViewSelected: %d", (int)tag);
    if (!self.target)
        return;
    
    [self.target performSelector:self.action
                      withObject:[NSNumber numberWithLong:tag]
                      afterDelay:0];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
