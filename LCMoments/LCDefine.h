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

#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define NAV_HEIGHT ([[UIScreen mainScreen] bounds].size.height>=812)?88:64

#define RGBCOLOR(R,G,B)  [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]

#define RGBACOLOR(x, a) [UIColor colorWithRed:((x>>16)&0xff)/255.0f green:((x>>8)&0xff)/255.0f blue:(x&0xff)/255.0f alpha:a]

#endif /* LCDefine_h */
