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
@property (copy, nonatomic) NSString *imageId;
@property (strong, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *answerType; // 'text' or 'image'
@property (strong, nonatomic) NSMutableArray *votes;
@property (strong, nonatomic) NSMutableArray *comments;
@property (strong, nonatomic) NSMutableArray *options;
@property (strong, nonatomic) NSDate *timestamp;
@property (nonatomic) int totalMaleVotes;
@property (nonatomic) int totalFemaleVotes;
@property (nonatomic) int imagesCount;
+ (SSQuestion *)questionWithInfo:(NSDictionary *)info;
- (void)populate:(NSDictionary *)info;
- (void)addVote:(int)index;
- (NSMutableDictionary *)parametersDictionary;
@end
