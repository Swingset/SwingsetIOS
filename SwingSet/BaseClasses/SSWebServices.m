//
//  SSWebServices.m
//  SwingSet
//
//  Created by Denny Kwon on 1/19/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSWebServices.h"
#import "AFNetworking.h"
#import "SignalCheck.h"
#include <sys/xattr.h>


@implementation SSWebServices
@synthesize online;


#define kBaseUrl @"http://swingsetlabs.appspot.com/"
#define kSecureBaseUrl @"https://swingsetlabs.appspot.com/"
//#define kSecureBaseUrl @"http://localhost:8888/"
#define kPathProfiles @"/api/profiles/"
#define kPathImages @"/site/images/"
#define kPathQuestions @"/api/questions/"
#define kPathResponses @"/api/responses/"
#define kPathGroups @"/api/groups/"
#define kPathUpload @"/api/upload/"
#define kPathImages @"/site/images/"
#define kPathComments @"/api/comments/"


+ (SSWebServices *)sharedInstance
{
    static SSWebServices *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        shared = [[SSWebServices alloc] init];
        
    });
    
    return shared;
}

- (void)registerProfile:(SSProfile *)profile completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock
{
    SignalCheck *signalCheck = [SignalCheck signalWithDelegate:self];
    if (![signalCheck checkSignal]){
        NSDictionary *results = @{@"confirmation":@"fail", @"message":@"No Connection. Please find an internet connection."};
        if (completionBlock)
            completionBlock(results, nil);
        
        return;
    }
    
    
    NSLog(@"registerProfile: %@", [profile parametersDictionary]);
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kSecureBaseUrl]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [httpClient postPath:kPathProfiles
              parameters:[profile parametersDictionary]
                 success:^(AFHTTPRequestOperation *operation, id responseObject){
                     NSError *error = nil;
                     NSDictionary *responseDictionary = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                       options:NSJSONReadingMutableContainers
                                                                                                         error:&error];
                     
                     if (error){
                         NSLog(@"SUCCESS BLOCK: ERROR - %@", [error localizedDescription]);
                     }
                     else{
//                         NSLog(@"SUCCESS BLOCK: %@", [responseDictionary description]);
                         NSDictionary *results = [responseDictionary objectForKey:@"results"];
                         NSString *confirmation = [results objectForKey:@"confirmation"];
                         
                         if ([confirmation isEqualToString:@"success"]){ // profile successfully registered
                             if (completionBlock)
                                 completionBlock(results, error);
                         }
                         else{ // registration failed.
                             if (completionBlock)
                                 completionBlock(results, nil);
                         }
                     }
                 }
     
                 failure:^(AFHTTPRequestOperation *operation, NSError *error){
                     NSLog(@"FAILURE BLOCK: %@", [error localizedDescription]);
                     if (completionBlock)
                         completionBlock(nil, error);
                 }];
}

- (void)updateProfile:(SSProfile *)profile completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock
{
    SignalCheck *signalCheck = [SignalCheck signalWithDelegate:self];
    if (![signalCheck checkSignal]){
        NSDictionary *results = @{@"confirmation":@"fail", @"message":@"No Connection. Please find an internet connection."};
        if (completionBlock)
            completionBlock(results, nil);
        
        return;
    }

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kSecureBaseUrl]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [httpClient putPath:[kPathProfiles stringByAppendingString:profile.uniqueId]
              parameters:[profile parametersDictionary]
                 success:^(AFHTTPRequestOperation *operation, id responseObject){
                     NSError *error = nil;
                     NSDictionary *responseDictionary = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                       options:NSJSONReadingMutableContainers
                                                                                                         error:&error];
                     
                     if (error){
                         NSLog(@"SUCCESS BLOCK: ERROR - %@", [error localizedDescription]);
                     }
                     else{
                         //                         NSLog(@"SUCCESS BLOCK: %@", [responseDictionary description]);
                         NSDictionary *results = [responseDictionary objectForKey:@"results"];
                         NSString *confirmation = [results objectForKey:@"confirmation"];
                         
                         if ([confirmation isEqualToString:@"success"]){ // profile successfully registered
                             if (completionBlock)
                                 completionBlock(results, error);
                         }
                         else{ // registration failed.
                             if (completionBlock)
                                 completionBlock(results, nil);
                         }
                     }
                 }
     
                 failure:^(AFHTTPRequestOperation *operation, NSError *error){
                     NSLog(@"FAILURE BLOCK: %@", [error localizedDescription]);
                     if (completionBlock)
                         completionBlock(nil, error);
                 }];
}


- (void)confirmPIN:(NSDictionary *)pkg completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock
{
    SignalCheck *signalCheck = [SignalCheck signalWithDelegate:self];
    if (![signalCheck checkSignal]){
        NSDictionary *results = @{@"confirmation":@"fail", @"message":@"No Connection. Please find an internet connection."};
        if (completionBlock)
            completionBlock(results, nil);
        
        return;
    }

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kSecureBaseUrl]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];

    [httpClient postPath:@"/api/confirm/"
              parameters:pkg
                 success:^(AFHTTPRequestOperation *operation, id responseObject){
                     NSError *error = nil;
                     NSDictionary *responseDictionary = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                       options:NSJSONReadingMutableContainers
                                                                                                         error:&error];
                     
                     if (error){
                         NSLog(@"SUCCESS BLOCK: ERROR - %@", [error localizedDescription]);
                     }
                     else{
                         //NSLog(@"SUCCESS BLOCK: %@", [responseDictionary description]);
                         NSDictionary *results = [responseDictionary objectForKey:@"results"];
                         NSString *confirmation = [results objectForKey:@"confirmation"];
                         
                         if ([confirmation isEqualToString:@"success"]){ // profile successfully registered
                             if (completionBlock)
                                 completionBlock(results, error);
                         }
                         else{
                             if (completionBlock)
                                 completionBlock(results, nil);
                         }
                     }
                 }
     
                 failure:^(AFHTTPRequestOperation *operation, NSError *error){
                     NSLog(@"FAILURE BLOCK: %@", [error localizedDescription]);
                     if (completionBlock)
                         completionBlock(nil, error);
                 }];
}

- (void)login:(NSDictionary *)pkg completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock
{
    SignalCheck *signalCheck = [SignalCheck signalWithDelegate:self];
    if (![signalCheck checkSignal]){
        NSDictionary *results = @{@"confirmation":@"fail", @"message":@"No Connection. Please find an internet connection."};
        if (completionBlock)
            completionBlock(results, nil);
        
        return;
    }

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kSecureBaseUrl]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [httpClient postPath:@"/api/login/"
              parameters:pkg
                 success:^(AFHTTPRequestOperation *operation, id responseObject){
                     NSError *error = nil;
                     NSDictionary *responseDictionary = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                       options:NSJSONReadingMutableContainers
                                                                                                         error:&error];
                     
                     if (error){
                         NSLog(@"SUCCESS BLOCK: ERROR - %@", [error localizedDescription]);
                     }
                     else{
                         //NSLog(@"SUCCESS BLOCK: %@", [responseDictionary description]);
                         NSDictionary *results = [responseDictionary objectForKey:@"results"];
                         NSString *confirmation = [results objectForKey:@"confirmation"];
                         
                         if ([confirmation isEqualToString:@"success"]){ // profile successfully registered
                             if (completionBlock)
                                 completionBlock(results, error);
                         }
                         else{
                             if (completionBlock)
                                 completionBlock(results, nil);
                         }
                     }
                 }
     
                 failure:^(AFHTTPRequestOperation *operation, NSError *error){
                     NSLog(@"FAILURE BLOCK: %@", [error localizedDescription]);
                     if (completionBlock)
                         completionBlock(nil, error);
                 }];
}

- (void)forgotPassword:(NSDictionary *)pkg completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock
{
    SignalCheck *signalCheck = [SignalCheck signalWithDelegate:self];
    if (![signalCheck checkSignal]){
        NSDictionary *results = @{@"confirmation":@"fail", @"message":@"No Connection. Please find an internet connection."};
        if (completionBlock)
            completionBlock(results, nil);
        
        return;
    }

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kSecureBaseUrl]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [httpClient postPath:@"/api/newpassword/"
              parameters:pkg
                 success:^(AFHTTPRequestOperation *operation, id responseObject){
                     NSError *error = nil;
                     NSDictionary *responseDictionary = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                       options:NSJSONReadingMutableContainers
                                                                                                         error:&error];
                     
                     if (error){
                         NSLog(@"SUCCESS BLOCK: ERROR - %@", [error localizedDescription]);
                     }
                     else{
                         //NSLog(@"SUCCESS BLOCK: %@", [responseDictionary description]);
                         NSDictionary *results = [responseDictionary objectForKey:@"results"];
                         NSString *confirmation = [results objectForKey:@"confirmation"];
                         
                         if ([confirmation isEqualToString:@"success"]){ // profile successfully registered
                             if (completionBlock)
                                 completionBlock(results, error);
                         }
                         else{
                             if (completionBlock)
                                 completionBlock(results, nil);
                         }
                     }
                 }
     
                 failure:^(AFHTTPRequestOperation *operation, NSError *error){
                     NSLog(@"FAILURE BLOCK: %@", [error localizedDescription]);
                     if (completionBlock)
                         completionBlock(nil, error);
                 }];
}



- (void)fetchPublicQuestions:(SSWebServiceRequestCompletionBlock)completionBlock
{
    SignalCheck *signalCheck = [SignalCheck signalWithDelegate:self];
    if (![signalCheck checkSignal]){
        NSDictionary *results = @{@"confirmation":@"fail", @"message":@"No Connection. Please find an internet connection."};
        if (completionBlock)
            completionBlock(results, nil);
        
        return;
    }

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    [httpClient getPath:kPathQuestions
              parameters:nil
                 success:^(AFHTTPRequestOperation *operation, id responseObject){
                     NSError *error = nil;
                     NSDictionary *responseDictionary = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                       options:NSJSONReadingMutableContainers
                                                                                                         error:&error];
                     
                     if (error){
                         NSLog(@"SUCCESS BLOCK: ERROR - %@", [error localizedDescription]);
                     }
                     else{
                         //NSLog(@"SUCCESS BLOCK: %@", [responseDictionary description]);
                         NSDictionary *results = [responseDictionary objectForKey:@"results"];
                         NSString *confirmation = [results objectForKey:@"confirmation"];
                         
                         if ([confirmation isEqualToString:@"success"]){ // profile successfully registered
                             if (completionBlock)
                                 completionBlock(results, error);
                         }
                         else{ // registration failed.
                             if (completionBlock)
                                 completionBlock(results, nil);
                         }
                     }
                 }
     
                 failure:^(AFHTTPRequestOperation *operation, NSError *error){
                     NSLog(@"FAILURE BLOCK: %@", [error localizedDescription]);
                     if (completionBlock)
                         completionBlock(nil, error);
                 }];
}


- (void)fetchQuestionsInGroup:(NSString *)groupId completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock
{
    SignalCheck *signalCheck = [SignalCheck signalWithDelegate:self];
    if (![signalCheck checkSignal]){
        NSDictionary *results = @{@"confirmation":@"fail", @"message":@"No Connection. Please find an internet connection."};
        if (completionBlock)
            completionBlock(results, nil);
        
        return;
    }

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    [httpClient getPath:kPathQuestions
             parameters:@{@"group":groupId}
                success:^(AFHTTPRequestOperation *operation, id responseObject){
                    NSError *error = nil;
                    NSDictionary *responseDictionary = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                      options:NSJSONReadingMutableContainers
                                                                                                        error:&error];
                    
                    if (error){
                        NSLog(@"SUCCESS BLOCK: ERROR - %@", [error localizedDescription]);
                    }
                    else{
                        //NSLog(@"SUCCESS BLOCK: %@", [responseDictionary description]);
                        NSDictionary *results = [responseDictionary objectForKey:@"results"];
                        NSString *confirmation = [results objectForKey:@"confirmation"];
                        
                        if ([confirmation isEqualToString:@"success"]){ // profile successfully registered
                            if (completionBlock)
                                completionBlock(results, error);
                        }
                        else{ // registration failed.
                            if (completionBlock)
                                completionBlock(results, nil);
                        }
                    }
                }
     
                failure:^(AFHTTPRequestOperation *operation, NSError *error){
                    NSLog(@"FAILURE BLOCK: %@", [error localizedDescription]);
                    if (completionBlock)
                        completionBlock(nil, error);
                }];
}


- (void)submitVote:(SSProfile *)profile withQuestion:(SSQuestion *)question withSelection:(long)index completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock
{
    SignalCheck *signalCheck = [SignalCheck signalWithDelegate:self];
    if (![signalCheck checkSignal]){
        NSDictionary *results = @{@"confirmation":@"fail", @"message":@"No Connection. Please find an internet connection."};
        if (completionBlock)
            completionBlock(results, nil);
        
        return;
    }

    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kSecureBaseUrl]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    NSDictionary *params = @{@"profile":profile.uniqueId, @"question":question.uniqueId, @"selection":[NSString stringWithFormat:@"%lu", index]};
    
    [httpClient postPath:kPathResponses
              parameters:params
                 success:^(AFHTTPRequestOperation *operation, id responseObject){
                     NSError *error = nil;
                     NSDictionary *responseDictionary = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                       options:NSJSONReadingMutableContainers
                                                                                                         error:&error];
                     
                     if (error){
                         NSLog(@"SUCCESS BLOCK: ERROR - %@", [error localizedDescription]);
                     }
                     else{
                         //                         NSLog(@"SUCCESS BLOCK: %@", [responseDictionary description]);
                         NSDictionary *results = [responseDictionary objectForKey:@"results"];
                         NSString *confirmation = [results objectForKey:@"confirmation"];
                         
                         if ([confirmation isEqualToString:@"success"]){ // profile successfully registered
                             if (completionBlock)
                                 completionBlock(results, error);
                         }
                         else{
                             if (completionBlock)
                                 completionBlock(results, nil);
                         }
                     }
                 }
     
                 failure:^(AFHTTPRequestOperation *operation, NSError *error){
                     NSLog(@"FAILURE BLOCK: %@", [error localizedDescription]);
                     if (completionBlock)
                         completionBlock(nil, error);
                 }];
    
}

- (void)createGroup:(NSDictionary *)group completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock
{
    SignalCheck *signalCheck = [SignalCheck signalWithDelegate:self];
    if (![signalCheck checkSignal]){
        NSDictionary *results = @{@"confirmation":@"fail", @"message":@"No Connection. Please find an internet connection."};
        if (completionBlock)
            completionBlock(results, nil);
        
        return;
    }

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kSecureBaseUrl]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:group];
    SSProfile *profile = [SSProfile sharedProfile];
    params[@"profile"] = profile.uniqueId;

    [httpClient postPath:kPathGroups
              parameters:params
                 success:^(AFHTTPRequestOperation *operation, id responseObject){
                     NSError *error = nil;
                     NSDictionary *responseDictionary = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                       options:NSJSONReadingMutableContainers
                                                                                                         error:&error];
                     
                     if (error){
                         NSLog(@"SUCCESS BLOCK: ERROR - %@", [error localizedDescription]);
                     }
                     else{
                         //                         NSLog(@"SUCCESS BLOCK: %@", [responseDictionary description]);
                         NSDictionary *results = [responseDictionary objectForKey:@"results"];
                         NSString *confirmation = [results objectForKey:@"confirmation"];
                         
                         if ([confirmation isEqualToString:@"success"]){ // profile successfully registered
                             if (completionBlock)
                                 completionBlock(results, error);
                         }
                         else{ // registration failed.
                             if (completionBlock)
                                 completionBlock(results, nil);
                         }
                     }
                 }
     
                 failure:^(AFHTTPRequestOperation *operation, NSError *error){
                     NSLog(@"FAILURE BLOCK: %@", [error localizedDescription]);
                     if (completionBlock)
                         completionBlock(nil, error);
                 }];
}

- (void)fetchProfileInfo:(SSWebServiceRequestCompletionBlock)completionBlock
{
    SignalCheck *signalCheck = [SignalCheck signalWithDelegate:self];
    if (![signalCheck checkSignal]){
        NSDictionary *results = @{@"confirmation":@"fail", @"message":@"No Connection. Please find an internet connection."};
        if (completionBlock)
            completionBlock(results, nil);
        
        return;
    }

    SSProfile *profile = [SSProfile sharedProfile];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    
    [httpClient getPath:[kPathProfiles stringByAppendingString:profile.uniqueId]
             parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject){
                    NSError *error = nil;
                    NSDictionary *responseDictionary = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                      options:NSJSONReadingMutableContainers
                                                                                                        error:&error];
                    
                    if (error){
                        NSLog(@"SUCCESS BLOCK: ERROR - %@", [error localizedDescription]);
                    }
                    else{
                        //NSLog(@"SUCCESS BLOCK: %@", [responseDictionary description]);
                        NSDictionary *results = [responseDictionary objectForKey:@"results"];
                        NSString *confirmation = [results objectForKey:@"confirmation"];
                        
                        if ([confirmation isEqualToString:@"success"]){ // profile successfully registered
                            if (completionBlock)
                                completionBlock(results, error);
                        }
                        else{ // registration failed.
                            if (completionBlock)
                                completionBlock(results, nil);
                        }
                    }
                }
     
                failure:^(AFHTTPRequestOperation *operation, NSError *error){
                    NSLog(@"FAILURE BLOCK: %@", [error localizedDescription]);
                    if (completionBlock)
                        completionBlock(nil, error);
                }];
}


- (void)inviteMembers:(NSArray *)invitees toGroup:(SSGroup *)group completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock
{
    SignalCheck *signalCheck = [SignalCheck signalWithDelegate:self];
    if (![signalCheck checkSignal]){
        NSDictionary *results = @{@"confirmation":@"fail", @"message":@"No Connection. Please find an internet connection."};
        if (completionBlock)
            completionBlock(results, nil);
        
        return;
    }

//    NSLog(@"inviteMembers: %@", [invitees description]);
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"invitees"] = invitees;
    params[@"action"] = @"invite";
    SSProfile *profile = [SSProfile sharedProfile];
    params[@"host"] = profile.name;
    
    NSLog(@"inviteMembers: %@", [params description]);

    [httpClient putPath:[kPathGroups stringByAppendingString:group.groupId]
              parameters:params
                 success:^(AFHTTPRequestOperation *operation, id responseObject){
                     NSError *error = nil;
                     NSDictionary *responseDictionary = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                       options:NSJSONReadingMutableContainers
                                                                                                         error:&error];
                     
                     if (error){
                         NSLog(@"SUCCESS BLOCK: ERROR - %@", [error localizedDescription]);
                     }
                     else{
                         //                         NSLog(@"SUCCESS BLOCK: %@", [responseDictionary description]);
                         NSDictionary *results = [responseDictionary objectForKey:@"results"];
                         NSString *confirmation = [results objectForKey:@"confirmation"];
                         
                         if ([confirmation isEqualToString:@"success"]){ // profile successfully registered
                             if (completionBlock)
                                 completionBlock(results, error);
                         }
                         else{ // registration failed.
                             NSLog(@"%@", [results description]);
                             if (completionBlock){
                                 completionBlock(results, nil);
                             }
                         }
                     }
                 }
     
                 failure:^(AFHTTPRequestOperation *operation, NSError *error){
                     NSLog(@"FAILURE BLOCK: %@", [error localizedDescription]);
                     if (completionBlock)
                         completionBlock(nil, error);
                 }];
}


- (void)fetchGroupInfo:(SSGroup *)group completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock
{
    SignalCheck *signalCheck = [SignalCheck signalWithDelegate:self];
    if (![signalCheck checkSignal]){
        NSDictionary *results = @{@"confirmation":@"fail", @"message":@"No Connection. Please find an internet connection."};
        if (completionBlock)
            completionBlock(results, nil);
        
        return;
    }

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    [httpClient getPath:[kPathGroups stringByAppendingString:group.groupId]
             parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject){
                    NSError *error = nil;
                    NSDictionary *responseDictionary = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                      options:NSJSONReadingMutableContainers
                                                                                                        error:&error];
                    
                    if (error){
                        NSLog(@"SUCCESS BLOCK: ERROR - %@", [error localizedDescription]);
                    }
                    else{
                        //NSLog(@"SUCCESS BLOCK: %@", [responseDictionary description]);
                        NSDictionary *results = [responseDictionary objectForKey:@"results"];
                        NSString *confirmation = [results objectForKey:@"confirmation"];
                        
                        if ([confirmation isEqualToString:@"success"]){ // profile successfully registered
                            if (completionBlock)
                                completionBlock(results, error);
                        }
                        else{
                            if (completionBlock)
                                completionBlock(results, nil);
                        }
                    }
                }
     
                failure:^(AFHTTPRequestOperation *operation, NSError *error){
                    NSLog(@"FAILURE BLOCK: %@", [error localizedDescription]);
                    if (completionBlock)
                        completionBlock(nil, error);
                }];
}


- (void)joinGroup:(NSString *)groupName withPin:(NSString *)pin completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock
{
    SignalCheck *signalCheck = [SignalCheck signalWithDelegate:self];
    if (![signalCheck checkSignal]){
        NSDictionary *results = @{@"confirmation":@"fail", @"message":@"No Connection. Please find an internet connection."};
        if (completionBlock)
            completionBlock(results, nil);
        
        return;
    }

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    SSProfile *profile = [SSProfile sharedProfile];
    params[@"profile"] = profile.uniqueId;
    params[@"password"] = pin;
    params[@"groupName"] = groupName;
    params[@"action"] = @"join";
    
//    NSLog(@"inviteMembers: %@", [params description]);
    
    [httpClient putPath:kPathGroups
             parameters:params
                success:^(AFHTTPRequestOperation *operation, id responseObject){
                    NSError *error = nil;
                    NSDictionary *responseDictionary = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                      options:NSJSONReadingMutableContainers
                                                                                                        error:&error];
                    
                    if (error){
                        NSLog(@"SUCCESS BLOCK: ERROR - %@", [error localizedDescription]);
                    }
                    else{
                        //                         NSLog(@"SUCCESS BLOCK: %@", [responseDictionary description]);
                        NSDictionary *results = [responseDictionary objectForKey:@"results"];
                        NSString *confirmation = [results objectForKey:@"confirmation"];
                        
                        if ([confirmation isEqualToString:@"success"]){ // profile successfully registered
                            if (completionBlock)
                                completionBlock(results, error);
                        }
                        else{ // registration failed.
                            NSLog(@"%@", [results description]);
                            if (completionBlock){
                                completionBlock(results, nil);
                            }
                        }
                    }
                }
     
                failure:^(AFHTTPRequestOperation *operation, NSError *error){
                    NSLog(@"FAILURE BLOCK: %@", [error localizedDescription]);
                    if (completionBlock)
                        completionBlock(nil, error);
                }];
}


- (void)removeMember:(NSString *)memberId fromGroup:(SSGroup *)group completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock
{
    SignalCheck *signalCheck = [SignalCheck signalWithDelegate:self];
    if (![signalCheck checkSignal]){
        NSDictionary *results = @{@"confirmation":@"fail", @"message":@"No Connection. Please find an internet connection."};
        if (completionBlock)
            completionBlock(results, nil);
        
        return;
    }

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"member"] = memberId;
    params[@"action"] = @"remove";
    
    [httpClient putPath:[kPathGroups stringByAppendingString:group.groupId]
             parameters:params
                success:^(AFHTTPRequestOperation *operation, id responseObject){
                    NSError *error = nil;
                    NSDictionary *responseDictionary = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                      options:NSJSONReadingMutableContainers
                                                                                                        error:&error];
                    
                    if (error){
                        NSLog(@"SUCCESS BLOCK: ERROR - %@", [error localizedDescription]);
                    }
                    else{
                        //                         NSLog(@"SUCCESS BLOCK: %@", [responseDictionary description]);
                        NSDictionary *results = [responseDictionary objectForKey:@"results"];
                        NSString *confirmation = [results objectForKey:@"confirmation"];
                        
                        if ([confirmation isEqualToString:@"success"]){ // profile successfully registered
                            if (completionBlock)
                                completionBlock(results, error);
                        }
                        else{ // registration failed.
                            NSLog(@"%@", [results description]);
                            if (completionBlock){
                                completionBlock(results, nil);
                            }
                        }
                    }
                }
     
                failure:^(AFHTTPRequestOperation *operation, NSError *error){
                    NSLog(@"FAILURE BLOCK: %@", [error localizedDescription]);
                    if (completionBlock)
                        completionBlock(nil, error);
                }];
}

- (void)submitQuestion:(SSQuestion *)question completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock
{
    SignalCheck *signalCheck = [SignalCheck signalWithDelegate:self];
    if (![signalCheck checkSignal]){
        NSDictionary *results = @{@"confirmation":@"fail", @"message":@"No Connection. Please find an internet connection."};
        if (completionBlock)
            completionBlock(results, nil);
        
        return;
    }

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kSecureBaseUrl]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [httpClient postPath:kPathQuestions
              parameters:[question parametersDictionary]
                 success:^(AFHTTPRequestOperation *operation, id responseObject){
                     NSError *error = nil;
                     NSDictionary *responseDictionary = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                       options:NSJSONReadingMutableContainers
                                                                                                         error:&error];
                     
                     if (error){
                         NSLog(@"SUCCESS BLOCK: ERROR - %@", [error localizedDescription]);
                     }
                     else{
                         //                         NSLog(@"SUCCESS BLOCK: %@", [responseDictionary description]);
                         NSDictionary *results = [responseDictionary objectForKey:@"results"];
                         NSString *confirmation = [results objectForKey:@"confirmation"];
                         
                         if ([confirmation isEqualToString:@"success"]){ // profile successfully registered
                             if (completionBlock)
                                 completionBlock(results, error);
                         }
                         else{ // registration failed.
                             if (completionBlock)
                                 completionBlock(results, nil);
                         }
                     }
                 }
     
                 failure:^(AFHTTPRequestOperation *operation, NSError *error){
                     NSLog(@"FAILURE BLOCK: %@", [error localizedDescription]);
                     if (completionBlock)
                         completionBlock(nil, error);
                 }];
}

- (void)fetchUploadString:(int)count completion:(SSWebServiceRequestCompletionBlock)completionBlock
{
    SignalCheck *signalCheck = [SignalCheck signalWithDelegate:self];
    if (![signalCheck checkSignal]){
        NSDictionary *results = @{@"confirmation":@"fail", @"message":@"No Connection. Please find an internet connection."};
        if (completionBlock)
            completionBlock(results, nil);
        
        return;
    }

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    [httpClient getPath:kPathUpload
             parameters:@{@"count":[NSString stringWithFormat:@"%d", count]}
                success:^(AFHTTPRequestOperation *operation, id responseObject){
                    NSError *error = nil;
                    NSDictionary *responseDictionary = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                      options:NSJSONReadingMutableContainers
                                                                                                        error:&error];
                    
                    if (error){
                        NSLog(@"SUCCESS BLOCK: ERROR - %@", [error localizedDescription]);
                    }
                    else{
                        //NSLog(@"SUCCESS BLOCK: %@", [responseDictionary description]);
                        NSDictionary *results = [responseDictionary objectForKey:@"results"];
                        NSString *confirmation = [results objectForKey:@"confirmation"];
                        
                        if ([confirmation isEqualToString:@"success"]){ // profile successfully registered
                            if (completionBlock)
                                completionBlock(results, error);
                        }
                        else{
                            if (completionBlock)
                                completionBlock(results, nil);
                        }
                    }
                }
     
                failure:^(AFHTTPRequestOperation *operation, NSError *error){
                    NSLog(@"FAILURE BLOCK: %@", [error localizedDescription]);
                    if (completionBlock)
                        completionBlock(nil, error);
                }];

    
}




- (void)uploadImage:(NSDictionary *)image toUrl:(NSString *)uploadUrl completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock
{
    SignalCheck *signalCheck = [SignalCheck signalWithDelegate:self];
    if (![signalCheck checkSignal]){
        NSDictionary *results = @{@"confirmation":@"fail", @"message":@"No Connection. Please find an internet connection."};
        if (completionBlock)
            completionBlock(results, nil);
        
        return;
    }

    NSData *imageData = image[@"data"];
    NSString *imageName = image[@"name"];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:uploadUrl parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:imageName mimeType:@"image/jpeg"];
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite){
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        NSError *error = nil;
        NSDictionary *response = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        if (error){
//            NSLog(@"JSON ERROR: %@", [error localizedDescription]);
            completionBlock(responseObject, error);
        }
        else{
//            NSLog(@"UPLOAD COMPLETE: %@", [response description]);
            completionBlock(response, nil);

        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
//        NSLog(@"UPLOAD FAILED: %@", [error localizedDescription]);
        completionBlock(nil, error);
    }];
    
    
    [operation start];
}

- (void)fetchImage:(NSString *)imageId completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock
{
    
    //check cache first:
    NSString *filePath = [self createFilePath:imageId];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (data){
        NSLog(@"CACHED IMAGE: %@", imageId);
        UIImage *image = [UIImage imageWithData:data];
        if (completionBlock)
            completionBlock(image, nil);

        return;
    }

    
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    [httpClient getPath:[kPathImages stringByAppendingString:[NSString stringWithFormat:@"%@?crop=220", imageId]]
             parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject){
                    
                    NSData *imageData = (NSData *)responseObject; // convert response data into image
                    
                    //Save image to cache directory:
                    [imageData writeToFile:filePath atomically:YES];
                    [self addSkipBackupAttributeToItemAtURL:[NSURL URLWithString:filePath]]; //this prevents files from being backed up on itunes and iCloud


                    
                    UIImage *image = [UIImage imageWithData:imageData];
                    if (completionBlock)
                        completionBlock(image, nil);
                }
     
                failure:^(AFHTTPRequestOperation *operation, NSError *error){
                    NSLog(@"FAILURE BLOCK: %@", [error localizedDescription]);
                    if (completionBlock)
                        completionBlock(nil, error);
                }];
    
}


- (void)postComment:(NSDictionary *)comment completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock
{
    SignalCheck *signalCheck = [SignalCheck signalWithDelegate:self];
    if (![signalCheck checkSignal]){
        NSDictionary *results = @{@"confirmation":@"fail", @"message":@"No Connection. Please find an internet connection."};
        if (completionBlock)
            completionBlock(results, nil);
        
        return;
    }

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [httpClient postPath:kPathComments
              parameters:comment
                 success:^(AFHTTPRequestOperation *operation, id responseObject){
                     NSError *error = nil;
                     NSDictionary *responseDictionary = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                       options:NSJSONReadingMutableContainers
                                                                                                         error:&error];
                     
                     if (error){
                         NSLog(@"SUCCESS BLOCK: ERROR - %@", [error localizedDescription]);
                     }
                     else{
                         //                         NSLog(@"SUCCESS BLOCK: %@", [responseDictionary description]);
                         NSDictionary *results = [responseDictionary objectForKey:@"results"];
                         NSString *confirmation = [results objectForKey:@"confirmation"];
                         
                         if ([confirmation isEqualToString:@"success"]){ // profile successfully registered
                             if (completionBlock)
                                 completionBlock(results, error);
                         }
                         else{
                             if (completionBlock)
                                 completionBlock(results, nil);
                         }
                     }
                 }
     
                 failure:^(AFHTTPRequestOperation *operation, NSError *error){
                     NSLog(@"FAILURE BLOCK: %@", [error localizedDescription]);
                     if (completionBlock)
                         completionBlock(nil, error);
                 }];
}

- (void)deleteQuestion:(SSQuestion *)question completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock
{
    SignalCheck *signalCheck = [SignalCheck signalWithDelegate:self];
    if (![signalCheck checkSignal]){
        NSDictionary *results = @{@"confirmation":@"fail", @"message":@"No Connection. Please find an internet connection."};
        if (completionBlock)
            completionBlock(results, nil);
        
        return;
    }

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    [httpClient deletePath:[kPathQuestions stringByAppendingString:question.uniqueId]
             parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject){
                    NSError *error = nil;
                    NSDictionary *responseDictionary = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                      options:NSJSONReadingMutableContainers
                                                                                                        error:&error];
                    
                    if (error){
                        NSLog(@"SUCCESS BLOCK: ERROR - %@", [error localizedDescription]);
                    }
                    else{
                        //NSLog(@"SUCCESS BLOCK: %@", [responseDictionary description]);
                        NSDictionary *results = [responseDictionary objectForKey:@"results"];
                        NSString *confirmation = [results objectForKey:@"confirmation"];
                        
                        if ([confirmation isEqualToString:@"success"]){ // profile successfully registered
                            if (completionBlock)
                                completionBlock(results, error);
                        }
                        else{
                            if (completionBlock)
                                completionBlock(results, nil);
                        }
                    }
                }
     
                failure:^(AFHTTPRequestOperation *operation, NSError *error){
                    NSLog(@"FAILURE BLOCK: %@", [error localizedDescription]);
                    if (completionBlock)
                        completionBlock(nil, error);
                }];
    
}

#pragma mark - FileSavingStuff:
- (NSString *)createFilePath:(NSString *)fileName
{
	fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"+"];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
	return filePath;
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

@end
