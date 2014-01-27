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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationBar.barStyle = UIBarStyleDefault;
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


#pragma TouchResonders
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan: %@", [self.class description]);
    UITouch *touch = [touches anyObject];
    if ([touch.view isEqual:self.navigationBar])
        NSLog(@"TOUCH NAV BAR!");
    
    self.start = [touch locationInView:self.parentViewController.view];
    self.startTime = [[NSDate date] timeIntervalSince1970];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
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
    NSLog(@"touchesEnded: %@", [self.class description]);
    if (![self.container respondsToSelector:@selector(childViewControllerStopped:velocity:)])
        return;
    
    
    UITouch *touch = [touches anyObject];
    CGPoint endLoc = [touch locationInView:self.parentViewController.view];
    CGFloat distance = endLoc.x - self.start.x;
    
    
    NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
    double duration = endTime-self.startTime;
    double velocity = distance / duration;
    //    NSLog(@"VELOCITY: %.2f", velocity);
    
    if ([self.container respondsToSelector:@selector(childViewControllerStopped:velocity:)])
        [self.container childViewControllerStopped:self velocity:velocity];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesCancelled: %@", [self.class description]);
    if (!self.container) // no container
        return;

    if ([self.container respondsToSelector:@selector(childViewControllerStopped:velocity:)])
        [self.container childViewControllerStopped:self velocity:0.0f];
    
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

