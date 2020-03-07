//
//  LCTweetViewModel.h
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCTweetViewModel : NSObject

@property (nonatomic, readonly) NSArray <LCTweetModel *> *tweetList;

@end

NS_ASSUME_NONNULL_END
