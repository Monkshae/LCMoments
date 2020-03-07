//
//  LCHeadImageSectionViewModel.m
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCHeadImageSectionViewModel.h"
#import "LCHeadImageCellViewModel.h"
#import "LCHeadImageCell.h"

@interface LCHeadImageSectionViewModel ()

@property (nonatomic, strong) NSMutableArray <LCHeadImageCellViewModel *>* dataArray;
@property (nonatomic, assign) BOOL isShowHeadPart;

@end

@implementation LCHeadImageSectionViewModel

- (instancetype)initWithUserInfoModel:(LCUserInfoModel *)model section:(NSInteger)section {
    if (self = [super init]) {
        LCHeadImageCellViewModel *cellViewModel = [[LCHeadImageCellViewModel alloc]initWithUserInfoModel:model section:section];
        if (section == 0) {
            _isShowHeadPart = YES;
        } else {
            _isShowHeadPart = NO;
        }
        self.dataArray = [@[cellViewModel] mutableCopy];
    }
    return self;
}

- (LCHeadImageCellViewModel *)cellViewModelAtIndex:(NSInteger)index {
    return self.dataArray[index];
}

- (nonnull id<NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(nullable id<IGListDiffable>)object {
    return [self isEqual:object];
}

@end
