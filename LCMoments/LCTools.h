//
//  LCTools.h
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

BOOL LCIsIphoneXSeries(void);
CGFloat LCStatusbarHeight(void);
CGFloat LCSafeAreaBottomHeight(void);

UIImage *LCSnapshotView(UIView *);


@interface LCTools : NSObject

@end

NS_ASSUME_NONNULL_END
