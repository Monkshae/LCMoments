//
//  LCHeadImageSectionViewModel.h
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCDefine.h"
#import "LCHeadImageCellViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCHeadImageSectionViewModel : NSObject<IGListDiffable>

@property (nonatomic, readonly) BOOL isShowHeadPart;

- (instancetype)initWithUserInfoModel:(LCUserInfoModel *)model section:(NSInteger)section;

- (LCHeadImageCellViewModel *)cellViewModelAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
