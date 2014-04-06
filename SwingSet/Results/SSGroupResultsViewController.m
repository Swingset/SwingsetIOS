//
//  SSGroupResultsViewController.m
//  SwingSet
//
//  Created by Denny Kwon on 2/13/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSGroupResultsViewController.h"
#import "SSResultCell.h"
#import "SSCommentsViewController.h"


@interface SSGroupResultsViewController ()
@property (strong, nonatomic) NSMutableArray *questions;
@property (strong, nonatomic) UITableView *resultsTable;
@property (strong, nonatomic) SSQuestion *removeQuestion;
@end

@implementation SSGroupResultsViewController
@synthesize group;
@synthesize canGoBack;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeAll;
        self.questions = [NSMutableArray array];
        self.removeQuestion = nil;
        self.canGoBack = YES;
        
    }
    return self;
}

- (void)loadView
{
    UIView *view = [self baseView:YES];
    CGRect frame = view.frame;
    
    UILabel *lblQuestionsAnswered = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, 36.0f)];
    lblQuestionsAnswered.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    lblQuestionsAnswered.font = [UIFont fontWithName:@"ProximaNova-Bold" size:24.0f];
    lblQuestionsAnswered.textColor = [UIColor blackColor];
    lblQuestionsAnswered.textAlignment = NSTextAlignmentCenter;
    lblQuestionsAnswered.text = @"Questions Answered";
    lblQuestionsAnswered.backgroundColor = [UIColor clearColor];
    [view addSubview:lblQuestionsAnswered];
    
    CGFloat y = lblQuestionsAnswered.frame.size.height;

    self.resultsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, y, frame.size.width, frame.size.height-y)];
    self.resultsTable.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin);
    self.resultsTable.dataSource = self;
    self.resultsTable.delegate = self;
    self.resultsTable.backgroundColor = kGrayTable;
    self.resultsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.resultsTable.separatorInset = UIEdgeInsetsZero;
    self.resultsTable.showsVerticalScrollIndicator = NO;
    self.resultsTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.resultsTable.frame.size.width, 15.0f)];
    [view addSubview:self.resultsTable];
    
    
    
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.canGoBack){
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self.navigationController action:@selector(popViewControllerAnimated:)];
    }
    else{
        SSNavigationController *navController = (SSNavigationController *)self.navigationController;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btnMenu.png"]
                                                                                      style:UIBarButtonItemStylePlain
                                                                                     target:navController
                                                                                     action:@selector(toggle)];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.questions.count > 0)
        return;
    
    [self.loadingIndicator startLoading];
    [[SSWebServices sharedInstance] fetchQuestionsInGroup:self.group.groupId completionBlock:^(id result, NSError *error){
        [self.loadingIndicator stopLoading];
        
        if (error){
            
        }
        else{
            NSDictionary *results = (NSDictionary *)result;
            NSLog(@"%@", [results description]);
            
            if ([results[@"confirmation"] isEqualToString:@"success"]){
                NSArray *questionsList = results[@"questions"];
                
                for (int i=0; i<questionsList.count; i++) {
                    NSDictionary *questionInfo = questionsList[i];
                    SSQuestion *question = [SSQuestion questionWithInfo:questionInfo];
                    
                    if ([question.votes containsObject:self.profile.uniqueId])
                        [self.questions addObject:question];
                }
                
                [self.resultsTable reloadData];
                
            }
        }
        
    }];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ID";
    SSResultCell *cell = (SSResultCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil){
        cell = [[SSResultCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.delegate = self;
    }
    
    SSQuestion *question = self.questions[indexPath.row];
    cell.tag = indexPath.row;
    cell.lblText.text = question.text;
    cell.lblDetails.text = [NSString stringWithFormat:@"%d votes\nby %@  |  %@", (int)question.votes.count, question.username, question.pubDate];
    [cell.btnComments setTitle:[NSString stringWithFormat:@"%d comments", (int)question.comments.count] forState:UIControlStateNormal];
    
    if (question.image){
        cell.icon.image = question.image;
        cell.icon.alpha = 1.0f;
        cell.iconBase.alpha = 1.0f;
    }
    else{
        cell.icon.alpha = 0.0f;
        cell.iconBase.alpha = 0.0f;
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
    
    [cell displayGenderPercents:@{@"male":malePercents, @"female":femalePercents}];
    
    
    
    
    // Text Answers
    if ([question.answerType isEqualToString:@"text"]) {
        for (int i=0; i<4; i++) {
            SSOptionView *optionView = cell.optionViews[i];
            SSOptionIcon *optionIcon = cell.optionsImageViews[i];
            optionIcon.alpha = 0.0f;
            if (i < question.options.count){
                NSDictionary *option = question.options[i];
                optionView.alpha = 1.0f;
                optionView.lblText.text = option[@"text"];
                
                [optionView showPercentage:[option[@"percentage"] doubleValue] animated:NO];
            }
            else{
                optionView.alpha = 0.0f;
            }
        }
        return cell;
    }
    
    // Image Answers
    for (int i=0; i<4; i++) {
        SSOptionView *optionView = cell.optionViews[i];
        SSOptionIcon *optionIcon = cell.optionsImageViews[i];
        optionView.alpha = 0.0f;
        if (i < question.options.count){
            NSDictionary *option = question.options[i];
            optionIcon.alpha = 1.0f;
            UIImage *imageData = option[@"imageData"];
            if (imageData){
                optionIcon.image = imageData;
                [optionIcon showPercentage:[option[@"percentage"] doubleValue] animated:NO];
            }
            else{
                optionIcon.alpha = 0.0f;
            }
        }
        else{
            optionIcon.alpha = 0.0f;
        }
        
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tableView didSelectRowAtIndexPath:");
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SSResultCell standardHeight];
}

- (void)deleteQuestion:(int)index
{
    SSQuestion *question = self.questions[index];
    if ([question.author isEqualToString:self.profile.uniqueId]==NO){
        [self showAlert:@"Error" withMessage:@"You are not the author of this question. Only the author can remove the question."];
        return;
    }
    
    
    self.removeQuestion = question;
    NSLog(@"DELETE QUESTION: %@", question.text);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are You Sure?"
                                                    message:@"This will remove the question permanently."
                                                   delegate:self
                                          cancelButtonTitle:@"Yes"
                                          otherButtonTitles:@"No", nil];
    [alert show];
}

- (void)viewComments:(int)index
{
    SSQuestion *question = self.questions[index];
    NSLog(@"VIEW COMMENTS: %@", question.text);

    
    SSCommentsViewController *commentsVc = [[SSCommentsViewController alloc] init];
    commentsVc.question = question;
    [self.navigationController pushViewController:commentsVc animated:YES];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"alertView clickedButtonAtIndex: %d", (int)buttonIndex);
    if (buttonIndex>0)
        return;
    
    if (!self.removeQuestion)
        return;
    
    NSLog(@"REMOVE QUESTION: %@", self.removeQuestion.text);
    
    [self.loadingIndicator startLoading];
    [[SSWebServices sharedInstance] deleteQuestion:self.removeQuestion completionBlock:^(id result, NSError *error){
        [self.loadingIndicator stopLoading];
        if (error) {
            [self showAlert:@"Error" withMessage:@"There was an error. Please try again."];
        }
        else {
            NSDictionary *results = (NSDictionary *)result;
            NSString *confirmation = [results objectForKey:@"confirmation"];
            
            if ([confirmation isEqualToString:@"success"]){
                [self.questions removeObject:self.removeQuestion];
                self.removeQuestion = nil;
                [self.resultsTable reloadData];
            }
            else{
                [self showAlert:@"Error" withMessage:results[@"message"]];
            }
            
        }
    }];
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
