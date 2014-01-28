//
//  SSNavigationController.h
//  SwingSet
//
//  Created by Denny Kwon on 1/18/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSNavigationController : UINavigationController

@property (assign) id container;
- (void)slideOut;
- (void)slideIn;
- (void)toggle;
@end


@interface UINavigationBar (UINavigationBar_TouchResponders)
@end
