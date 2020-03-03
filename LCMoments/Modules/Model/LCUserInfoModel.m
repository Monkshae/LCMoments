//
//  LCUserInfoModel.m
//  LCMoments
//
//  Created by Richard on 2020/3/3.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCUserInfoModel.h"

@implementation LCUserInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"profileImage" : @"profile-image",
             @"nickName" : @"nick"};
}

@end
