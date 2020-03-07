//
//  LCNavgationView.h
//  LCMoments
//
//  Created by Richard on 2020/3/2.
//  Copyright © 2020 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCNavigationView : UIView

@property (nonatomic, strong)UIView *navV;
@property (nonatomic, strong)UILabel *navLabel;
@property (nonatomic, strong)UIButton *camareBtn;
@property (nonatomic, strong)UIButton *backBtn;
@property (nonatomic, assign)BOOL isScrollUp;

@end

NS_ASSUME_NONNULL_END
