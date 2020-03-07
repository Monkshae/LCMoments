//
//  LCContentSectionViewModel.h
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCDefine.h"
#import "LCContentCellViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCContentSectionViewModel : NSObject

- (instancetype)initWithTweetModel:(LCTweetModel *)model;

- (LCContentCellViewModel *)cellViewModelAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
