//
//  LCCollectionView.m
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCCollectionView.h"

@implementation LCCollectionView {
    NSMutableSet *_reuseSet;
}

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    _layout = [LCCollectionViewLayout new];
    return [self initWithFrame:frame collectionViewLayout:_layout];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.alwaysBounceVertical = NO;
        self.alwaysBounceHorizontal = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _reuseSet = [NSMutableSet set];
    }
    return self;
}

#pragma mark - public

- (NSString *)reuseIdentifierForCellClass:(Class)cellClass {
    NSString *identifier = NSStringFromClass(cellClass);
    if (![_reuseSet containsObject:identifier]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:identifier ofType:@"nib"];
        if (path) {
            [self registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellWithReuseIdentifier:identifier];
        } else {
            [self registerClass:cellClass forCellWithReuseIdentifier:identifier];
        }
        [_reuseSet addObject:identifier];
    }
    return identifier;
}

- (UICollectionViewCell *)centerCell {
    NSArray<UICollectionViewCell *> *cells = [self visibleCells];
    if (cells.count == 0) return nil;
    
    UICollectionViewCell *res = cells[0];
    CGFloat centerX = self.contentOffset.x + (self.bounds.size.width / 2.0);
    for (int i = 1; i < cells.count; ++i) {
        if (ABS(cells[i].center.x - centerX) < ABS(res.center.x - centerX)) {
            res = cells[i];
        }
    }
    return res;
}

- (void)scrollToPage:(NSInteger)page {
    [self setContentOffset:CGPointMake(self.bounds.size.width * page, 0)];
}

@end
