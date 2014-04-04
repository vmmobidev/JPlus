//
//  ImageSaver.m
//  JPlus
//
//  Created by Varghese Simon on 4/4/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "ImageSaver.h"

@implementation ImageSaver

+ (NSString *)saveImageToDisk:(UIImage *)image forAppID:(NSString *)appID
{
    NSData *imgData   = UIImageJPEGRepresentation(image, 0.5);
    NSString *name = [appID stringByAppendingString:@".jpg"];
    NSArray *docArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = docArray[0];
    NSString *imagePath = [docPath stringByAppendingPathComponent:name];
    
    if ([imgData writeToFile:imagePath atomically:YES])
    {
        return imagePath;
    }else
    {
        return nil;
    }
}

@end
