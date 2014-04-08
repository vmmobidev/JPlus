//
//  ImageSaver.m
//  JPlus
//
//  Created by Varghese Simon on 4/4/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "ImageSaver.h"

@implementation ImageSaver

+ (NSString *)saveImageToDisk:(UIImage *)image forAppID:(NSNumber *)appID
{
    NSData *imgData   = UIImageJPEGRepresentation(image, 0.5);

    NSString *imagePath = [ImageSaver imagePathForAppID:appID];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:imagePath])
    {
        if ([imgData writeToFile:imagePath atomically:YES])
        {
            return imagePath;
        }else
        {
            NSLog(@"Cannot save image");
            return nil;
        }
    }else
    {
        return imagePath;
    }
}


+ (NSString *)imagePathForAppID:(NSNumber *)appID
{
    NSString *name = [[appID stringValue] stringByAppendingString:@".jpg"];
    NSArray *docArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = docArray[0];
    NSString *imagePath = [docPath stringByAppendingPathComponent:name];
    
    return imagePath;
}

+ (void)deleteImageAtPath:(NSString *)path
{
    NSError *error;
    
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSLog(@"File is not deleted");
    }else
    {
        NSLog(@"FIle is deleted");
    }
}

@end
