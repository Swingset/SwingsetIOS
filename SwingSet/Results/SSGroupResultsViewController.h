//
//  SSGroupResultsViewController.h
//  SwingSet
//
//  Created by Denny Kwon on 2/13/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSViewController.h"
#import "SSGroup.h"

@interface SSGroupResultsViewController : SSViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) SSGroup *group;
@property (nonatomic) BOOL canGoBack;
@end
