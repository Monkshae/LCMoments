//
//  LCContentCellViewModel.m
//  LCMoments
//
//  Created by Richard on 2020/3/3.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCContentCellViewModel.h"
#import "LCDefine.h"

@interface LCContentCellViewModel ()

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, strong) NSArray <NSString*> *images;

@property (nonatomic, assign) CGFloat picHeight;
@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation LCContentCellViewModel

- (instancetype)initWithTweetModel:(LCTweetModel *)model {
    if (self = [super init]) {
        self.content = model.content;
        self.userName = model.sender.username;
        self.avatar = model.sender.avatar;
        self.imageCount = model.images.count;
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:model.images.count];
        [model.images enumerateObjectsUsingBlock:^(LCImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [images addObject:obj.url];
        }];
        self.images = [images mutableCopy];
        [self calculateCellHeight];
    }
    return self;
}


- (void)calculateCellHeight {
    
    CGFloat cellHeight = kCellItemInset;
    cellHeight += 42;    //头像高度
    CGFloat extraHeight = 15;
    ///文字高度
    CGFloat contentHeight = self.content.length ? [self.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 3 * kCellPadding - 42, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height : 0;
    CGFloat picHeight= [self collectionPicViewHeight:self.imageCount];
    self.picHeight = picHeight;
    
    if (contentHeight == 0) {
        picHeight += extraHeight;
    } else {
        picHeight += contentHeight;
    }
    cellHeight += picHeight;
    _cellHeight = cellHeight;
}


- (CGFloat)collectionPicViewHeight:(NSInteger)picCount {
    CGFloat verticalSpace = 5;
    if (picCount == 0) {
        return 0;
    }else if (picCount == 1) {
        return 180;
    } else if (picCount <= 3) {
        return PHOTO_WIDTH + 2*verticalSpace;
    } else if (picCount <= 6) {
        return 2*PHOTO_WIDTH + 3 * verticalSpace;
    } else  {
        return 3*PHOTO_WIDTH + 2 * verticalSpace;
    }
}

- (nonnull id<NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(nullable id<IGListDiffable>)object {
    return [self isEqual:object];
}

@end
