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

    [view addSubview:self.contactsTable];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
                [self showAlert:@"Members Invited!" withMessage:@"The selected contacted have been invited to your group and will receive a text invitation."];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                [self showAlert:@"Error" withMessage:[results objectForKey:@"message"]];
            }
            
        }
        
    }];
    
}

- (void)requestAddresBookAccess
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
                
                NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
                [self.contactsList sortUsingDescriptors:@[sort]];
                [self.contactsTable reloadData];
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
    
    NSDictionary *contact = [self.contactsList objectAtIndex:indexPath.row];
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
    NSDictionary *contact = [self.contactsList objectAtIndex:indexPath.row];
    if (!contact)
        return;

    
    NSLog(@"SELECTED: %@", [contact description]);
    if ([self.selectedContacts containsObject:contact]==NO)
        [self.selectedContacts addObject:contact];
    else
        [self.selectedContacts removeObject:contact];
    
    
    [self.contactsTable reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
