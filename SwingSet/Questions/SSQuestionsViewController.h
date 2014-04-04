//
//  SSQuestionsViewController.h
//  SwingSet
//
//  Created by Denny Kwon on 1/26/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSViewController.h"
#import "SSGroup.h"

@interface SSQuestionsViewController : SSViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) SSQuestion *currentQuestion;
@property (strong, nonatomic) SSGroup *group;
@property (strong, nonatomic) NSMutableArray *questions;
@end
