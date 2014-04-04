//
//  SSInviteMembersViewController.h
//  SwingSet
//
//  Created by Denny Kwon on 2/3/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSViewController.h"
#import "SSGroup.h"

@interface SSInviteMembersViewController : SSViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) SSGroup *group;
@end
