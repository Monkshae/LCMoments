//
//  LCHeadImageCell.h
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCHeadImageCellViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCHeadImageCell : UICollectionViewCell 

@property(nonatomic, strong) UIImageView *headImageView;
@property(nonatomic, strong) UIImageView *headAvatar;
@property(nonatomic, strong) UILabel *userNameLable;

- (void)feedCellWithViewModel:(LCHeadImageCellViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
