//
//  SelectiveViewController.h
//  JPluse
//
//  Created by Varghese Simon on 4/3/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectiveViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *tableData;

@end
