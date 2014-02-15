//
//  SSCommentsViewController.h
//  SwingSet
//
//  Created by Denny Kwon on 2/14/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSViewController.h"

@interface SSCommentsViewController : SSViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) SSQuestion *question;
@end
