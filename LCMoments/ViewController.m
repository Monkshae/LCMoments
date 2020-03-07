//
//  ViewController.m
//  LCMoments
//
//  Created by Richard on 2020/3/2.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "ViewController.h"
#import "LCTweetViewModel.h"
#import "LCDefine.h"
#import "LCContentSectionController.h"
//#import <AFNetworking/AFNetworking.h>
//#import <SVProgressHUD/SVProgressHUD.h>
//#import <MJExtension/MJExtension.h>
//#import "LCUserInfoModel.h"
//#import "LCTweetModel.h"

//static NSString * const kUserInfoUrl = @"https://s3.ap-southeast-1.amazonaws.com/neuron-server-qa/STATIC/jsmith.json";
//static NSString * const kTweetsUrl = @"https://s3.ap-southeast-1.amazonaws.com/neuron-server-qa/STATIC/tweets.json";

@interface ViewController ()<IGListAdapterDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) LCTweetViewModel *viewModel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) IGListAdapter *adapter;

//@property (nonatomic, strong) AFURLSessionManager *manager;
//@property (nonatomic, strong) LCUserInfoModel *userInfo;

@property (nonatomic, strong) NSArray * dataArray;
//@property (nonatomic, strong) NSArray <LCContentCellViewModel *> *tweetList;

@end

@implementation ViewController

static void extracted(ViewController *object, ViewController *const __weak weakSelf) {
    [object.viewModel requestTweetsWithSuccessBlock:^(NSArray<LCContentCellViewModel *> * _Nonnull list) {
        //        weakSelf.tweetList = [list mutableCopy];
        weakSelf.dataArray = [list mutableCopy];
        [object.adapter reloadDataWithCompletion:nil];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"朋友圈";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(@([UIApplication sharedApplication].statusBarFrame.size.height+44));
    }];
    self.adapter.collectionView = self.collectionView;
    self.adapter.dataSource = self;
            
    self.viewModel = [[LCTweetViewModel alloc]init];
    [self.viewModel requestUserInfo];
    __weak typeof(self) weakSelf = self;
    extracted(self, weakSelf);
}


- (NSArray<id <IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.dataArray;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    IGListSectionController *vc = [LCContentSectionController new];
    return vc;
}

- (nullable UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 90)];
    view.backgroundColor = [UIColor redColor];
    return view;
}

#pragma mark - Lazying loading
- (IGListAdapter *)adapter {
    if (!_adapter) {
        _adapter = [[IGListAdapter alloc] initWithUpdater:[IGListAdapterUpdater new] viewController:self];
        _adapter.scrollViewDelegate = self;
    }
    
    return _adapter;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _collectionView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _collectionView;
}

//- (void)requestUserInfo {
//      NSURL *URL = [NSURL URLWithString:kUserInfoUrl];
//      NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//      NSURLSessionDataTask *dataTask =[self.manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//          if (error) {
//              [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//          } else {
//              [SVProgressHUD dismiss];
//              LCUserInfoModel *info = [LCUserInfoModel mj_objectWithKeyValues:responseObject];
//              self.userInfo = info;
//              
//          }
//          
//      }];
//      [dataTask resume];
//}
//
//- (void)requestTweets {
//      NSURL *URL = [NSURL URLWithString:kTweetsUrl];
//      NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//      NSURLSessionDataTask *dataTask =[self.manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//          if (error) {
//              [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//          } else {
//              [SVProgressHUD dismiss];
//              NSArray <LCTweetModel *> *tweets = [LCTweetModel mj_objectArrayWithKeyValuesArray:responseObject];
//              self.tweetList = [tweets  mutableCopy];
//          }
//          
//      }];
//      [dataTask resume];
//}
//
//- (AFURLSessionManager *)manager {
//    if (!_manager) {
//        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    }
//    return _manager;
//}

@end
