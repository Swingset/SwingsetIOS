//
//  SSFoldViewController.m
//  SwingSet
//
//  Created by Denny Kwon on 1/26/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSFoldViewController.h"

CATransform3D makePerspectiveTransform() {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -2000;
    return transform;
}


@interface SSFoldViewController ()
@end


@implementation SSFoldViewController


{
    CALayer *leftPage;
    CALayer *rightPage;
    CAShapeLayer *leftPageShadowLayer;
    CAShapeLayer *rightPageShadowLayer;
    UIView *curtainView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)loadView
{
    UIView *view = [self baseView:YES];
    //    CGRect frame = view.frame;
    
    //    CGFloat padding = 25.0f;
    //    CGFloat w = frame.size.width-2*padding;
    //    for (int i=0; i<self.questions.count; i++) {
    //
    //        SSQuestionPreview *preview = [[SSQuestionPreview alloc] initWithFrame:CGRectMake(padding, padding, w, 1.2f*w)];
    //        preview.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin);
    //        [view addSubview:preview];
    //    }
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    leftPageShadowLayer = [CAShapeLayer layer];
    rightPageShadowLayer = [CAShapeLayer layer];
    
    leftPageShadowLayer.anchorPoint = CGPointMake(1.0, 0.5);
    rightPageShadowLayer.anchorPoint = CGPointMake(0.0, 0.5);
    
    leftPageShadowLayer.position = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    rightPageShadowLayer.position = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    
    leftPageShadowLayer.bounds = CGRectMake(0, 0, self.view.bounds.size.width/2, self.view.bounds.size.height);
    rightPageShadowLayer.bounds = CGRectMake(0, 0, self.view.bounds.size.width/2, self.view.bounds.size.height);
    
    UIBezierPath *leftPageRoundedCornersPath = [UIBezierPath bezierPathWithRoundedRect:leftPageShadowLayer.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(0., 0.0)];
    UIBezierPath *rightPageRoundedCornersPath = [UIBezierPath bezierPathWithRoundedRect:rightPageShadowLayer.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(0.0, 0.0)];
    
    //    leftPageShadowLayer.shadowPath = leftPageRoundedCornersPath.CGPath;
    rightPageShadowLayer.shadowPath = rightPageRoundedCornersPath.CGPath;
    
    //    leftPageShadowLayer.shadowColor = [UIColor blackColor].CGColor;
    //    leftPageShadowLayer.shadowRadius = 100.0;
    //    leftPageShadowLayer.shadowOpacity = 0.9;
    
    rightPageShadowLayer.shadowColor = [UIColor blackColor].CGColor;
    rightPageShadowLayer.shadowRadius = 100;
    rightPageShadowLayer.shadowOpacity = 0.9;
    
    
    
    leftPage = [CALayer layer];
    rightPage = [CALayer layer];
    
    leftPage.frame = leftPageShadowLayer.bounds;
    rightPage.frame = rightPageShadowLayer.bounds;
    
    leftPage.backgroundColor = [UIColor whiteColor].CGColor;
    rightPage.backgroundColor = [UIColor whiteColor].CGColor;
    
    leftPage.borderColor = [UIColor darkGrayColor].CGColor;
    rightPage.borderColor = [UIColor darkGrayColor].CGColor;
    
    leftPage.transform = makePerspectiveTransform();
    rightPage.transform = makePerspectiveTransform();
    
    CAShapeLayer *leftPageRoundedCornersMask = [CAShapeLayer layer];
    CAShapeLayer *rightPageRoundedCornersMask = [CAShapeLayer layer];
    
    leftPageRoundedCornersMask.frame = leftPage.bounds;
    rightPageRoundedCornersMask.frame = rightPage.bounds;
    
    leftPageRoundedCornersMask.path = leftPageRoundedCornersPath.CGPath;
    rightPageRoundedCornersMask.path = rightPageRoundedCornersPath.CGPath;
    
    leftPage.mask = leftPageRoundedCornersMask;
    rightPage.mask = rightPageRoundedCornersMask;
    
    leftPageShadowLayer.transform = makePerspectiveTransform();
    rightPageShadowLayer.transform = makePerspectiveTransform();
    
    curtainView = [[UIView alloc] initWithFrame:self.view.bounds];
    curtainView.backgroundColor = [UIColor clearColor];
    
    [curtainView.layer addSublayer:leftPageShadowLayer];
    [curtainView.layer addSublayer:rightPageShadowLayer];
    [leftPageShadowLayer addSublayer:leftPage];
    [rightPageShadowLayer addSublayer:rightPage];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(foldWithPinch:)];
    [self.view addGestureRecognizer:pinch];
}



- (void)foldWithPinch:(UIPinchGestureRecognizer *)p
{
    if (p.state == UIGestureRecognizerStateBegan)
    {
        self.view.userInteractionEnabled = NO;
        
        CGImageRef imgRef = [UIImage imageNamed:@"Default.png"].CGImage;
        
        leftPage.contents = (__bridge id)imgRef;
        rightPage.contents = (__bridge id)imgRef;
        leftPage.contentsRect = CGRectMake(0.0, 0.0, 0.5, 1.0);
        rightPage.contentsRect = CGRectMake(0.5, 0.0, 0.5, 1.0);
        leftPageShadowLayer.transform = CATransform3DIdentity;
        rightPageShadowLayer.transform = CATransform3DIdentity;
        leftPageShadowLayer.transform = makePerspectiveTransform();
        rightPageShadowLayer.transform = makePerspectiveTransform();
        [self.view addSubview:curtainView];
    }
    
    
    
    float scale = (p.scale > 0.48) ? p.scale : 0.48;
    scale = (scale < 1.0) ? scale : 1.0;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    leftPageShadowLayer.transform = CATransform3DIdentity;
    rightPageShadowLayer.transform = CATransform3DIdentity;
    
    leftPageShadowLayer.transform = makePerspectiveTransform();
    rightPageShadowLayer.transform = makePerspectiveTransform();
    
    leftPageShadowLayer.transform = CATransform3DScale(leftPageShadowLayer.transform, scale, scale, scale);
    rightPageShadowLayer.transform = CATransform3DScale(rightPageShadowLayer.transform, scale, scale, scale);
    
    leftPageShadowLayer.transform = CATransform3DRotate(leftPageShadowLayer.transform, (1.0 - scale) * M_PI, 0.0, 1.0, 0.0);
    rightPageShadowLayer.transform = CATransform3DRotate(rightPageShadowLayer.transform, -(1.0 - scale) * M_PI, 0.0, 1.0, 0.0);
    
    [CATransaction commit];
    
    if (p.state == UIGestureRecognizerStateEnded){
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            self.view.userInteractionEnabled = YES;
            [curtainView removeFromSuperview];
        }];
        
        
        [CATransaction setAnimationDuration:0.5/scale];
        leftPageShadowLayer.transform = CATransform3DIdentity;
        rightPageShadowLayer.transform = CATransform3DIdentity;
        [CATransaction commit];
    }
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
