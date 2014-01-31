//
//  SSQuestion.m
//  SwingSet
//
//  Created by Denny Kwon on 1/21/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSQuestion.h"
#import "SSProfile.h"

@implementation SSQuestion
@synthesize uniqueId;
@synthesize group;
@synthesize text;
@synthesize author;
@synthesize votes;
@synthesize options;
@synthesize timestamp;
@synthesize image;
@synthesize totalMaleVotes;
@synthesize totalFemaleVotes;


- (id)init
{
    self = [super init];
    if (self){
        self.totalFemaleVotes = 0;
        self.totalMaleVotes = 0;
    }
    return self;
}

+ (SSQuestion *)questionWithInfo:(NSDictionary *)info
{
    SSQuestion *question = [[SSQuestion alloc] init];
    [question populate:info];
    
    return question;
}

- (void)populate:(NSDictionary *)info
{
    
    for (NSString *key in info.allKeys) {
        if ([key isEqualToString:@"id"])
            self.uniqueId = [info objectForKey:key];
        
        if ([key isEqualToString:@"author"])
            self.author = [info objectForKey:key];
        
        if ([key isEqualToString:@"group"])
            self.group = [info objectForKey:key];
        
        if ([key isEqualToString:@"text"])
            self.text = [info objectForKey:key];
        
        if ([key isEqualToString:@"votes"]){
            self.votes = [NSMutableArray arrayWithArray:[info objectForKey:key]];
        }

        if ([key isEqualToString:@"options"]){
            self.options = [NSMutableArray arrayWithArray:[info objectForKey:key]];
        }

        if ([key isEqualToString:@"image"])
            self.image = [info objectForKey:key];

//        if ([key isEqualToString:@"timestamp"])
//            self.timestamp = [info objectForKey:key];
    }
    
    
//    for (NSDictionary *option in self.options) {
//        if (option[@"maleVotes"]){
//            self.totalMaleVotes += [option[@"maleVotes"] intValue];
//        }
//        
//        if (option[@"femaleVotes"]){
//            self.totalFemaleVotes += [option[@"femaleVotes"] intValue];
//        }
//    }
    
    [self resetTotalGenderCount];

    
}

- (void)resetTotalGenderCount
{
    self.totalMaleVotes = 0;
    self.totalFemaleVotes = 0;
    for (NSDictionary *option in self.options) {
        if (option[@"maleVotes"]){
            self.totalMaleVotes += [option[@"maleVotes"] intValue];
        }
        
        if (option[@"femaleVotes"]){
            self.totalFemaleVotes += [option[@"femaleVotes"] intValue];
        }
    }
}


- (void)addVote:(int)index
{
    if (index >= self.options.count) // shouldn't happen, just playing it safe
        return;
    
    SSProfile *profile = [SSProfile sharedProfile];

    NSDictionary *option = (NSDictionary *)[self.options objectAtIndex:index];
    NSMutableDictionary *updatedOption = [NSMutableDictionary dictionaryWithDictionary:option];

    if ([profile.sex.lowercaseString isEqualToString:@"m"]){
        int mVotes = [option[@"maleVotes"] intValue];
        mVotes++;
        updatedOption[@"maleVotes"] = [NSString stringWithFormat:@"%d", mVotes];
        self.totalMaleVotes++;
    }
    else{
        int fVotes = [option[@"femaleVotes"] intValue];
        fVotes++;
        updatedOption[@"femaleVotes"] = [NSString stringWithFormat:@"%d", fVotes];
        self.totalFemaleVotes++;
    }
    
    [self.options replaceObjectAtIndex:index withObject:updatedOption];

    
    NSArray *optionVotes = option[@"votes"];
    NSMutableArray *updatedOptionVotes = [NSMutableArray arrayWithArray:optionVotes];
    [updatedOptionVotes addObject:@{@"id":profile.uniqueId, @"sex":profile.sex, @"username":profile.name}];
    updatedOption[@"votes"] = updatedOptionVotes;
    
    
    [self.votes addObject:profile.uniqueId];
    
    [self resetTotalGenderCount];
}


@end
