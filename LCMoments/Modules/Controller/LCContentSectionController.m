//
//  LCContentSectionController.m
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCContentSectionController.h"
#import "LCContentCellViewModel.h"
#import "LCContentCell.h"

@interface LCContentSectionController ()

@property(nonatomic, strong) LCContentCellViewModel *viewModel;

@end

@implementation LCContentSectionController

- (NSInteger)numberOfItems {
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
        
    return CGSizeMake(self.collectionContext.containerSize.width, self.viewModel.cellHeight);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    LCContentCell *cell = [self.collectionContext dequeueReusableCellOfClass:LCContentCell.class forSectionController:self atIndex:index];
    [cell feedCellWithViewModel:self.viewModel];
    return cell;
}

- (void)didUpdateToObject:(id)object {
    self.viewModel = object;
}

@end
