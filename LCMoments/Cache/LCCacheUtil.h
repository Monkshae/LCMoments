//
//  LCCacheUtil.h
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCCacheUtil : NSObject

+ (BOOL)saveCustomObjects:(id)obj fileName:(NSString *)fileName;

+ (id)readCustomObjectsFrom:(NSString *)fileName;
@end

NS_ASSUME_NONNULL_END
