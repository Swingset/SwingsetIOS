//
//  SSNavigationController.h
//  SwingSet
//
//  Created by Denny Kwon on 1/18/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSNavigationControllerProtocol <NSObject>
@optional
- (void)hideMenu;
@end

@interface SSNavigationController : UINavigationController

@property (nonatomic) BOOL isMovable;
@property (nonatomic) BOOL slidOut;
@property (assign) id<SSNavigationControllerProtocol> container;
- (void)slideOut;
- (void)slideIn;
- (void)toggle;
@end


@interface UINavigationBar (UINavigationBar_TouchResponders)
@end
