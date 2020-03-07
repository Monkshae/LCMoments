//
//  LCCommentCell.m
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCCommentCell.h"
#import "LCDefine.h"

@interface LCCommentCell ()

@property(nonatomic, strong) YYLabel *commentLabel;

@end

@implementation LCCommentCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = RGBCOLOR(243, 242, 245);
    CGFloat leftPadding = kCellPadding + 42 + kCellItemInset * 2;
    self.commentLabel = [[YYLabel alloc] init];
    self.commentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.commentLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    self.commentLabel.numberOfLines = 0;
    self.commentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - leftPadding - kCellPadding - kCellItemInset;
    [self.contentView addSubview:self.commentLabel];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(kCellItemInset);
        make.top.equalTo(@5);
    }];
}

- (void)feedCellWithViewModel:(LCCommentCellViewModel *)viewModel {
    
}

@end
