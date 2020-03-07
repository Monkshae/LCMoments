//
//  LCHeadImageSectionControler.m
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCHeadImageSectionControler.h"
#import "LCHeadImageSectionViewModel.h"
#import "LCHeadImageCell.h"

@interface LCHeadImageSectionControler ()

@property (nonatomic, strong) LCHeadImageSectionViewModel *viewModel;

@end

@implementation LCHeadImageSectionControler

- (NSInteger)numberOfItems {
    if (self.viewModel.isShowHeadPart) {
        return 1;
    } else {
        return 0;
    }
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    LCHeadImageCellViewModel *cellViewModel = [self.viewModel cellViewModelAtIndex:index];
    return CGSizeMake(self.collectionContext.containerSize.width, cellViewModel.cellHeight);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    LCHeadImageCell *cell = [self.collectionContext dequeueReusableCellOfClass:LCHeadImageCell.class forSectionController:self atIndex:index];
    LCHeadImageCellViewModel *cellViewModel = [self.viewModel cellViewModelAtIndex:index];
    [cell feedCellWithViewModel:cellViewModel];
    return cell;
}

- (void)didUpdateToObject:(id)object {
    self.viewModel = object;
}

@end
