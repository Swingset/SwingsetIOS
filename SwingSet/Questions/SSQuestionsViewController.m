//
//  SSQuestionsViewController.m
//  SwingSet
//
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSQuestionsViewController.h"
#import "SSQuestionPreview.h"


@interface SSQuestionsViewController ()
@property (strong, nonatomic) NSMutableArray *questions;
@property (strong, nonatomic) SSQuestionPreview *topPreview;
@property (strong, nonatomic) SSQuestionPreview *backPreview;
@property (nonatomic) int questionIndex;
@property (nonatomic) CGFloat center;
@end


@implementation SSQuestionsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeAll;
        self.questions = [NSMutableArray array];
        self.questionIndex = 0;
    }
    return self;
}

- (void)loadView
{
    UIView *view = [self baseView:YES];
    CGRect frame = view.frame;
    
    CGFloat padding = 20.0f;
    CGFloat w = frame.size.width-2*padding;
    
    self.backPreview = [[SSQuestionPreview alloc] initWithFrame:CGRectMake(padding, padding, w, frame.size.height-2*padding)];
    self.backPreview.tag = 1000;
    self.backPreview.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin);
    [view addSubview:self.backPreview];

    self.topPreview = [[SSQuestionPreview alloc] initWithFrame:self.backPreview.frame];
    self.topPreview.tag = 2000;
    self.topPreview.delegate = self;
    [self.topPreview addObserver:self forKeyPath:@"center" options:0 context:NULL];
    self.topPreview.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin);
    [view addSubview:self.topPreview];
    

    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    SSViewController *container = (SSViewController *)self.navigationController.parentViewController;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"menu"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:container
                                                                            action:@selector(toggleSections)];

    self.backPreview.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
    self.center = 0.5f*self.view.frame.size.width;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.questions.count > 0)
        return;

    
    [[SSWebServices sharedInstance] fetchPublicQuestions:^(id result, NSError *error){
        if (error){
            [self showAlert:@"Error" withMessage:[error localizedDescription]];
            return;
        }
        
        NSDictionary *results = (NSDictionary *)result;
        NSLog(@"%@", [results description]);
        
        NSString *confirmation = [results objectForKey:@"confirmation"];
        if ([confirmation isEqualToString:@"success"]==YES){
            NSArray *questions = [results objectForKey:@"questions"];
            for (int i=0; i<questions.count; i++){
                NSDictionary *questionInfo = [questions objectAtIndex:i];
                [self.questions addObject:[SSQuestion questionWithInfo:questionInfo]];
            }
            
            SSQuestion *question = [self.questions objectAtIndex:self.questionIndex];
            self.topPreview.lblText.text = question.text;
            [self loadNextQuestion];
        }
        else{
            [self showAlert:@"Error" withMessage:[results objectForKey:@"message"]];
        }
    }];

    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isEqual:self.topPreview]==NO)
        return;
    
    if ([keyPath isEqualToString:@"center"]==NO)
        return;
    
    CGFloat delta = self.topPreview.center.x-self.center;
    double pct = delta/self.center;
    
    NSLog(@"TOP PREVIEW MOVING: %.2f", pct);
    
    pct *= -1.0f;
    if (pct > 1.0f)
        pct = 0.99f;
    
    double scale = (0.2f*pct)+0.80f;
    self.backPreview.transform = CGAffineTransformMakeScale(scale, scale);
    self.backPreview.alpha = pct;
    
}

- (void)checkPostion
{
    
    NSLog(@"CHECK POSITION");
    
    CGRect frame = self.view.frame;
    if (self.topPreview.center.x < 0.10f*frame.size.width){
        NSLog(@"SWAP");
        
        [UIView animateWithDuration:0.25f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGPoint ctr = self.topPreview.center;
                             ctr.x = -0.45f*frame.size.width;
                             self.topPreview.center = ctr;
                             self.topPreview.alpha = 0;
                             
                             ctr = self.backPreview.center;
                             ctr.x += 60.0f;
                             self.backPreview.center = ctr;
                             
                             self.topPreview.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
                             self.backPreview.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished){
                             [self.view bringSubviewToFront:self.backPreview];
                             CGRect frame = self.topPreview.frame;
                             frame.origin.x = 0.5f*(self.view.frame.size.width-self.topPreview.frame.size.width);
                             self.topPreview.frame = frame;

                             [UIView animateWithDuration:0.12f
                                                   delay:0
                                                 options:UIViewAnimationOptionCurveEaseInOut
                                              animations:^{
                                                  self.topPreview.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
                                                  
                                                  CGPoint ctr = self.backPreview.center;
                                                  ctr.x = 0.47*self.view.frame.size.width;
                                                  self.backPreview.center = ctr;
                                                  
                                              }
                                              completion:^(BOOL finished){
                                                  
                                                  [UIView animateWithDuration:0.12f
                                                                        delay:0
                                                                      options:UIViewAnimationOptionCurveLinear
                                                                   animations:^{
                                                                       
                                                                       CGPoint ctr = self.backPreview.center;
                                                                       ctr.x = 0.52*self.view.frame.size.width;
                                                                       self.backPreview.center = ctr;
                                                                   }
                                                                   completion:^(BOOL finished){
                                                                       [UIView animateWithDuration:0.12f
                                                                                             delay:0
                                                                                           options:UIViewAnimationOptionCurveLinear
                                                                                        animations:^{
                                                                                            CGPoint ctr = self.backPreview.center;
                                                                                            ctr.x = 0.5*self.view.frame.size.width;
                                                                                            self.backPreview.center = ctr;
                                                                                        }
                                                                                        completion:^(BOOL finished){
                                                                                            [self swapPreviews];
                                                                                            self.questionIndex++;
                                                                                            [self loadNextQuestion];
                                                                                        }];
                                                                       
                                                                       
                                                                   }];
                                              }];
                         }];
        
        return;
    }
    
    
    NSLog(@"RESTORE");
    [UIView animateWithDuration:0.12f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGPoint ctr = self.topPreview.center;
                         ctr.x = 0.53f*frame.size.width;
                         self.topPreview.center = ctr;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.12f
                                               delay:0
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              CGPoint ctr = self.topPreview.center;
                                              ctr.x = 0.48f*frame.size.width;
                                              self.topPreview.center = ctr;
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.12f
                                                                    delay:0
                                                                  options:UIViewAnimationOptionCurveLinear
                                                               animations:^{
                                                                   CGPoint ctr = self.topPreview.center;
                                                                   ctr.x = 0.5f*frame.size.width;
                                                                   self.topPreview.center = ctr;
                                                               }
                                                               completion:^(BOOL finished){
                                                                   
                                                               }];
                                          }];
                         
                         
                     }];

    
}


- (void)swapPreviews
{
    self.topPreview.delegate = nil;
    [self.topPreview removeObserver:self forKeyPath:@"center"];
    
    if (self.topPreview.tag==1000){
        self.topPreview = (SSQuestionPreview *)[self.view viewWithTag:2000];
        self.backPreview = (SSQuestionPreview *)[self.view viewWithTag:1000];
    }
    else{
        self.topPreview = (SSQuestionPreview *)[self.view viewWithTag:1000];
        self.backPreview = (SSQuestionPreview *)[self.view viewWithTag:2000];
    }
    
    self.topPreview.delegate = self;
    [self.topPreview addObserver:self forKeyPath:@"center" options:0 context:NULL];
}

- (void)loadNextQuestion
{
    if (self.questionIndex+1 >= self.questions.count)
        self.questionIndex = 0;

    SSQuestion *question = [self.questions objectAtIndex:self.questionIndex+1];
    self.backPreview.lblText.text = question.text;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
