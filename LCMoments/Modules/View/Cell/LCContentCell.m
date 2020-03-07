//
//  LCContentCell.m
//  LCMoments
//
//  Created by Richard on 2020/3/3.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCContentCell.h"
#import "LCDefine.h"

@interface LCContentCell ()

@property(nonatomic, strong) UIImageView *avatar;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *contentLabel;

@end

@implementation LCContentCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.avatar = [[UIImageView alloc] init];
    self.avatar.backgroundColor = [UIColor grayColor];
    self.avatar.layer.cornerRadius = 5;
    self.avatar.layer.masksToBounds = YES;
    [self.contentView addSubview:self.avatar];
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(42, 42));
        make.left.equalTo(@(kCellPadding));
        make.top.equalTo(@(kCellItemInset));
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightHeavy];
    self.nameLabel.textColor = RGBCOLOR(90, 106, 144);
    self.nameLabel.userInteractionEnabled = YES;
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatar);
        make.left.equalTo(self.avatar.mas_right).offset(kCellPadding);
    }];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(kCellItemInset);
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(@(-kCellPadding));
    }];
}

- (void)feedCellWithViewModel:(LCContentCellViewModel *)viewModel {
    
    self.nameLabel.text = viewModel.userName;
    self.contentLabel.text = viewModel.content;
}

@end
