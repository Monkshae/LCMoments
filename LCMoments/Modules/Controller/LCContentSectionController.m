//
//  LCContentSectionController.m
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCContentSectionController.h"
#import "LCContentSectionViewModel.h"
#import "LCContentCell.h"

@interface LCContentSectionController ()

@property(nonatomic, strong) LCContentSectionViewModel *viewModel;

@end

@implementation LCContentSectionController

- (NSInteger)numberOfItems {
    return self.viewModel.contentCount;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    LCContentCellViewModel *cellViewModel = [self.viewModel cellViewModelAtIndex:index];
    return CGSizeMake(self.collectionContext.containerSize.width, cellViewModel.cellHeight);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    LCContentCell *cell = [self.collectionContext dequeueReusableCellOfClass:LCContentCell.class forSectionController:self atIndex:index];
    LCContentCellViewModel *cellViewModel = [self.viewModel cellViewModelAtIndex:index];
    [cell feedCellWithViewModel:cellViewModel];
    return cell;
}

- (void)didUpdateToObject:(id)object {
    self.viewModel = object;
}

@end
