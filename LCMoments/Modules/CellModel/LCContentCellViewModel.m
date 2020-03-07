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

@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, assign) NSInteger imageCount;

@property(nonatomic, assign) CGFloat picHeight;
@property(nonatomic, assign) CGFloat cellHeight;

@end

@implementation LCContentCellViewModel

- (instancetype)initWithTweetModel:(LCTweetModel *)model {
    if (self = [super init]) {
        self.content = model.content;
        self.userName = model.sender.username;
        self.imageCount = model.images.count;
        [self calculateCellHeight];
    }
    return self;
}


- (void)calculateCellHeight {
    
    CGFloat cellHeight = kCellItemInset;
    cellHeight += 42; // 头像高度
    CGFloat extraH = 15;
    ///文字高度
    CGFloat contentHeight = self.content.length ? [self.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 3 * kCellPadding - 42, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height : 0;
    
    ///图片高度
    CGFloat picHeight = 0;
    if (self.imageCount > 0) {

        if (self.imageCount == 1) {
            picHeight = 180;
        } else if (self.imageCount == 2 || self.imageCount == 4) {

            NSInteger row = self.imageCount / 2;
            picHeight = row * 90 + (row - 1) * kCellPicInset;

        } else {
            NSInteger row = self.imageCount % 3 == 0 ? self.imageCount / 3 : (self.imageCount / 3 + 1);
            picHeight = row * 60 + (row - 1) * kCellPicInset;
        }
    }
    self.picHeight = picHeight;

    if (contentHeight == 0) {
        picHeight -= extraH;
    } else if (contentHeight <= extraH) { // 单行文字
        picHeight += 3;
        picHeight += kCellItemInset;
    } else { // 多行文字
        picHeight += kCellItemInset;
        picHeight += (contentHeight - extraH);
    }
    cellHeight += picHeight;
    _cellHeight = cellHeight;
}

- (nonnull id<NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(nullable id<IGListDiffable>)object {
    return [self isEqual:object];
}

@end
