//
//  PersonSelected.h
//  JPlus
//
//  Created by Varghese Simon on 4/8/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DetectedApp;

@interface PersonSelected : NSManagedObject

@property (nonatomic, retain) NSNumber * uniqueID;
@property (nonatomic, retain) NSSet *selectedApps;
@end

@interface PersonSelected (CoreDataGeneratedAccessors)

- (void)addSelectedAppsObject:(DetectedApp *)value;
- (void)removeSelectedAppsObject:(DetectedApp *)value;
- (void)addSelectedApps:(NSSet *)values;
- (void)removeSelectedApps:(NSSet *)values;

@end
