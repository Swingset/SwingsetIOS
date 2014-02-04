//
//  SSGroupViewController.h
//  SwingSet
//
//  Created by Denny Kwon on 1/26/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSViewController.h"

@interface SSGroupViewController : SSViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSDictionary *group;
@end
