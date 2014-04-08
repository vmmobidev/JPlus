//
//  ViewController.m
//  IPluse
//
//  Created by Varghese Simon on 4/3/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "ViewController.h"
#import "ContactSelectionViewController.h"

@interface ViewController ()

- (IBAction)loginAction:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    self.navigationItem.titleView = titleView;

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:.94 green:.64 blue:.78 alpha:1];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }else
    {
        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:.94 green:.64 blue:.78 alpha:1]];
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:.94 green:.64 blue:.78 alpha:1];

    }
    
}
- (IBAction)keyBoardResign:(id)sender
{
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender {
    
    ContactSelectionViewController *contactVC = [[ContactSelectionViewController alloc] init];
    contactVC.nameFromLoginView = self.userName.text;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"loginSegue"])
    {
        ContactSelectionViewController *contactVC = (ContactSelectionViewController *)segue.destinationViewController;
        contactVC.nameFromLoginView = self.userName.text;
    }
}
@end
