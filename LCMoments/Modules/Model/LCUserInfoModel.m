//
//  LCUserInfoModel.m
//  LCMoments
//
//  Created by Richard on 2020/3/3.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCUserInfoModel.h"
#import <MJExtension/MJExtension.h>

@implementation LCUserInfoModel
MJExtensionCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"profileImage" : @"profile-image",
             @"nickName" : @"nick"};
}

@end
