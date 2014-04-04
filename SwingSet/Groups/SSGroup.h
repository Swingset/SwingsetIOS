//
//  SSGroup.h
//  SwingSet
//
//  Created by Denny Kwon on 4/4/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSGroup : NSObject


@property (copy, nonatomic) NSString *groupId;
@property (copy, nonatomic) NSThread *name;
@property (copy, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSArray *members;
@property (strong, nonatomic) NSMutableArray *questions;
@property (nonatomic) BOOL isPublic;
- (void)populate:(NSDictionary *)info;
+ (SSGroup *)groupWithInfo:(NSDictionary *)info;
@end
