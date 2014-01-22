//
//  SSHomeViewController.m
//  SwingSet
//
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.



#import "SSHomeViewController.h"

@interface SSHomeViewController ()
@property (strong, nonatomic) NSMutableArray *publicQuestions;
@property (strong, nonatomic) UIScrollView *questionsContainer;
@property (strong, nonatomic) SSQuestion *currentQuestion;
@property (nonatomic) int questionIndex;
@end

@implementation SSHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeAll;
        self.questionIndex = 0;
        self.publicQuestions = [NSMutableArray array];
        
    }
    return self;
}

- (void)loadView
{
    UIView *view = [self baseView:YES];
    CGRect frame = view.frame;
    
    CGFloat y = 0.0f;
    self.questionsContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, y, frame.size.width, frame.size.height)];
    self.questionsContainer.delegate = self;
    self.questionsContainer.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight);
    self.questionsContainer.backgroundColor = [UIColor clearColor];
    self.questionsContainer.pagingEnabled = YES;
    [view addSubview:self.questionsContainer];
    
    
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
    
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Skip"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(nextQuestion)];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.publicQuestions.count > 0)
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
                [self.publicQuestions addObject:[SSQuestion questionWithInfo:questionInfo]];
                [self layoutQuestions];
            }
        }
        else{
            [self showAlert:@"Error" withMessage:[results objectForKey:@"message"]];
        }
    }];
}


- (void)layoutQuestions
{
    self.questionsContainer.contentSize = CGSizeMake(self.publicQuestions.count*self.questionsContainer.frame.size.width, 0);
    
    CGRect frame = self.questionsContainer.frame;
    for (int i=0; i<self.publicQuestions.count; i++) {
        SSQuestion *question = [self.publicQuestions objectAtIndex:i];
        
        SSQuestionView *questionView = [[SSQuestionView alloc] initWithFrame:CGRectMake(i*frame.size.width, 0.0f, frame.size.width, frame.size.height)];
        [questionView addTarget:self forAction:@selector(optionSelected:)];
        questionView.lblQuestion.text = question.text;
        
        
        for (int k=0; k<question.options.count; k++) {
            NSDictionary *option = [question.options objectAtIndex:k];
            if (k==0){
                questionView.option1View.lblText.text = option[@"text"];
                questionView.option1View.alpha = 1.0f;
            }
            if (k==1){
                questionView.option2View.lblText.text = option[@"text"];
                questionView.option2View.alpha = 1.0f;
            }
            if (k==2){
                questionView.option3View.lblText.text = option[@"text"];
                questionView.option3View.alpha = 1.0f;
            }
            if (k==3){
                questionView.option4View.lblText.text = option[@"text"];
                questionView.option4View.alpha = 1.0f;
            }
        }
        
        [self.questionsContainer addSubview:questionView];
    }
}

- (void)optionSelected:(NSNumber *)tag
{
    long index = [tag longValue]-1000;
    if (index < 0)
        return;

    NSLog(@"OPTION SELECTED: %ld", index);
}

- (void)nextQuestion
{
    self.questionIndex = (self.questionIndex+1) % self.publicQuestions.count;
    NSLog(@"nextQuestion: %d", self.questionIndex);
}

- (void)setQuestionIndex:(int)questionIndex
{
    if (_questionIndex==questionIndex)
        return;
    
    _questionIndex = questionIndex;
    self.currentQuestion = [self.publicQuestions objectAtIndex:_questionIndex];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    double p = self.questionsContainer.contentOffset.x / self.questionsContainer.frame.size.width;
    
    self.questionIndex = (int)p;
    NSLog(@"scrollViewDidEndDecelerating: %d", self.questionIndex);
    NSLog(@"%@", self.currentQuestion.text);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndScrollingAnimation:");
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
