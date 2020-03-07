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
#import "LCCommentSectionController.h"
#import "LCContentSectionViewModel.h"
#import "LCCommentSectionViewModel.h"
#import "LCNavigationView.h"
#import "LCHeaderRefreshView.h"
#import "LCTweetModel.h"
#import "LCHeadImageSectionViewModel.h"
#import "LCHeadImageSectionControler.h"

@interface ViewController ()<IGListAdapterDataSource, UIScrollViewDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) LCNavigationView *navView;
@property(nonatomic, strong) IGListAdapter *adapter;

@property (nonatomic, strong) LCUserInfoModel *userInfo;
@property(nonatomic, strong) LCTweetViewModel *viewModel;
@property(nonatomic, assign) CGFloat contentOffsetY;
@property(nonatomic, strong) NSArray *dataArray;

@property(nonatomic, strong) NSArray<LCTweetModel*> *tweets;

@end

@implementation ViewController

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
    self.adapter.scrollViewDelegate = self;

            
    self.viewModel = [[LCTweetViewModel alloc]init];
    __weak typeof(self) weakSelf = self;
    dispatch_group_t group = dispatch_group_create();

    dispatch_group_enter(group);
    [self.viewModel requestUserInfo:^(LCUserInfoModel * _Nonnull infoModel) {
        weakSelf.userInfo = infoModel;
        dispatch_group_leave(group);
    } faileBlock:^(NSError * _Nullable error) {
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self.viewModel requestTweetsWithSuccessBlock:^(NSArray * _Nonnull list) {
        weakSelf.tweets = [list mutableCopy];
        dispatch_group_leave(group);
    } faileBlock:^(NSError * _Nullable error) {
        dispatch_group_leave(group);
    }];
    
    self.navigationController.navigationBarHidden = YES;
    self.collectionView.mj_header = [LCHeaderRefreshView headerWithRefreshingBlock:^{
        [self.collectionView.mj_header endRefreshing];
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSMutableArray *tweetList = [[NSMutableArray alloc]init];
        [self.tweets enumerateObjectsUsingBlock:^(LCTweetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LCContentSectionViewModel *contentSectionViewModel = [[LCContentSectionViewModel alloc]initWithTweetModel:obj];
            LCCommentSectionViewModel *commentSectionViewModel = [[LCCommentSectionViewModel alloc]initWithTweetModel:obj];
            LCHeadImageSectionViewModel *headImageSectionViewModel = [[LCHeadImageSectionViewModel alloc]initWithUserInfoModel:self.userInfo section:idx];
            if (obj.sender.username.length > 0) {
                [tweetList addObject:headImageSectionViewModel];
                [tweetList addObject:contentSectionViewModel];
                [tweetList addObject:commentSectionViewModel];
            }
       }];
        self.dataArray = [tweetList mutableCopy];
        [self.adapter reloadDataWithCompletion:nil];
    });
}


- (NSArray<id <IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.dataArray;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    IGListSectionController *vc = nil;
    if ([object isKindOfClass:[LCContentSectionViewModel class]]) {
        vc =  [LCContentSectionController new];
    } else if ([object isKindOfClass:[LCCommentSectionViewModel class]]) {
        vc =  [LCCommentSectionController new];
        vc.inset = UIEdgeInsetsMake(-2, kCellPadding + 40 + kCellItemInset, 0, kCellPadding);
    } else if([object isKindOfClass:[LCHeadImageSectionViewModel copy]]){
        vc = [LCHeadImageSectionControler new];
    }
    return vc;
}

- (nullable UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 90)];
    view.backgroundColor = [UIColor redColor];
    return view;
}

#pragma mark - Lazying loading

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.frame;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    self.contentOffsetY = scrollView.contentOffset.y;
    self.navView.navV.alpha = self.contentOffsetY / 150;
    self.navView.navLabel.alpha = self.contentOffsetY / 150;

    if (self.contentOffsetY / 150 > 0.6) {
        self.navView.isScrollUp = YES;
    } else {
        self.navView.isScrollUp = NO;
    }
}

- (LCNavigationView *)navView {
    if (!_navView) {
        _navView = [[LCNavigationView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_HEIGHT)];
    }
    return _navView;
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
