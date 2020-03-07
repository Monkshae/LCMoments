//
//  LCContentSectionViewModel.m
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCContentSectionViewModel.h"
#import "LCContentCellViewModel.h"
#import "LCContentCell.h"

@interface LCContentSectionViewModel ()

@property (nonatomic, assign) NSInteger contentCount;
@property (nonatomic, strong) NSMutableArray <LCContentCellViewModel *>* dataArray;

@end

@implementation LCContentSectionViewModel

- (instancetype)initWithTweetModel:(LCTweetModel *)model {
    if (self = [super init]) {
        LCContentCellViewModel *cellViewModel = [[LCContentCellViewModel alloc]initWithTweetModel:model];
        self.dataArray = [@[cellViewModel] mutableCopy];
        self.contentCount = 1;
    }
    return self;
}

- (LCContentCellViewModel *)cellViewModelAtIndex:(NSInteger)index {
    return self.dataArray[index];
}

- (nonnull id<NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(nullable id<IGListDiffable>)object {
    return [self isEqual:object];
}

@end
