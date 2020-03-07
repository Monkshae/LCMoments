//
//  LCCommentCellViewModel.m
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCCommentCellViewModel.h"

@interface LCCommentCellViewModel ()

@property(nonatomic, strong) NSAttributedString *commentAttributedString;
@property(nonatomic, assign) CGFloat cellHeight;

@end

@implementation LCCommentCellViewModel

- (instancetype)initWithCommentModel:(LCCommentModel *)model {
    if (self = [super init]) {
        
        NSString*sender = [NSString stringWithFormat:@"%@:", model.sender.username];
        NSMutableAttributedString *fisrtAttr = [[NSMutableAttributedString alloc] initWithString:sender];
        [fisrtAttr addAttributes:@{NSForegroundColorAttributeName : RGBCOLOR(88, 104, 144),
                                   NSFontAttributeName : [UIFont systemFontOfSize:12 weight:UIFontWeightBold],
                                   NSStrikethroughStyleAttributeName : [UIColor colorWithWhite:0.000 alpha:0.220]
        } range:NSMakeRange(0, fisrtAttr.length)];

        NSMutableAttributedString *lastAttr = [[NSMutableAttributedString alloc] initWithString:model.content];
        [lastAttr addAttributes:@{NSForegroundColorAttributeName : RGBCOLOR(88, 104, 144),
                             NSFontAttributeName : [UIFont systemFontOfSize:12 weight:UIFontWeightRegular],
                             NSStrikethroughStyleAttributeName : [UIColor colorWithWhite:0.000 alpha:0.220]
        } range:NSMakeRange(0, lastAttr.length)];
        [fisrtAttr appendAttributedString:lastAttr];
        _commentAttributedString = [fisrtAttr mutableCopy];
        [self calculateCellHeight];
    }
    return self;
}

- (void)calculateCellHeight {
    CGFloat topPadding = 5;
    CGFloat bottomPadding = 2.5;
    CGFloat leftPadding = kCellPadding + 42 + kCellItemInset * 2;
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(SCREEN_WIDTH - leftPadding - kCellPadding - kCellItemInset, CGFLOAT_MAX) text:self.commentAttributedString];
    _cellHeight = layout.textBoundingSize.height + topPadding + bottomPadding;
}

- (nonnull id<NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(nullable id<IGListDiffable>)object {
    return [self isEqual:object];
}

@end
