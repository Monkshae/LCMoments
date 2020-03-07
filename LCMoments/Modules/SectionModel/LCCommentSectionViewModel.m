//
//  LCCommentSectionViewModel.m
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCCommentSectionViewModel.h"

@interface LCCommentSectionViewModel ()

@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, strong) NSMutableArray <LCCommentCellViewModel *>* dataArray;

@end

@implementation LCCommentSectionViewModel

- (instancetype)initWithTweetModel:(LCTweetModel *)model {
    if (self = [super init]) {
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        [model.comments enumerateObjectsUsingBlock:^(LCCommentModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LCCommentCellViewModel *cellViewModel = [[LCCommentCellViewModel alloc]initWithCommentModel:obj];
            [temp addObject:cellViewModel];
        }];
        self.dataArray = [temp mutableCopy];
    }
    return self;
}

- (LCCommentCellViewModel *)cellViewModelAtIndex:(NSInteger)index {
    return self.dataArray[index];
}

- (nonnull id<NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(nullable id<IGListDiffable>)object {
    return [self isEqual:object];
}

@end
