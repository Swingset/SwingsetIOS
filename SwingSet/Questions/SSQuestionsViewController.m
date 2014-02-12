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
@synthesize currentQuestion = _currentQuestion;

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
    
    CGFloat padding = 15.0f;
    CGFloat w = frame.size.width-2*padding;
    
    self.backPreview = [[SSQuestionPreview alloc] initWithFrame:CGRectMake(padding, padding, w, frame.size.height-2*padding)];
    self.backPreview.tag = 1000;
    self.backPreview.alpha = 0;
    self.backPreview.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin);
    [view addSubview:self.backPreview];

    self.topPreview = [[SSQuestionPreview alloc] initWithFrame:self.backPreview.frame];
    self.topPreview.tag = 2000;
    self.topPreview.delegate = self;
    [self.topPreview addObserver:self forKeyPath:@"center" options:0 context:NULL];
    self.topPreview.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin);
    [view addSubview:self.topPreview];
    
    [view addObserver:self forKeyPath:@"userInteractionEnabled" options:0 context:NULL];

    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SSNavigationController *navController = (SSNavigationController *)self.navigationController;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btnMenu.png"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:navController
                                                                             action:@selector(toggle)];

    
    
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
            
            // load first question:
            SSQuestion *question = (SSQuestion *)[self.questions objectAtIndex:self.questionIndex];
            self.currentQuestion = question;
            [self populatePreview:self.topPreview withQuestion:question];
            [self loadNextQuestion];
        }
        else{
            [self showAlert:@"Error" withMessage:[results objectForKey:@"message"]];
        }
    }];
}

- (void)setCurrentQuestion:(SSQuestion *)currentQuestion
{
    if (_currentQuestion){
        [_currentQuestion removeObserver:self forKeyPath:@"image"];
        [_currentQuestion removeObserver:self forKeyPath:@"imagesCount"];
    }
    
    _currentQuestion = currentQuestion;
    [_currentQuestion addObserver:self forKeyPath:@"image" options:0 context:NULL];
    [_currentQuestion addObserver:self forKeyPath:@"imagesCount" options:0 context:NULL];
    
    int nextIndex = self.questionIndex+1;
    if (nextIndex < self.questions.count){
        SSQuestion *nextQuestion = [self.questions objectAtIndex:nextIndex];
        [nextQuestion addObserver:self forKeyPath:@"image" options:0 context:NULL];
        [nextQuestion addObserver:self forKeyPath:@"imagesCount" options:0 context:NULL];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([[object class] isSubclassOfClass:[SSQuestion class]]){
        if ([object isEqual:self.currentQuestion]){
            [self populatePreview:self.topPreview withQuestion:self.currentQuestion];
            return;
        }
        
        SSQuestion *nextQuestion = (SSQuestion *)object;
        [self populatePreview:self.backPreview withQuestion:nextQuestion];
    }

    
    
    if ([object isEqual:self.view]){
        if ([keyPath isEqualToString:@"userInteractionEnabled"]){
            self.topPreview.userInteractionEnabled = self.view.userInteractionEnabled;
            self.backPreview.userInteractionEnabled = self.view.userInteractionEnabled;
        }
    }
    
    
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
    [self.backPreview reset];
}

- (void)loadNextQuestion
{

    int index = self.questionIndex+1;
    if (index >= self.questions.count)
        index = 0;

    SSQuestion *question = (SSQuestion *)[self.questions objectAtIndex:index];
    [self populatePreview:self.backPreview withQuestion:question];
}

- (void)populatePreview:(SSQuestionPreview *)preview withQuestion:(SSQuestion *)question
{
    preview.lblText.text = question.text;
    preview.imageView.image = (question.image) ? question.image : nil;

    if ([question.answerType isEqualToString:@"text"]) {
        for (int i=0; i<preview.optionsViews.count; i++) {
            SSOptionView *optionView = [preview.optionsViews objectAtIndex:i];
            optionView.alpha = 1.0f;
            if (i < question.options.count){
                NSDictionary *option = [question.options objectAtIndex:i];
                optionView.lblText.text = option[@"text"];
                
                [UIView animateWithDuration:0.4f
                                      delay:0
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     optionView.alpha = 1.0f;
                                 }
                                 completion:NULL];
            }
            else{
                optionView.alpha = 0.0f;
            }
        }
        
        for (int i=0; i<preview.optionsImageViews.count; i++) {
            UIImageView *optionIcon = preview.optionsImageViews[i];
            optionIcon.alpha = 0.0f;
        }
        
        return;
    }
    
    
    for (int i=0; i<preview.optionsViews.count; i++) {
        SSOptionView *optionView = (SSOptionView *)[preview.optionsViews objectAtIndex:i];
        optionView.alpha = 0.0f;
    }
    
    // populate icon with image data:
    for (int i=0; i<preview.optionsImageViews.count; i++) {
        UIImageView *optionIcon = (UIImageView *)preview.optionsImageViews[i];
        
        if (i < question.options.count){
            NSMutableDictionary *option = question.options[i];
            UIImage *imageData = option[@"imageData"];
            if (imageData){
                
                [UIView transitionWithView:optionIcon
                                  duration:0.4f
                                   options:UIViewAnimationOptionTransitionFlipFromLeft
                                animations:^{
                                    optionIcon.image = imageData;
                                    optionIcon.alpha = 1.0f;
                                }
                                completion:NULL];
                
            }
            else{
                optionIcon.alpha = 0.0f;
            }
        }
        else{
            optionIcon.alpha = 0.0f;
        }
    }
}



#pragma mark - SSQuestionPreviewDelegate
- (void)optionSelected:(NSInteger)tag
{
    long i = tag-5000;
    if (i < 0)
        return;
    
    SSQuestion *question = (SSQuestion *)[self.questions objectAtIndex:self.questionIndex];
    
    if ([question.votes containsObject:self.profile.uniqueId]==YES){
        [self showAlert:@"Already Voted" withMessage:@"You already voted on this question."];
        return;
    }
    
    [question addVote:(int)i]; // this updates the question statistics locally
    NSDictionary *option = (NSDictionary *)[question.options objectAtIndex:i];
    NSLog(@"optionSelected: %@", option[@"text"]);
    
    if ([question.answerType isEqualToString:@"text"]){
        for (int j=0; j<self.topPreview.optionsViews.count; j++) {
            SSOptionView *optionView = [self.topPreview.optionsViews objectAtIndex:j];
            
            if (j < question.options.count){ // just to be safe. this shouldn't be necessary.
                NSDictionary *option = (NSDictionary *)[question.options objectAtIndex:j];
                double pct = [(NSString *)option[@"percentage"] doubleValue];
                
                NSArray *optionVotes = (NSArray *)option[@"votes"];
                pct = ((double)optionVotes.count / question.votes.count);
                
                [optionView showPercentage:pct];
            }
        }
    }
    
    else{
        for (int j=0; j<self.topPreview.optionsImageViews.count; j++) {
            SSOptionIcon *optionIcon = [self.topPreview.optionsImageViews objectAtIndex:j];
            
            if (j < question.options.count){ // just to be safe. this shouldn't be necessary.
                NSDictionary *option = (NSDictionary *)[question.options objectAtIndex:j];
                double pct = [(NSString *)option[@"percentage"] doubleValue];
                
                NSArray *optionVotes = (NSArray *)option[@"votes"];
                pct = ((double)optionVotes.count / question.votes.count);
                
                [optionIcon showPercentage:pct];
            }
        }
    }
    
    NSMutableArray *malePercents = [NSMutableArray array];
    NSMutableArray *femalePercents = [NSMutableArray array];
    
    static NSString *maleVotes = @"maleVotes";
    static NSString *femaleVotes = @"femaleVotes";
    for (int j=0; j<question.options.count; j++) {
        NSDictionary *option = (NSDictionary *)question.options[j];
        
        if (option[maleVotes]){
            if (question.totalMaleVotes > 0){
                double malePct = [option[maleVotes] doubleValue] / (double)question.totalMaleVotes;
                [malePercents addObject:[NSNumber numberWithDouble:malePct]];
            }
            else{
                [malePercents addObject:[NSNumber numberWithDouble:0.0f]];
            }
        }

        if (option[femaleVotes]){
            if (question.totalFemaleVotes > 0){
                double femalePct = [option[femaleVotes] doubleValue] / (double)question.totalFemaleVotes;
                [femalePercents addObject:[NSNumber numberWithDouble:femalePct]];
            }
            else{
                [femalePercents addObject:[NSNumber numberWithDouble:0.0f]];
            }
        }

    }
    
    [self.topPreview displayGenderPercents:@{@"male":malePercents, @"female":femalePercents}];
    
    
    //post submitted vote to backend:
    [[SSWebServices sharedInstance] submitVote:self.profile withQuestion:question withSelection:i completionBlock:^(id result, NSError *error){
        if (error){
            // TODO: handle error
            [self showAlert:@"Error" withMessage:[error localizedDescription]];
        }
        else{
            NSDictionary *results = (NSDictionary *)result;
            NSLog(@"%@", [results description]);
            
            NSString *confirmation = [results objectForKey:@"confirmation"];
            if ([confirmation isEqualToString:@"success"]){
                SSQuestion *question = (SSQuestion *)[self.questions objectAtIndex:self.questionIndex];
                NSDictionary *questionInfo = [results objectForKey:@"question"];
                [question populate:questionInfo];
            }

            
            //TODO: populate question with updated info
        }
    }];
}


- (void)viewComments
{
//    NSLog(@"viewComments");
    
    [UIView transitionWithView:self.topPreview
                      duration:0.6f
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        self.topPreview.alpha = 1.0;
                    }
                    completion:^(BOOL finisehd){
                        
                    }];
}

- (void)swipeToNextQuestion
{
    CGRect frame = self.view.frame;
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
                                                                                        self.questionIndex = self.questionIndex%self.questions.count;
                                                                                        
                                                                                        self.currentQuestion = [self.questions objectAtIndex:self.questionIndex];
                                                                                        
                                                                                        NSLog(@"CURRENT QUESTION: %@", self.currentQuestion.text);
                                                                                        
                                                                                        [self loadNextQuestion];
                                                                                    }];
                                                                   
                                                                   
                                                               }];
                                          }];
                     }];
    
}

- (void)skip
{
    [self swipeToNextQuestion];
    
}

- (void)checkPostion
{
    NSLog(@"CHECK POSITION");
    CGRect frame = self.view.frame;
    if (self.topPreview.center.x < 0.10f*frame.size.width){
        NSLog(@"SWAP");
        [self swipeToNextQuestion];
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




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
