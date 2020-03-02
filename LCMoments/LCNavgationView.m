//
//  LCNavgationView.m
//  LCMoments
//
//  Created by Richard on 2020/3/2.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCNavgationView.h"
#import "LCDefine.h"

@implementation LCNavgationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    effectView.userInteractionEnabled = YES;
    effectView.hidden = NO;
    effectView.frame = self.bounds;
    effectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:effectView];

    
    UIView *navView = [[UIView alloc]initWithFrame:self.bounds];
    navView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.95];
    navView.backgroundColor = RGBACOLOR(0xefefef, 0.9);
    navView.alpha = 0;
    [self addSubview:navView];
    self.navV = navView;
    
    UIButton *backButtton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButtton.frame = CGRectMake(20, navView.height - 40 , 30, 30);
    [backButtton setImage:[UIImage imageNamed:@"back_w"] forState:0];
    [self addSubview:backButtton];
    self.backBtn = backButtton;
    
    UIButton *camareButtton = [UIButton buttonWithType:UIButtonTypeCustom];
    camareButtton.frame = CGRectMake(SCREEN_WIDTH - 20 - 30,navView.height - 40 , 30, 30);
    [camareButtton setImage:[UIImage imageNamed:@"camera_w"] forState:0];
    [self addSubview:camareButtton];
    self.camareBtn = camareButtton;
    
    UILabel *navLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, navView.height - 40, SCREEN_WIDTH, 30)];
    navLabel.textAlignment = 1;
    navLabel.text = @"朋友圈";
    navLabel.alpha = 0;
    navLabel.font = [UIFont boldSystemFontOfSize:17];
    [self addSubview:navLabel];
    self.navLabel = navLabel;
}

- (void)setIsScrollUp:(BOOL)isScrollUp {
    _isScrollUp = isScrollUp;
    if (_isScrollUp) {
        [self.backBtn setImage:[UIImage imageNamed:@"back"] forState:0];
        [self.camareBtn setImage:[UIImage imageNamed:@"camera"] forState:0];
        
    } else {
        [self.backBtn setImage:[UIImage imageNamed:@"back_w"] forState:0];
        [self.camareBtn setImage:[UIImage imageNamed:@"camera_w"] forState:0];
    }
}

@end
