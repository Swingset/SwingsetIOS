//
//  SSCommentsViewController.m
//  SwingSet
//
//  Created by Denny Kwon on 2/14/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSCommentsViewController.h"

@interface SSCommentsViewController ()
@property (strong, nonatomic) UITableView *commentsTable;
@property (strong, nonatomic) SSTextField *commentField;
@property (strong, nonatomic) UIButton *btnLoadMore;
@end

@implementation SSCommentsViewController
@synthesize question;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeAll;
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    return self;
}

- (void)loadView
{
    UIView *view = [self baseView:YES];
    CGRect frame = view.frame;
    
    CGFloat padding = 15.0f;
    self.commentsTable = [[UITableView alloc] initWithFrame:CGRectMake(padding, padding, frame.size.width-2*padding, frame.size.height-2*padding) style:UITableViewStylePlain];
    self.commentsTable.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin);
    self.commentsTable.delegate = self;
    self.commentsTable.dataSource = self;
    self.commentsTable.layer.cornerRadius = 3.0f;
    self.commentsTable.layer.borderWidth = 0.5f;
    self.commentsTable.layer.borderColor = [[UIColor colorWithRed:0.44f green:0.44f blue:0.44f alpha:1] CGColor];
    self.commentsTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.commentsTable.separatorInset = UIEdgeInsetsZero;
    self.commentsTable.showsVerticalScrollIndicator = NO;
    
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.commentsTable.frame.size.width, 36.0f)];
    headerView.backgroundColor = [UIColor clearColor];
    
    self.commentField = [SSTextField textFieldWithFrame:CGRectMake(5.0f, 5, self.commentsTable.frame.size.width-10.0f, 30.0f) placeholder:@"your comment" keyboard:UIKeyboardTypeAlphabet];
    self.commentField.returnKeyType = UIReturnKeyDone;
    self.commentField.delegate = self;
    [headerView addSubview:self.commentField];
    self.commentsTable.tableHeaderView = headerView;
    
    
    self.btnLoadMore = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnLoadMore.frame = CGRectMake(0, 0, self.commentsTable.frame.size.width, 36.0f);
    [self.btnLoadMore setTitleColor:kGreenNext forState:UIControlStateNormal];
    [self.btnLoadMore setTitle:@"Load More Comments" forState:UIControlStateNormal];
    self.commentsTable.tableFooterView = self.btnLoadMore;
    self.btnLoadMore.alpha = (self.question.comments.count < 10) ? 0 : 1;

    [view addSubview:self.commentsTable];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@", [self.question.comments description]);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self.navigationController action:@selector(popViewControllerAnimated:)];
    
    self.loadingIndicator.lblTitle.text = @"LIKE LIKE LIKE";
    self.loadingIndicator.lblMessage.text = @"Awesome comment. Posting it now...";

    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (self.commentField.text.length>0){
        //submit comment:
        
        NSDictionary *comment = @{@"author":self.profile.uniqueId, @"username":self.profile.name, @"text":self.commentField.text, @"question":self.question.uniqueId};
        
        [self.loadingIndicator startLoading];
        [[SSWebServices sharedInstance] postComment:comment completionBlock:^(id result, NSError *error){
            [self.loadingIndicator stopLoading];
            
            NSDictionary *results = (NSDictionary *)result;
            NSLog(@"%@", [results description]);
            
            NSString *confirmation = [results objectForKey:@"confirmation"];
            if ([confirmation isEqualToString:@"success"]){
                NSDictionary *updatedQuestion = results[@"question"];
                [self.question populate:updatedQuestion];
                self.commentField.text = @"";
                [self.commentsTable reloadData];
                self.btnLoadMore.alpha = (self.question.comments.count < 10) ? 0 : 1;
            }
            else{
                [self showAlert:@"Error" withMessage:results[@"message"]];
            }
        }];
        
    }

    return YES;
}

#pragma mark - Tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.question.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:16.0f];
        cell.detailTextLabel.numberOfLines = 2;
        cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.detailTextLabel.font = [UIFont fontWithName:@"ProximaNova-RegularIt" size:12.0f];
        cell.detailTextLabel.textColor = kGreenNext;
    }
    
    NSDictionary *comment = [self.question.comments objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@\n\n", comment[@"text"]];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ | %@", comment[@"username"], comment[@"pubDate"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *comment = [self.question.comments objectAtIndex:indexPath.row];
    NSString *commentText = [comment[@"text"] stringByAppendingString:@"\n\n"];
    
    CGRect textRect = [commentText boundingRectWithSize:CGSizeMake(self.commentsTable.frame.size.width, 100.0f)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:[UIFont fontWithName:@"ProximaNova-Regular" size:16.0f]}
                                                context:nil];
    
    CGSize size = textRect.size;
    NSLog(@"HEIGHT: %.2f", size.height);
    
    CGFloat min = 64.0f;
    return (size.height < min) ? min : size.height+70.0f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.commentField.isFirstResponder)
        [self.commentField resignFirstResponder];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
