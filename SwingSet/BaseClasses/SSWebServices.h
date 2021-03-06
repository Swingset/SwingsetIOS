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
#import "SSGroup.h"


typedef void (^SSWebServiceRequestCompletionBlock)(id result, NSError *error);

@interface SSWebServices : NSObject

@property (nonatomic) BOOL online;
+ (SSWebServices *)sharedInstance;
- (void)confirmPIN:(NSDictionary *)pkg completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock;
- (void)submitVote:(SSProfile *)profile withQuestion:(SSQuestion *)question withSelection:(long)index completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock;
- (void)login:(NSDictionary *)pkg completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock;
- (void)forgotPassword:(NSDictionary *)pkg completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock;


// Images:
- (void)fetchUploadString:(int)count completion:(SSWebServiceRequestCompletionBlock)completionBlock;
- (void)uploadImage:(NSDictionary *)image toUrl:(NSString *)uploadUrl completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock;
- (void)fetchImage:(NSString *)imageId completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock;


// Profile
- (void)fetchProfileInfo:(SSWebServiceRequestCompletionBlock)completionBlock;
- (void)registerProfile:(SSProfile *)profile completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock;
- (void)updateProfile:(SSProfile *)profile completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock;


// Groups
- (void)fetchGroupInfo:(SSGroup *)group completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock;
- (void)createGroup:(NSDictionary *)group completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock;
- (void)inviteMembers:(NSArray *)invitees toGroup:(SSGroup *)group completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock;
- (void)joinGroup:(NSString *)groupName withPin:(NSString *)pin completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock;
- (void)removeMember:(NSString *)memberId fromGroup:(SSGroup *)group completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock;

// Questions
- (void)submitQuestion:(SSQuestion *)question completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock;
- (void)fetchPublicQuestions:(SSWebServiceRequestCompletionBlock)completionBlock;
- (void)fetchQuestionsInGroup:(NSString *)groupId completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock;
- (void)postComment:(NSDictionary *)comment completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock;
- (void)deleteQuestion:(SSQuestion *)question completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock;

@end
