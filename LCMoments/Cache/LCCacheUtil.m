//
//  LCCacheUtil.m
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCCacheUtil.h"

@implementation LCCacheUtil

+ (NSString *)collectionPath{
    static NSString *collectionPath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        collectionPath = [documentPath stringByAppendingPathComponent:@"collection"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:collectionPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:collectionPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });

    return collectionPath;
}

+ (BOOL)saveCustomObjects:(id)obj fileName:(NSString *)fileName {
    NSAssert(fileName.length, @"please input correct file name");
    NSAssert(obj, @"please pass no nil value");

    NSString *filePath = [[self collectionPath] stringByAppendingPathComponent:fileName];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
    return [data writeToFile:filePath atomically:YES];
}

+ (id)readCustomObjectsFrom:(NSString *)fileName {
    NSAssert(fileName.length, @"please input correct file name");
    NSString *filePath = [[self collectionPath] stringByAppendingPathComponent:fileName];

    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (!data) {
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
