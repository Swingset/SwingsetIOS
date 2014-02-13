//
//  SSQuestion.m
//  SwingSet
//
//  Created by Denny Kwon on 1/21/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSQuestion.h"
#import "SSProfile.h"
#import "SSWebServices.h"

@implementation SSQuestion
@synthesize uniqueId;
@synthesize group;
@synthesize text;
@synthesize author;
@synthesize votes;
@synthesize options;
@synthesize timestamp;
@synthesize imageId;
@synthesize totalMaleVotes;
@synthesize totalFemaleVotes;
@synthesize answerType;
@synthesize image;
@synthesize imagesCount;
@synthesize comments;
@synthesize isObserved;


- (id)init
{
    self = [super init];
    if (self){
        self.totalFemaleVotes = 0;
        self.totalMaleVotes = 0;
        self.answerType = @"text";
        self.isObserved = NO;
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
        
        if ([key isEqualToString:@"comments"])
            self.comments = [NSMutableArray arrayWithArray:[info objectForKey:key]];

        if ([key isEqualToString:@"image"])
            self.imageId = [info objectForKey:key];

        if ([key isEqualToString:@"answerType"])
            self.answerType = [info objectForKey:key];



//        if ([key isEqualToString:@"timestamp"])
//            self.timestamp = [info objectForKey:key];
    }
    
    [self resetTotalGenderCount];
    
    
    if ([self.imageId isEqualToString:@"none"]==NO && self.image==nil){
        [[SSWebServices sharedInstance] fetchImage:self.imageId completionBlock:^(id result, NSError *error){
            if (error){
                
            }
            else{
                NSLog(@"IMAGE FETCHED: %@", self.imageId);
                UIImage *img = (UIImage *)result;
                self.image = img;
            }
        }];
    }
    
    if ([self.answerType isEqualToString:@"text"])
        return;
    
    for (int i=0; i<self.options.count; i++) {
        NSMutableDictionary *option = self.options[i];
        NSString *imgId = option[@"image"];
        
        if ([imgId isEqualToString:@"none"]==NO && self.imagesCount==0){
            [[SSWebServices sharedInstance] fetchImage:imgId completionBlock:^(id result, NSError *error){
                if (error){
                    
                }
                else{
                    UIImage *img = (UIImage *)result;
                    option[@"imageData"] = img;
                    [self performSelector:@selector(incrementImagesCount) withObject:nil afterDelay:0.08f]; // have to do this on slight delay. just do it.
                    NSLog(@"OPTION ICON FETCHED: %@, imagesCount:%d", imgId, self.imagesCount);
                }
            }];
        }
    }
}

- (void)incrementImagesCount
{
    self.imagesCount++;
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


- (NSMutableDictionary *)parametersDictionary
{
    NSMutableDictionary *params = params = [NSMutableDictionary dictionaryWithDictionary:@{@"text":self.text, @"options":self.options, @"author":self.author, @"answerType":self.answerType, @"group":self.group}];
    
    if (self.imageId)
        params[@"image"] = self.imageId;
    
    return params;
}


@end
