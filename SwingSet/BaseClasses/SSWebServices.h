//
//  SSWebServices.h
//  SwingSet
//
//  Created by Denny Kwon on 1/19/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSProfile.h"
#import "SSQuestion.h"

typedef void (^SSWebServiceRequestCompletionBlock)(id result, NSError *error);

@interface SSWebServices : NSObject

@property (nonatomic) BOOL online;
+ (SSWebServices *)sharedInstance;
- (void)registerProfile:(SSProfile *)profile completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock;
- (void)confirmPIN:(NSDictionary *)pkg completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock;
- (void)fetchPublicQuestions:(SSWebServiceRequestCompletionBlock)completionBlock;
- (void)createGroup:(NSDictionary *)group completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock;
- (void)submitVote:(SSProfile *)profile withQuestion:(SSQuestion *)question withSelection:(long)index completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock;
@end
