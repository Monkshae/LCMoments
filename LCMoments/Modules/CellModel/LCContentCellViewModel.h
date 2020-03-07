//
//  LCContentCellViewModel.h
//  LCMoments
//
//  Created by Richard on 2020/3/3.
//  Copyright © 2020 Richard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCContentCellViewModel : NSObject<IGListDiffable>

@property(nonatomic, readonly) NSString *content;
@property(nonatomic, readonly) NSString *userName;
@property(nonatomic, readonly) NSString *avatar;
@property(nonatomic, readonly) NSInteger imageCount;
@property(nonatomic, readonly) NSArray <NSString*> *images;

@property(nonatomic, readonly) CGFloat picHeight;
@property(nonatomic, readonly) CGFloat cellHeight;

- (instancetype)initWithTweetModel:(LCTweetModel *)model;

- (void)calculateCellHeight;

@end

NS_ASSUME_NONNULL_END
