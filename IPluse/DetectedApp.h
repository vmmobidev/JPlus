//
//  DetectedApp.h
//  JPlus
//
//  Created by Varghese Simon on 4/4/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DetectedApp : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * appID;
@property (nonatomic, retain) NSString * imagePath;

@end
