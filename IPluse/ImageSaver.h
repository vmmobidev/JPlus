//
//  ImageSaver.h
//  JPlus
//
//  Created by Varghese Simon on 4/4/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageSaver : NSObject

+ (NSString *)saveImageToDisk:(UIImage *)image forAppID:(NSString *)appID;


@end
