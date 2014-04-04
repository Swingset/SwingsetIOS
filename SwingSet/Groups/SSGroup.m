//
//  SSGroup.m
//  SwingSet
//
//  Created by Denny Kwon on 4/4/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSGroup.h"

@implementation SSGroup
@synthesize groupId;
@synthesize name;
@synthesize displayName;
@synthesize members;
@synthesize questions;
@synthesize isPublic;

- (id)init
{
    self = [super init];
    if (self){
        self.questions = [NSMutableArray array];
        self.isPublic = NO;
    }
    return self;
}

+ (SSGroup *)groupWithInfo:(NSDictionary *)info
{
    SSGroup *group = [[SSGroup alloc] init];
    [group populate:info];
    return group;
}


- (void)populate:(NSDictionary *)info
{
    NSLog(@"POPULATE GROUP: %@", [info description]);
    for (NSString *key in info.allKeys) {
        
        if ([key isEqualToString:@"id"])
            self.groupId = [info objectForKey:key];

        if ([key isEqualToString:@"members"])
            self.members = [info objectForKey:key];

        if ([key isEqualToString:@"name"])
            self.name = [info objectForKey:key];

        if ([key isEqualToString:@"displayName"])
            self.displayName = [info objectForKey:key];

        if ([key isEqualToString:@"isPublic"]){
            NSString *public = [info objectForKey:key];
            self.isPublic = [public isEqualToString:@"yes"];
        }
    }
    
    
}

@end
