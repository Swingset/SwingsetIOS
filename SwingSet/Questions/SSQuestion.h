//
//  SSQuestion.h
//  SwingSet
//
//  Created by Denny Kwon on 1/21/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSQuestion : NSObject

@property (copy, nonatomic) NSString *uniqueId;
@property (copy, nonatomic) NSString *group; // groupId or 'public'
@property (copy, nonatomic) NSString *text;
@property (copy, nonatomic) NSString *author;
@property (copy, nonatomic) NSString *image;
@property (strong, nonatomic) NSMutableArray *votes;
@property (strong, nonatomic) NSMutableArray *options;
@property (strong, nonatomic) NSDate *timestamp;
@property (nonatomic) int totalMaleVotes;
@property (nonatomic) int totalFemaleVotes;
+ (SSQuestion *)questionWithInfo:(NSDictionary *)info;
- (void)populate:(NSDictionary *)info;
- (void)addVote:(int)index;
@end
