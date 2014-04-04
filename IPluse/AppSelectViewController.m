//
//  AppSelectViewController.m
//  JPluse
//
//  Created by Varghese Simon on 4/3/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "AppSelectViewController.h"
#import "iHasApp.h"
#import "UIImageView+WebCache.h"
#import "DetectedApp.h"

@interface AppSelectViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *detectedApps;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@end

@implementation AppSelectViewController
{
    NSMutableArray *selectedCells;
    iHasApp *detectionObject;
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
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    selectedCells = [[NSMutableArray alloc] init];
    self.collectionView.allowsMultipleSelection = YES;
    
    detectionObject = [[iHasApp alloc] init];
    [self detectApps];
}

- (void)detectApps
{
    if ([UIApplication sharedApplication].networkActivityIndicatorVisible)
    {
        return;
    }

    NSLog(@"Detection begun!");
    
    [self.activityView startAnimating];
    
    [detectionObject detectAppDictionariesWithIncremental:^(NSArray *appDictionaries) {
        
        NSLog(@"Incremental appDictionaries.count: %i", appDictionaries.count);
        NSMutableArray *newAppDictionaries = [NSMutableArray arrayWithArray:self.detectedApps];
        [newAppDictionaries addObjectsFromArray:appDictionaries];
        self.detectedApps = newAppDictionaries;
        
        [self.collectionView reloadData];
    } withSuccess:^(NSArray *appDictionaries) {
        
        NSLog(@"Successful appDictionaries.count: %i", appDictionaries.count);
        self.detectedApps = appDictionaries;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self.activityView stopAnimating];
        [self.collectionView reloadData];
        
        [self saveDataOfApps];
    } withFailure:^(NSError *error) {
        
        NSLog(@"Error: %@", error.localizedDescription);
        self.detectedApps = [NSArray array];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self.activityView stopAnimating];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        [self.collectionView reloadData];
    }];
    
    self.detectedApps = nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.detectedApps count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *appDictionary = [self.detectedApps objectAtIndex:indexPath.row];
    NSString *trackName = [appDictionary objectForKey:@"trackName"];
    
    NSString *iconUrlString = [appDictionary objectForKey:@"artworkUrl512"];
    NSArray *iconUrlComponents = [iconUrlString componentsSeparatedByString:@"."];
    NSMutableArray *mutableIconURLComponents = [[NSMutableArray alloc] initWithArray:iconUrlComponents];
    [mutableIconURLComponents insertObject:@"128x128-75" atIndex:mutableIconURLComponents.count-1];
    iconUrlString = [mutableIconURLComponents componentsJoinedByString:@"."];
    
    UIImageView *innerImageView = (UIImageView *)[cell viewWithTag:100];
    [innerImageView setImageWithURL:[NSURL URLWithString:iconUrlString] placeholderImage:nil];
    
    
    UIImageView *outerImageView = (UIImageView *)[cell viewWithTag:101];

    if ([selectedCells containsObject:indexPath])
    {
        innerImageView.alpha = 1;
        outerImageView.alpha = 1;
        
    }else
    {
        innerImageView.alpha = .3;
        outerImageView.alpha = 0;
    }

//    outerImageView.backgroundColor = [UIColor lightGrayColor];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];

    UIImageView *innerImageView = (UIImageView *)[cell viewWithTag:100];
    innerImageView.alpha = 1;
    
    UIImageView *outerImageView = (UIImageView *)[cell viewWithTag:101];
    outerImageView.alpha = 1;
    
    [selectedCells addObject:indexPath];

}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    UIImageView *innerImageView = (UIImageView *)[cell viewWithTag:100];
    innerImageView.alpha = .3;
    
    UIImageView *outerImageView = (UIImageView *)[cell viewWithTag:101];
    outerImageView.alpha = 0;
    
    [selectedCells removeObject:indexPath];
}

- (void)saveDataOfApps
{
    for (NSDictionary *appDetails in self.detectedApps)
    {
        <#statements#>
    }
}

@end
