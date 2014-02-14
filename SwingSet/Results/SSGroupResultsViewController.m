//
//  SSGroupResultsViewController.m
//  SwingSet
//
//  Created by Denny Kwon on 2/13/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSGroupResultsViewController.h"
#import "SSResultCell.h"


@interface SSGroupResultsViewController ()
@property (strong, nonatomic) NSMutableArray *questions;
@property (strong, nonatomic) UITableView *resultsTable;
@end

@implementation SSGroupResultsViewController
@synthesize group;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeAll;
        self.questions = [NSMutableArray array];
        
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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self.navigationController action:@selector(popViewControllerAnimated:)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.loadingIndicator startLoading];
    [[SSWebServices sharedInstance] fetchQuestionsInGroup:self.group[@"id"] completionBlock:^(id result, NSError *error){
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
    }
    
    SSQuestion *question = self.questions[indexPath.row];
    cell.lblText.text = question.text;
    cell.lblDetails.text = [NSString stringWithFormat:@"%d votes", (int)question.votes.count];
    
    if (question.image){
        cell.icon.image = question.image;
        cell.icon.alpha = 1.0f;
        cell.iconBase.alpha = 1.0f;
    }
    else{
        cell.icon.alpha = 0.0f;
        cell.iconBase.alpha = 0.0f;
    }
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SSResultCell standardHeight];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
