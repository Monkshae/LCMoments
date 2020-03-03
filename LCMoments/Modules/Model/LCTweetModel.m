//
//  LCTweetModel.m
//  LCMoments
//
//  Created by Richard on 2020/3/3.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCTweetModel.h"
#import <MJExtension/MJExtension.h>

@implementation LCImageModel
MJExtensionCodingImplementation


@end

@implementation LCSenderModel
MJExtensionCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"nickName" : @"nick"};
}


@end


@implementation LCCommentModel
MJExtensionCodingImplementation


@end


@implementation LCTweetModel
MJExtensionCodingImplementation

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"images" : [LCImageModel class],
             @"comments" : [LCCommentModel class]
    };
}

@end
