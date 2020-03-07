//
//  LCImageCell.h
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCCellProtocol.h"
#import "LCImageScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCImageCell : UICollectionViewCell <LCCellProtocol>

@property (nonatomic, strong) LCImageScrollView *imageScrollView;

@end

NS_ASSUME_NONNULL_END
