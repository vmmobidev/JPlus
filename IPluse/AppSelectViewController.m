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
#import "ImageSaver.h"
#import "AppDetails.h"
#import "PersonSelected.h"

@interface AppSelectViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *detectedApps;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@end

@implementation AppSelectViewController
{
    NSMutableArray *selectedCells;
    iHasApp *detectionObject;
    
    NSArray *allInstalledApps;
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
    
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    selectedCells = [[NSMutableArray alloc] init];
    self.collectionView.allowsMultipleSelection = YES;
    
    detectionObject = [[iHasApp alloc] init];
    
    allInstalledApps = [DetectedApp findAll];

    if (![allInstalledApps count] > 0)
    {
        [self detectApps];
    }

    NSLog(@"Selected Persons No: %i", [self.selectedPersons count]);
    
    
    NSArray *array = [PersonSelected findAll];
    NSLog(@"person count = %i", [array count]);
    
    for (PersonSelected *personSel in array)
    {
        for (DetectedApp *aDetectedApp in personSel.selectedApps)
        {
            NSLog(@"app name  for person %@ is %@", personSel.uniqueID, aDetectedApp.name);
        }
    }

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
        
    } withSuccess:^(NSArray *appDictionaries) {
        
        NSLog(@"Successful appDictionaries.count: %i", appDictionaries.count);
        self.detectedApps = appDictionaries;
        
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
    }];
    
    self.detectedApps = nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    [imageCache cleanDisk];
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    allInstalledApps = [DetectedApp findAll];
    return [allInstalledApps count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    DetectedApp *aDetectedApp = [allInstalledApps objectAtIndex:indexPath.row];
    
    UIImageView *innerImageView = (UIImageView *)[cell viewWithTag:100];
    if (aDetectedApp.imagePath.length != 0)
    {
        NSData *imageData = [NSData dataWithContentsOfFile:aDetectedApp.imagePath];
                             
        innerImageView.image = [UIImage imageWithData:imageData];
    }else
    {
        NSLog(@"No image path was stored");
    }

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
    for (NSDictionary *appDetailsDict in self.detectedApps)
    {
        AppDetails *appsDetail = [[AppDetails alloc] init];
        appsDetail.appName = appDetailsDict[@"trackName"];
        appsDetail.appID = appDetailsDict[@"trackId"];
        
        NSString *iconUrlString = [appDetailsDict objectForKey:@"artworkUrl512"];
        NSArray *iconUrlComponents = [iconUrlString componentsSeparatedByString:@"."];
        NSMutableArray *mutableIconURLComponents = [[NSMutableArray alloc] initWithArray:iconUrlComponents];
        [mutableIconURLComponents insertObject:@"128x128-75" atIndex:mutableIconURLComponents.count-1];
        iconUrlString = [mutableIconURLComponents componentsJoinedByString:@"."];
        
        [[SDWebImageDownloader sharedDownloader]  downloadImageWithURL:[NSURL URLWithString:iconUrlString] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
           
            if (image && finished)
            {
                appsDetail.imagePath = [ImageSaver saveImageToDisk:image forAppID:appsDetail.appID];
                
                dispatch_async(dispatch_get_main_queue() , ^{
                    [self saveAppDetails:appsDetail];
                    
                    if (self.activityView.isAnimating) {
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                        [self.activityView stopAnimating];
                    }

                });
            }
        }];
    }
}

- (void)saveAppDetails:(AppDetails *)appDetails
{
    DetectedApp *detectedApp = [DetectedApp createEntity];
    
    detectedApp.name = appDetails.appName;
    detectedApp.appID = appDetails.appID;
    detectedApp.imagePath = appDetails.imagePath;
    
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success)
        {
            NSLog(@"Successed in %@", appDetails.appName);
            [self.collectionView reloadData];
        } else
        {
            NSLog(@"Failed to save In %@", appDetails.appName);
            [self.collectionView reloadData];
        }
    }];
}
- (IBAction)refreshButtonPressed:(id)sender
{
    [self refreshAppList];
}

- (void)refreshAppList
{
    [self detectApps];
    NSArray *appsToDelete = [DetectedApp findAll];
    for (DetectedApp *aDetectedApp in appsToDelete)
    {
        [ImageSaver deleteImageAtPath:aDetectedApp.imagePath];
    }
    [DetectedApp truncateAll];
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"successfulSetUpSegue"])
    {
        NSArray *arrayOfAppDetails = [DetectedApp findAll];
        for (PersonSelected *aSelectedPerson in self.selectedPersons)
        {
            for (NSIndexPath *indexPath in selectedCells)
            {
                [aSelectedPerson addSelectedAppsObject:arrayOfAppDetails[indexPath.row]];
            }
        }
        [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    }
}

@end
