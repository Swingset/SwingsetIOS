//
//  SSConfirmViewController.h
//  SwingSet
//
//  Created by Denny Kwon on 1/19/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSViewController.h"

@interface SSConfirmViewController : SSViewController <UITextFieldDelegate>

@property (nonatomic) int mode; //0=phone, 1=email
@end
