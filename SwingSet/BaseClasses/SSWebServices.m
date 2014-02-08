//
//  SSWebServices.m
//  SwingSet
//
//  Created by Denny Kwon on 1/19/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSWebServices.h"
#import "AFNetworking.h"


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

- (void)confirmPIN:(NSDictionary *)pkg completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock
{
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

- (void)fetchPublicQuestions:(SSWebServiceRequestCompletionBlock)completionBlock
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    

    [httpClient getPath:@"/api/questions/"
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

- (void)submitVote:(SSProfile *)profile withQuestion:(SSQuestion *)question withSelection:(long)index completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock
{
    
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


- (void)inviteMembers:(NSArray *)invitees toGroup:(NSDictionary *)group completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock
{
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

    [httpClient putPath:[kPathGroups stringByAppendingString:group[@"id"]]
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


- (void)fetchGroupInfo:(NSDictionary *)group completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    [httpClient getPath:[kPathGroups stringByAppendingString:group[@"id"]]
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

- (void)submitQuestion:(SSQuestion *)question completionBlock:(SSWebServiceRequestCompletionBlock)completionBlock
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kSecureBaseUrl]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
//    SSProfile *profile = [SSProfile sharedProfile];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
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
    NSData *imageData = image[@"data"];
    NSString *imageName = image[@"name"];
    
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://swingsetlabs.appspot.com/"]];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
//    NSData *imageData = UIImageJPEGRepresentation(self.questionImg, 0.5f);
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:uploadUrl parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:imageData name:@"MainMedia" fileName:imageName mimeType:@"image/jpeg"];
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


@end
