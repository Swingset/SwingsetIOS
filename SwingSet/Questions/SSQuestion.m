//
//  SSQuestion.m
//  SwingSet
//
//  Created by Denny Kwon on 1/21/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSQuestion.h"

@implementation SSQuestion
@synthesize uniqueId;
@synthesize group;
@synthesize text;
@synthesize author;
@synthesize votes;
@synthesize options;
@synthesize timestamp;
@synthesize image;


- (id)init
{
    self = [super init];
    if (self){
        
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
        
        if ([key isEqualToString:@"votes"])
            self.votes = [info objectForKey:key];

        if ([key isEqualToString:@"options"])
            self.options = [info objectForKey:key];

        if ([key isEqualToString:@"image"])
            self.image = [info objectForKey:key];

//        if ([key isEqualToString:@"timestamp"])
//            self.timestamp = [info objectForKey:key];
    }
    
}


@end
