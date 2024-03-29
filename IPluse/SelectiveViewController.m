//
//  SelectiveViewController.m
//  JPluse
//
//  Created by Varghese Simon on 4/3/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "SelectiveViewController.h"
#import <AddressBook/AddressBook.h> 
#import "Person.h"
#import "PersonSelected.h"
#import "AppSelectViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SelectiveViewController ()
//@property (weak, nonatomic) IBOutlet UISearchBar *contactSearchBar;
//@property (strong, nonatomic)NSMutableArray *searchedContactsArray;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation SelectiveViewController
{
    ABAddressBookRef addressBook;
    NSMutableArray *selectedContacts, *personsToPass;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    self.navigationItem.titleView = titleView;
    
    selectedContacts = [[NSMutableArray alloc] init];
    personsToPass = [[NSMutableArray alloc] init];
    
    self.searchField.layer.cornerRadius = 5;
    self.okButton.enabled = NO;

    
    self.tableData=[[NSMutableArray alloc] init];
    [self getAllContact];
    
}
- (IBAction)searchKeyResign:(UITextField *)sender
{
    [sender resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    
    return [self.tableData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObject = [[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:self options:nil];
        cell = topLevelObject[0];
    }
    
    UIImageView *profileImageView = (UIImageView *)[cell viewWithTag:10];
    UILabel *fullNameLabel = (UILabel *)[cell viewWithTag:11];
    UIButton *imageButton = (UIButton *)[cell viewWithTag:12];
    
    Person *person = [self.tableData objectAtIndex:indexPath.row];
    
    profileImageView.image = person.profileImage;
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = profileImageView.bounds;
    maskLayer.contents = (__bridge id)[UIImage imageNamed:@"circleMask.png"].CGImage;
    profileImageView.layer.mask = maskLayer;
    fullNameLabel.text = person.fullName;

    if ([selectedContacts containsObject:indexPath])
    {
        imageButton.selected = YES;
    }else
    {
        imageButton.selected = NO;
    }
    
    [imageButton setImage:[UIImage imageNamed:@"circle.png"] forState:(UIControlStateSelected)];
    
    return cell;
}



-(void)getAllContact
{
    CFErrorRef error = NULL;
    
     addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if (ABAddressBookGetAuthorizationStatus()==kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (granted) {
                
                [self getContactsFromAddressBook];
            }
        });
        
    }else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        [self getContactsFromAddressBook];
    }

}


- (void)getContactsFromAddressBook{
    NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSUInteger i = 0;
    for (i = 0; i < [allContacts count]; i++)
    {
        Person *person = [[Person alloc] init];
        
        ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
        person.uniqueID = ABRecordGetRecordID(contactPerson);
        
        NSString *firstName = (__bridge_transfer NSString
                               *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
        NSString *lastName =  (__bridge_transfer NSString
                               *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
        
        firstName = firstName ? firstName:@"";
        lastName = lastName? lastName: @"";
        NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        
        person.firstName = firstName;
        person.lastName = lastName;
        person.fullName = fullName;
        
        //email
        ABMultiValueRef emails = ABRecordCopyValue(contactPerson,
                                                   kABPersonEmailProperty);
        NSUInteger j = 0;
        for (j = 0; j < ABMultiValueGetCount(emails); j++)
        {
            NSString *email = (__bridge_transfer NSString
                               *)ABMultiValueCopyValueAtIndex(emails, j);
            if (j == 0)
            {
                person.homeEmail = email;
                NSLog(@"person.unique = %i ", person.uniqueID);
            }
            else if (j==1)
                person.workEmail = email;
        }
        
        if (ABPersonHasImageData(contactPerson))
        {
            NSData *imageData = (__bridge_transfer NSData *) ABPersonCopyImageDataWithFormat(contactPerson,kABPersonImageFormatThumbnail);
            person.profileImage = [UIImage imageWithData:imageData];
        }

        [self.tableData addObject:person];
    }

    CFRelease(addressBook);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *imageButton = (UIButton *)[cell viewWithTag:12];
    
    if (imageButton.selected)
    {
        imageButton.selected = NO;
        [selectedContacts removeObject:indexPath];
        
        if ([selectedContacts count] == 0)
        {
            self.okButton.enabled = NO;
        }
    }else
    {
        imageButton.selected = YES;
        [selectedContacts addObject:indexPath];
        self.okButton.enabled = YES;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"selectiveContactsSegue"])
    {
        [personsToPass removeAllObjects];
        for (NSIndexPath *indexPath in selectedContacts)
        {
            Person *aSelectedPerson = self.tableData[indexPath.row];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.uniqueID == %i", aSelectedPerson.uniqueID];
            NSArray *arrayOfPersonsSaved = [PersonSelected findAllWithPredicate:predicate];
            PersonSelected *dbPerson;
        
            NSLog(@"self.uniqueID = %i", aSelectedPerson.uniqueID);
            if ([arrayOfPersonsSaved count] != 0)
            {
                dbPerson = [arrayOfPersonsSaved objectAtIndex:0];
            }else
            {
                dbPerson = [PersonSelected createEntity];
            }
            
            dbPerson.uniqueID = [NSNumber numberWithInteger:aSelectedPerson.uniqueID];
            [personsToPass addObject:dbPerson];
        }
        
        AppSelectViewController *appSelectVC = (AppSelectViewController *)segue.destinationViewController;
        appSelectVC.selectedPersons = personsToPass;
    }
}

//-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
//    
//    [self.searchedContactsArray removeAllObjects];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.fullName contains[c] %@",searchText];
//    
//    self.searchedContactsArray = [NSMutableArray arrayWithArray:[self.tableData filteredArrayUsingPredicate:predicate]];
//}
//
//#pragma mark - UISearchDisplayController Delegate Methods
//
//-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
//    
//    [self filterContentForSearchText:searchString scope:
//     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
//    return YES;
//}
//-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
//    
//    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
//     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
//    return YES;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
