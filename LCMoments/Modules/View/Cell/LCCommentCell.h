//
//  LCCommentCell.h
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCCommentCellViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCCommentCell : UICollectionViewCell

- (void)feedCellWithViewModel:(LCCommentCellViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
