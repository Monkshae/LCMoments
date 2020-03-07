//
//  LCHeadImageCellViewModel.m
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCHeadImageCellViewModel.h"

@interface LCHeadImageCellViewModel ()

@property (nonatomic, strong) NSString *headImage;
@property (nonatomic, strong) NSString *headAvatar;
@property (nonatomic, strong) NSString *headUserName;

@property(nonatomic, assign) CGFloat cellHeight;

@end

@implementation LCHeadImageCellViewModel

- (instancetype)initWithUserInfoModel:(LCUserInfoModel *)model section:(NSInteger)section {
    if (self = [super init]) {
        self.headImage = model.profileImage;
        self.headAvatar = model.avatar;
        self.headUserName = model.nickName;
        [self calculateCellHeightWithSection:section];
    }
    return self;
}

- (void)calculateCellHeightWithSection:(NSInteger)section {
    if (section == 0) {
        _cellHeight = 305;
    } else {
        _cellHeight = 0;
    }
}

- (nonnull id<NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(nullable id<IGListDiffable>)object {
    return [self isEqual:object];
}


@end
