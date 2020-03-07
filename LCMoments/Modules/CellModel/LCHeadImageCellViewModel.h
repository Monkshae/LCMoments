//
//  LCHeadImageCellViewModel.h
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCHeadImageCellViewModel : NSObject<IGListDiffable>

@property (nonatomic, readonly) NSString *headImage;
@property (nonatomic, readonly) NSString *headAvatar;
@property (nonatomic, readonly) NSString *headUserName;

@property (nonatomic, readonly) CGFloat cellHeight;

- (instancetype)initWithUserInfoModel:(LCUserInfoModel *)model section:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
