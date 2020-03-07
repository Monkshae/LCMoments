//
//  LCDefine.h
//  LCMoments
//
//  Created by Richard on 2020/3/2.
//  Copyright © 2020 Richard. All rights reserved.
//

#ifndef LCDefine_h
#define LCDefine_h

#import <YYKit/YYKit.h>
#import <IGListKit/IGListKit.h>
#import "LCTweetModel.h"
#import "LCUserInfoModel.h"
#import <SDWebImage/SDWebImage.h>
#import <Masonry/Masonry.h>

#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define NAV_HEIGHT ([[UIScreen mainScreen] bounds].size.height>=812)?88:64

#define RGBCOLOR(R,G,B)  [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]

#define RGBACOLOR(x, a) [UIColor colorWithRed:((x>>16)&0xff)/255.0f green:((x>>8)&0xff)/255.0f blue:(x&0xff)/255.0f alpha:a]

#define PHOTO_WIDTH (SCREEN_WIDTH - 156) / 3

#define  kCellPadding  10.0
#define  kCellItemInset  12.0
#define  kCellPicInset  5.0

#define LC_DISPATCH_ASYNC(queue, block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {\
block();\
} else {\
dispatch_async(queue, block);\
}

#define LC_DISPATCH_ASYNC_MAIN(block) LC_DISPATCH_ASYNC(dispatch_get_main_queue(), block)

#endif /* LCDefine_h */
