//
//  LCHeadImageCell.m
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCHeadImageCell.h"
#import "LCDefine.h"

@implementation LCHeadImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];

        CGFloat avatorW = 80;
        CGFloat headImageVerIndentation = 60;
        CGFloat space = 20;
        
        UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.bounds.size.height - headImageVerIndentation)];
        headImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:headImageView];
        
        UIImageView *headAvatar = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH- avatorW - 16 , self.bounds.size.height -avatorW - headImageVerIndentation + space, avatorW, avatorW)];
        headAvatar.layer.cornerRadius = 10;
        headAvatar.layer.masksToBounds = YES;
        [self addSubview:headAvatar];
        
        UILabel *userNameLable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headImageView.frame) - space - 20, CGRectGetMinX(headAvatar.frame) - space, 30)];
        userNameLable.textAlignment = 2;
        userNameLable.textColor = [UIColor whiteColor];
        userNameLable.font = [UIFont systemFontOfSize:25];
        [self addSubview:userNameLable];
        
        self.headImageView = headImageView;
        self.headAvatar = headAvatar;
        self.userNameLable = userNameLable;
    }
    return self;
}

- (void)feedCellWithViewModel:(LCHeadImageCellViewModel *)viewModel {
    //http://pic.kekenet.com/2014/1113/16391415865876.jpg    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.headImage] placeholderImage:[UIImage imageNamed:@"girl.jpeg"]];

    //http://5b0988e595225.cdn.sohucs.com/images/20171002/394dd13e0fb4479aaa159ba45e994bff.jpeg
    
    [self.headAvatar sd_setImageWithURL:[NSURL URLWithString:viewModel.headAvatar] placeholderImage:[UIImage imageNamed:@"girl.jpeg"]];

     self.userNameLable.text = viewModel.headUserName;
}



@end
