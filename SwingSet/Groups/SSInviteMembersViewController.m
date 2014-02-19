//
//  SSInviteMembersViewController.m
//  SwingSet
//
//  Created by Denny Kwon on 2/3/14.
//  Copyright (c) 2014 SwingSet Labs. All rights reserved.
//

#import "SSInviteMembersViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


@interface SSInviteMembersViewController ()
@property (strong, nonatomic) NSMutableArray *contactsList;
@property (strong, nonatomic) UITableView *contactsTable;
@property (strong, nonatomic) NSMutableArray *selectedContacts;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *searchResults;
@end


@implementation SSInviteMembersViewController
@synthesize group;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeAll;
        self.contactsList = [NSMutableArray array];
        self.selectedContacts = [NSMutableArray array];
        self.searchResults = [NSMutableArray array];
    }
    return self;
}

- (void)loadView
{
    UIView *view = [self baseView:YES];
    CGRect frame = view.frame;
    
    
    self.contactsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
    self.contactsTable.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight);
    self.contactsTable.delegate = self;
    self.contactsTable.dataSource = self;
    self.contactsTable.backgroundColor = kGrayTable;
    self.contactsTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.contactsTable.separatorInset = UIEdgeInsetsZero;

    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    self.contactsTable.tableHeaderView = self.searchBar;
    self.searchBar.delegate = self;

    [view addSubview:self.contactsTable];
    
    
    self.view = view;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSLog(@"controller shouldReloadTableForSearchString");
    
//    [self.foundItems removeAllObjects];
    /*before starting the search is necessary to remove all elements from the
     array that will contain found items */
    
    NSArray *contactsGroup;
    
    /* in this loop I search through every element (group) (see the code on top) in
     the "originalData" array, if the string match, the element will be added in a
     new array called newGroup. Then, if newGroup has 1 or more elements, it will be
     added in the "searchData" array. shortly, I recreated the structure of the
     original array "originalData". */
    
    for(group in self.contactsList) //take the n group (eg. group1, group2, group3)
        //in the original data
    {
        NSMutableArray *newGroup = [[NSMutableArray alloc] init];
        NSString *element;
        
        for(element in contactsGroup) //take the n element in the group
        {                    //(eg. @"Napoli, @"Milan" etc.)
            NSRange range = [element rangeOfString:searchString
                                           options:NSCaseInsensitiveSearch];
            
            if (range.length > 0) { //if the substring match
                [newGroup addObject:element]; //add the element to group
            }
        }
        
        if ([newGroup count] > 0) {
//            [self.foundItems addObject:newGroup];
        }
        
    }
    return YES;
    
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarShouldBeginEditing");
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar  // called when text starts editing
{
    NSLog(@"searchBarTextDidBeginEditing");
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar                       // return NO to not resign first responder
{
    NSLog(@"searchBarShouldEndEditing");
    [searchBar resignFirstResponder];
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar  // called when text ends editing
{
    NSLog(@"searchBarTextDidEndEditing: %@", searchBar.text);
    [searchBar resignFirstResponder];
    
    [self.searchResults removeAllObjects];
    
    NSString *filter = searchBar.text.lowercaseString;
    for (NSDictionary *contact in self.contactsList) {
        
        NSString *firstName = contact[@"firstName"];
        
        if ([[firstName lowercaseString] rangeOfString:filter].location != NSNotFound){
            [self.searchResults addObject:contact];
        }
        
        NSString *lastName = contact[@"lastName"];
        if (lastName){
            if ([[lastName lowercaseString] rangeOfString:filter].location != NSNotFound){
                
                if ([self.searchResults containsObject:contact]==NO)
                    [self.searchResults addObject:contact];
            }
        }
    }
    
    [self.contactsTable reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    NSLog(@"searchBarCancelButtonClicked:");
    [searchBar resignFirstResponder];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"searchBarSearchButtonClicked:");
    [searchBar resignFirstResponder];
    

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.contactSearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    
    //self.contactSearchDisplayController.delegate = self;
    
//    self.contactSearchDisplayController.searchResultsDataSource = self;
    self.contactsTable.tableHeaderView = self.searchBar;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self.navigationController action:@selector(popViewControllerAnimated:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(inviteMembers:)];
    
    self.loadingIndicator.lblTitle.text = @"Just a second...";
    self.loadingIndicator.lblMessage.text = @"Pulling up your contacts.";
    
    
    [self requestAddresBookAccess];
}

- (void)inviteMembers:(UIBarButtonItem *)btn
{
    if (self.selectedContacts.count==0){
        [self showAlert:@"No Contacts Selected" withMessage:@"Please select at least one contact to invite to Swingset."];
        return;
    }
    
    [self.loadingIndicator startLoading];
    [[SSWebServices sharedInstance] inviteMembers:self.selectedContacts toGroup:self.group completionBlock:^(id result, NSError *error){
        
        [self.loadingIndicator stopLoading];
        if (error){
            //TODO: handle error
            [self showAlert:@"Error" withMessage:[error localizedDescription]];
            
        }
        else {
            NSDictionary *results = (NSDictionary *)result;
            NSLog(@"%@", [results description]);
            
            NSString *confirmation = [results objectForKey:@"confirmation"];
            if ([confirmation isEqualToString:@"success"]){
                [self showAlert:@"It Worked!" withMessage:@"We texted invites to your group members. Tell them to sign up with phone number to automatically join."];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                [self showAlert:@"Error" withMessage:[results objectForKey:@"message"]];
            }
            
        }
        
    }];
    
}
//search for beginning of first or last name, have search work for only prefixes
- (void)requestAddresBookAccess//call to get address book, latency
{
    [self.loadingIndicator startLoading];
    
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"Address book error");
                //                [self.delegate addressBookHelperError:self];
            }
            else if (granted) {
                NSLog(@"Address book access granted");
                NSArray *allContacts = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
                for( int i=0; i<allContacts.count; i++) {
                    ABRecordRef contact = (__bridge ABRecordRef)allContacts[i];
                    
                    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(contact, kABPersonFirstNameProperty);
                    NSString *lastName = (__bridge NSString *)ABRecordCopyValue(contact, kABPersonLastNameProperty);
                    
                    // email:
                    ABMultiValueRef emails = ABRecordCopyValue(contact, kABPersonEmailProperty);
                    NSString *email = (__bridge NSString *)ABMultiValueCopyValueAtIndex(emails, 0);
                    
                    // phone:
                    ABMultiValueRef phones = ABRecordCopyValue(contact, kABPersonPhoneProperty);
                    NSString *phoneNumber = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phones, 0);
                    
                    
                    // image:
                    bool hasImage = ABPersonHasImageData(contact);
                    UIImage *image = nil;
                    if (hasImage==true){
                        NSData *imageData = (__bridge NSData *)ABPersonCopyImageDataWithFormat(contact, kABPersonImageFormatThumbnail);
                        image = [UIImage imageWithData:imageData];
                    }
                    
                    
                    NSMutableDictionary *contactInfo = [NSMutableDictionary dictionary];
                    BOOL enoughInfo = NO;
                    if (firstName != nil && phoneNumber != nil)
                        enoughInfo = YES;
                    
                    if (enoughInfo){
                        contactInfo[@"firstName"] = firstName;
                        contactInfo[@"phoneNumber"] = phoneNumber;
                        
                        NSString *formattedNumber = @"";
                        static NSString *numbers = @"0123456789";
                        for (int i=0; i<phoneNumber.length; i++) {
                            NSString *character = [phoneNumber substringWithRange:NSMakeRange(i, 1)];
                            if ([numbers rangeOfString:character].location!=NSNotFound)
                                formattedNumber = [formattedNumber stringByAppendingString:character];
                        }
                        
                        contactInfo[@"formattedNumber"] = formattedNumber;
                        
                        
                        if (lastName != nil)
                            contactInfo[@"lastName"] = lastName;
                        
                        if (email != nil)
                            contactInfo[@"email"] = email;
                        
                        if (image != nil)
                            contactInfo[@"image"] = image;
                        
                        
                        [self.contactsList addObject:contactInfo];
                    }
                    
                    
                }
                
                NSLog(@"%@", [self.contactsList description]);
                
                NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];//sorted by first name
                [self.contactsList sortUsingDescriptors:@[sort]];
                [self.contactsTable reloadData];//address book loads
                [self.loadingIndicator stopLoading];
                
                CFRelease(addressBook);
            }
            else {
                NSLog(@"Address book access denied");
                [self showAlert:@"Addres Book Unauthorized" withMessage:@"Please go to the settings app and allow Swingset to access your address book to invite members."];
            }
            
        });
    });
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchResults.count > 0)
        return self.searchResults.count;
    
    return self.contactsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.textLabel.font = [UIFont fontWithName:@"ProximaNova-Black" size:14.0];
        cell.textLabel.textColor = kLightBlue;
        cell.backgroundColor = kGrayTable;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *contact = nil;
    if (self.searchResults.count > 0)
        contact = [self.searchResults objectAtIndex:indexPath.row];
    else
        contact = [self.contactsList objectAtIndex:indexPath.row];
    
    
    
    if (contact[@"lastName"]) // first name and last name
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", contact[@"firstName"], contact[@"lastName"]];
    else // first name only
        cell.textLabel.text = [NSString stringWithFormat:@"%@", contact[@"firstName"]];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", contact[@"phoneNumber"]];
    cell.textLabel.textColor = ([self.selectedContacts containsObject:contact]==YES) ? kGreenNext : [UIColor blackColor];
    cell.imageView.image = (contact[@"image"]) ? (contact[@"image"]) : nil;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *contact = nil;
    if (self.searchResults.count > 0)
        contact = [self.searchResults objectAtIndex:indexPath.row];
    else
        contact = [self.contactsList objectAtIndex:indexPath.row];

    if (!contact)
        return;
    
    
    NSLog(@"SELECTED: %@", [contact description]);
    if ([self.selectedContacts containsObject:contact]==NO)
        [self.selectedContacts addObject:contact];
    else
        [self.selectedContacts removeObject:contact];
    
    
    [self.contactsTable reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.searchBar.isFirstResponder)
        return;
    
    [self.searchBar resignFirstResponder];
    if (self.searchBar.text.length==0){
        self.searchResults = [NSMutableArray array];
        [self.contactsTable reloadData];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
