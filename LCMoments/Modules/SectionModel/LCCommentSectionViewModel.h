//
//  LCCommentSectionViewModel.h
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCDefine.h"
#import "LCCommentCellViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCCommentSectionViewModel : NSObject<IGListDiffable>

@property (nonatomic, readonly) NSInteger commentCount;

- (instancetype)initWithTweetModel:(LCTweetModel *)model;

- (LCCommentCellViewModel *)cellViewModelAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
