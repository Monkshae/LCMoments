//
//  LCCollectionViewLayout.m
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCCollectionViewLayout.h"

@implementation LCCollectionViewLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.minimumLineSpacing = 0;
        self.minimumInteritemSpacing = 0;
        self.sectionInset = UIEdgeInsetsZero;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _distanceBetweenPages = 20;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    self.itemSize = self.collectionView.bounds.size;
}

@end
