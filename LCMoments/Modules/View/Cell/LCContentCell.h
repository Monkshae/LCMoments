//
//  LCContentCell.h
//  LCMoments
//
//  Created by Richard on 2020/3/3.
//  Copyright © 2020 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCContentCellViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCContentCell : UICollectionViewCell

- (void)feedCellWithViewModel:(LCContentCellViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
