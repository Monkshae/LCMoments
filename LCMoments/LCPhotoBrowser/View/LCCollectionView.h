//
//  LCCollectionView.h
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCCollectionViewLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCCollectionView : UICollectionView

@property (nonatomic, strong, readonly) LCCollectionViewLayout *layout;

- (NSString *)reuseIdentifierForCellClass:(Class)cellClass;

- (nullable UICollectionViewCell *)centerCell;

- (void)scrollToPage:(NSInteger)page;

@end

NS_ASSUME_NONNULL_END
