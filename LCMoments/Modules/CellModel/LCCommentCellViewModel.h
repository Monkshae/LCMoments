//
//  LCCommentCellViewModel.h
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCCommentCellViewModel : NSObject

@property (nonatomic, readonly) NSAttributedString *commentAttributedString;
@property (nonatomic, readonly) CGFloat cellHeight;

- (instancetype)initWithCommentModel:(LCCommentModel *)model;

@end

NS_ASSUME_NONNULL_END
