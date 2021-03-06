//
//  SSNavigationController.m
//  SwingSet
//
//  Created by Denny Kwon on 1/18/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSNavigationController.h"

@interface SSNavigationController ()
@property (nonatomic) CGPoint start;
@property (nonatomic) NSTimeInterval startTime;
@end

@implementation SSNavigationController
@synthesize isMovable;
@synthesize slidOut;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationBar.barStyle = UIBarStyleDefault;
        self.navigationBar.tintColor = [UIColor blackColor];
        self.slidOut = NO;
        self.isMovable = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)motionStopped:(double)velocity
{
    if (self.view.frame.origin.x==0)
        return;
    
    static double threshold = 15.0f;
    if (velocity < -threshold){
        [self slideIn];
        return;
    }

    if (velocity > threshold){
        NSLog(@"SHOW SECTIONS ! !");
        [self slideOut];
        return;
    }
    
    (self.view.center.x >= 0.8f*self.view.frame.size.width) ? [self slideOut] : [self slideIn];
}


- (void)slideIn
{
    self.slidOut = NO;
    if ([self.container respondsToSelector:@selector(hideMenu)])
        [self.container hideMenu];
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect frame = self.view.frame;
                         frame.origin.x = 0.0f;
                         self.view.frame = frame;
                     }
                     completion:^(BOOL finished){
                         
                         //bounce out:
                         [UIView animateWithDuration:0.06f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              CGRect frame = self.view.frame;
                                              frame.origin.x = 8.0f;
                                              self.view.frame = frame;
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.06f
                                                                    delay:0.0f
                                                                  options:UIViewAnimationOptionCurveLinear
                                                               animations:^{
                                                                   CGRect frame = self.view.frame;
                                                                   frame.origin.x = 0.0f;
                                                                   self.view.frame = frame;
                                                               }
                                                               completion:^(BOOL finished){
                                                                   self.visibleViewController.view.userInteractionEnabled = YES;
                                                               }];
                                          }];
                     }];
}


- (void)slideOut
{
    CGPoint ctr = self.view.center;
    ctr.x = 1.4f*self.view.frame.size.width;
    
    [UIView animateWithDuration:0.20f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.view.center = ctr;
                     }
                     completion:^(BOOL finished){
                         if (finished){
                             [UIView animateWithDuration:0.20f
                                                   delay:0.06f
                                                 options:UIViewAnimationOptionCurveEaseIn
                                              animations:^{
                                                  CGPoint ctr = self.view.center;
                                                  ctr.x = 1.3f*self.view.frame.size.width;
                                                  self.view.center = ctr;
                                              }
                                              completion:^(BOOL finished){
                                                  self.slidOut = YES;
                                                  self.visibleViewController.view.userInteractionEnabled = NO;
                                              }];
                         }
                         
                     }];
}

- (void)toggle
{
    (self.view.frame.origin.x > 0) ? [self slideIn] : [self slideOut];
}


#pragma TouchResonders
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.isMovable)
        return;
    
    NSLog(@"touchesBegan: %@", [self.class description]);
    UITouch *touch = [touches anyObject];
    if ([touch.view isEqual:self.navigationBar])
        NSLog(@"TOUCH NAV BAR!");
    
    self.start = [touch locationInView:self.parentViewController.view];
    self.startTime = [[NSDate date] timeIntervalSince1970];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.isMovable)
        return;

    UITouch *touch = [touches anyObject];
    
    CGPoint newLoc = [touch locationInView:self.parentViewController.view];
    CGFloat delta = newLoc.x - self.start.x;
//    NSLog(@"DELTA: %.2f", delta);
    if (delta < 0) //cannot move to left
        return;
    
    self.start = newLoc;
    
    CGPoint ctr = self.view.center;
    self.view.center = CGPointMake(ctr.x+delta, ctr.y);
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.isMovable)
        return;

    NSLog(@"touchesEnded: %@, %.2f", [self.class description], self.view.center.x);
    
    // already slid out, slide back in:
    if (self.slidOut){
        [self slideIn];
        return;
    }

    
    UITouch *touch = [touches anyObject];
    CGPoint endLoc = [touch locationInView:self.parentViewController.view];
    CGFloat distance = endLoc.x - self.start.x;
    
    
    NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
    double duration = endTime-self.startTime;
    double velocity = distance / duration;
    //    NSLog(@"VELOCITY: %.2f", velocity);
    
    [self motionStopped:velocity];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.isMovable)
        return;

    NSLog(@"touchesCancelled: %@", [self.class description]);
    if (!self.container) // no container
        return;
}



@end


@implementation UINavigationBar (UINavigationBar_TouchResponders)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate touchesCancelled:touches withEvent:event];
}


@end

