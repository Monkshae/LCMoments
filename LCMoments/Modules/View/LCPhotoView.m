//
//  LCPhotoView.m
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCPhotoView.h"
#import "LCPhotoViewCell.h"
#import "LCDefine.h"

@interface LCPhotoView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong) NSMutableArray <NSString *> *dataArray;
@property(nonatomic, strong) UICollectionView *collectionView;
//@property(nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation LCPhotoView

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.insets(UIEdgeInsetsZero);
    }];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(LCPhotoViewCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(LCPhotoViewCell.class)];
}

- (void)feedPhotoViewWithArray:(NSArray<NSString *> *)dataArray {
    _dataArray = [dataArray mutableCopy];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    LCPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(LCPhotoViewCell.class) forIndexPath:indexPath];
    
    NSString *url = self.dataArray[indexPath.row];
    [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"girl.jpeg"]];
    
//    [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        NSLog(@"daa");
//    }];

//    [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:@"http://wespypicuser.afunapp.com/Fsj5J4ueeH7K-2bQpXJeyvKYip5F"]
//                              completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//
//        NSLog(@"daa");
//
//    }];
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count == 1) {
        return CGSizeMake((self.bounds.size.width - 10) / 2, 180);
    }
    return CGSizeMake(PHOTO_WIDTH, PHOTO_WIDTH);
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

@end
