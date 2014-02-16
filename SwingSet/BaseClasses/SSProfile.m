//
//  SSProfile.m
//  SwingSet
//
//  Created by Denny Kwon on 1/19/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSProfile.h"

@implementation SSProfile
@synthesize uniqueId;
@synthesize email;
@synthesize phone;
@synthesize name;
@synthesize sex;
@synthesize pw;
@synthesize confirmed;
@synthesize groups;
@synthesize populated;

- (id)init
{
    self = [super init];
    if (self){
        self.uniqueId = @"none";
        self.email = @"";
        self.phone = @"";
        self.name = @"";
        self.sex = @"m";
        self.pw = @"";
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *json = [defaults objectForKey:@"user"];
        if (json){
            NSError *error = nil;
            NSDictionary *profileInfo = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
            NSLog(@"STORED PROFILE: %@", [profileInfo description]);
            if (!error)
                [self populate:profileInfo];

        }
        
    }
    return self;
}

+ (SSProfile *)sharedProfile
{
    NSLog(@"shared profile");
    static SSProfile *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        shared = [[SSProfile alloc] init];
        
    });
    
    return shared;
}

- (NSDictionary *)parametersDictionary
{
    NSString *conf = (self.confirmed) ? @"yes" : @"no";
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"id":self.uniqueId, @"name":self.name, @"sex":self.sex, @"pw":self.pw, @"confirmed":conf}];
    
    if (self.email.length > 1)
        [params setObject:self.email forKey:@"email"];

    if (self.phone.length > 9)
        [params setObject:self.phone forKey:@"phone"];

    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    int t = (int)timestamp;
    [params setObject:[NSString stringWithFormat:@"%d", t] forKey:@"timestamp"];
    
    return params;
}

- (NSString *)jsonRepresentation
{
    NSDictionary *info = [self parametersDictionary];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
    if (error)
        return nil;
    
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)populate:(NSDictionary *)info
{
    for (NSString *key in info.allKeys) {
        if ([key isEqualToString:@"id"])
            self.uniqueId = [info objectForKey:key];
        
        if ([key isEqualToString:@"email"])
            self.email = [info objectForKey:key];
        
        if ([key isEqualToString:@"phone"])
            self.phone = [info objectForKey:key];

        if ([key isEqualToString:@"sex"])
            self.sex = [info objectForKey:key];

        if ([key isEqualToString:@"username"])
            self.name = [info objectForKey:key];

        if ([key isEqualToString:@"confirmed"])
            self.confirmed = [[info objectForKey:key] isEqualToString:@"yes"];
        
        if ([key isEqualToString:@"groups"])
            self.groups = [NSMutableArray arrayWithArray:[info objectForKey:key]];
    }
    
    self.populated = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self jsonRepresentation] forKey:@"user"];
    [defaults synchronize];
}

- (void)removeGroup:(NSDictionary *)groupInfo
{
    NSMutableArray *updatedGroups = [NSMutableArray array];
    for (NSDictionary *group in self.groups) {
        if ([group[@"id"] isEqualToString:groupInfo[@"id"]]==NO){
            [updatedGroups addObject:group];
        }
    }
    
    self.groups = updatedGroups;
    
}



@end
