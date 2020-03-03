//
//  LCUserInfoModel.h
//  LCMoments
//
//  Created by Richard on 2020/3/3.
//  Copyright © 2020 Richard. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCUserInfoModel : NSObject

@property (nonatomic, strong) NSString *profileImage;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *username;

@end

NS_ASSUME_NONNULL_END
