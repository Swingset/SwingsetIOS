//
//  SSProfile.h
//  SwingSet
//
//  Created by Denny Kwon on 1/19/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSProfile : NSObject


@property (copy, nonatomic) NSString *uniqueId;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *sex;
@property (copy, nonatomic) NSString *pw;
@property (copy, nonatomic) NSString *deviceToken;
@property (strong, nonatomic) NSMutableArray *groups;
@property (nonatomic) BOOL confirmed;
@property (nonatomic) BOOL populated;
+ (SSProfile *)sharedProfile;
- (NSString *)jsonRepresentation;
- (NSDictionary *)parametersDictionary;
- (void)populate:(NSDictionary *)info;
- (void)removeGroup:(NSDictionary *)groupInfo;
- (void)updateProfile;
- (void)clear;
@end
