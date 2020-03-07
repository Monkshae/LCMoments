//
//  LCCommentSectionController.m
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCCommentSectionController.h"
#import "LCCommentSectionViewModel.h"
#import "LCCommentCell.h"

@interface LCCommentSectionController ()

@property (nonatomic, strong) LCCommentSectionViewModel *viewModel;

@end

@implementation LCCommentSectionController


- (NSInteger)numberOfItems {
    
    return self.viewModel.commentCount;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    
    LCCommentCellViewModel *cellViewModel = [self.viewModel cellViewModelAtIndex:index];
    return CGSizeMake(SCREEN_WIDTH - 2 * kCellPadding - 42 - kCellItemInset, cellViewModel.cellHeight);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    
    LCCommentCellViewModel *cellViewModel = [self.viewModel cellViewModelAtIndex:index];
    LCCommentCell *cell = [self.collectionContext dequeueReusableCellOfClass:[LCCommentCell class] forSectionController:self atIndex:index];
    [cell feedCellWithViewModel:cellViewModel];
    return cell;
}

- (void)didUpdateToObject:(id)object {
    self.viewModel = object;
}

@end
