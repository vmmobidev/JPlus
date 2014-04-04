//
//  ContactSelectionViewController.m
//  JPluse
//
//  Created by Varghese Simon on 4/3/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "ContactSelectionViewController.h"

@interface ContactSelectionViewController ()

@property (weak, nonatomic) IBOutlet UIButton *allCOntactsButton;
@property (weak, nonatomic) IBOutlet UIButton *selectiveContactsButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@end

@implementation ContactSelectionViewController

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
    
    NSLog(@"%@",self.nameFromLoginView);
    if (!self.nameFromLoginView)
    {
        self.nameLable.text = @"JUSTIN'S JPLUS BRACELET";
    }else
    {
        NSString *nameString = [NSString stringWithFormat:@"%@'s JPLUS BRACELET",self.nameFromLoginView];
        self.nameLable.text = nameString;
    }

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
- (IBAction)allContactsButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (!button.selected)
    {
        button.selected = YES;
        [button setImage:[UIImage imageNamed:@"circle.png"] forState:(UIControlStateSelected)];
        self.selectiveContactsButton.selected = NO;
    }else
    {
        button.selected = NO;
    }
}
- (IBAction)selectiveContactsButton:(UIButton *)sender
{
    UIButton *button = (UIButton *)sender;
    if (!button.selected)
    {
        button.selected = YES;
        [button setImage:[UIImage imageNamed:@"circle.png"] forState:(UIControlStateSelected)];
        self.allCOntactsButton.selected = NO;
    }else
    {
        button.selected = NO;
    }
}
- (IBAction)performNavToNextView:(id)sender
{
    if (self.allCOntactsButton.selected || self.selectiveContactsButton.selected)
    {
        if (self.allCOntactsButton.selected)
        {
            [self performSegueWithIdentifier:@"AllContactsSegue" sender:nil];
        }else if (self.selectiveContactsButton.selected)
        {
            [self performSegueWithIdentifier:@"selectiveContactsSegue" sender:nil];
        }
    }
}

@end
