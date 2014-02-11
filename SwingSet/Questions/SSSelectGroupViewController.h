//
//  SSSelectGroupViewController.h
//  SwingSet
//
//  Created by Denny Kwon on 2/11/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSViewController.h"

@interface SSSelectGroupViewController : SSViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) SSQuestion *question;
@end
