//
//  DetectedApp.h
//  JPlus
//
//  Created by Varghese Simon on 4/8/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PersonSelected;

@interface DetectedApp : NSManagedObject

@property (nonatomic, retain) NSNumber * appID;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *personsToNotify;
@end

@interface DetectedApp (CoreDataGeneratedAccessors)

- (void)addPersonsToNotifyObject:(PersonSelected *)value;
- (void)removePersonsToNotifyObject:(PersonSelected *)value;
- (void)addPersonsToNotify:(NSSet *)values;
- (void)removePersonsToNotify:(NSSet *)values;

@end
