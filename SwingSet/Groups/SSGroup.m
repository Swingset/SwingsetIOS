//
//  SSGroup.m
//  SwingSet
//
//  Created by Denny Kwon on 4/4/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSGroup.h"
#import "SSWebServices.h"
#import "SSProfile.h"

@implementation SSGroup
@synthesize groupId;
@synthesize name;
@synthesize displayName;
@synthesize members;
@synthesize questions;
@synthesize isPublic;
@synthesize unansweredQuestionsCount;

- (id)init
{
    self = [super init];
    if (self){
        self.questions = [NSMutableArray array];
        self.isPublic = NO;
        self.unansweredQuestionsCount = 0;
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
//    NSLog(@"POPULATE GROUP: %@", [info description]);
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

- (void)fetchQuestions
{
    [[SSWebServices sharedInstance] fetchQuestionsInGroup:self.groupId completionBlock:^(id result, NSError *error){
        if (error){
            NSLog(@"FETCH QUESTIONS: Error - %@", [error localizedDescription]);
            return;
        }
        
        NSDictionary *results = (NSDictionary *)result;
        if ([results[@"confirmation"] isEqualToString:@"success"]==YES){
            NSLog(@"FETCH QUESTIONS: Process Questions - %@", [results description]);
            self.unansweredQuestionsCount = 0;
            SSProfile *profile = [SSProfile sharedProfile];
            
            NSMutableArray *groupQuestions = [NSMutableArray array];
            NSArray *q = result[@"questions"];
            for (int i=0; i<q.count; i++) {
                SSQuestion *question = [SSQuestion questionWithInfo:q[i]];
                [groupQuestions addObject:question];
                if ([question.votes containsObject:profile.uniqueId]==NO)
                    self.unansweredQuestionsCount++;
            }
            
            self.questions = groupQuestions;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GroupQuestionsReady" object:nil];
            
        }
        else
            NSLog(@"FETCH QUESTIONS: Error - %@", [error localizedDescription]);
    }];

}

@end
