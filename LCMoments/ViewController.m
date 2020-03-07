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

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) LCNavigationView *navView;
@property (nonatomic, strong) IGListAdapter *adapter;
@property (nonatomic, strong) LCUserInfoModel *userInfo;
@property (nonatomic, strong) LCTweetViewModel *viewModel;
@property (nonatomic, assign) CGFloat contentOffsetY;
@property (nonatomic, strong) NSArray<LCTweetModel*> *tweets;
/// 上拉刷新的游标
@property (nonatomic, assign) NSInteger cursor;
/// 所以twwets文
@property (nonatomic, strong) NSArray *allArray;
/// 真实显示在屏幕的推文
@property (nonatomic, strong) NSMutableArray *dataArray;

/// 真实有效的推文数据
@property (nonatomic, assign) NSInteger realCount;

@end

@implementation ViewController

- (instancetype)init {
    if (self = [super init]) {

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.cursor = 0;
    self.dataArray = [[NSMutableArray alloc]init];
    self.viewModel = [[LCTweetViewModel alloc]init];
    self.navigationController.navigationBarHidden = YES;
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
    
    self.collectionView.mj_header = [LCHeaderRefreshView headerWithRefreshingBlock:^{

    }];
    
    //每次下拉加载5条
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self reloadTweetsByFiveStep];
    }];
    
    [self fetchAllData];
}

- (void)fetchAllData {
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
      
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
      NSMutableArray *tweetList = [[NSMutableArray alloc]init];
      [self.tweets enumerateObjectsUsingBlock:^(LCTweetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
          LCContentSectionViewModel *contentSectionViewModel = [[LCContentSectionViewModel alloc]initWithTweetModel:obj];
          LCCommentSectionViewModel *commentSectionViewModel = [[LCCommentSectionViewModel alloc]initWithTweetModel:obj];
          LCHeadImageSectionViewModel *headImageSectionViewModel = [[LCHeadImageSectionViewModel alloc]initWithUserInfoModel:self.userInfo section:idx];
          if (obj.sender.username.length > 0 ) {
              [tweetList addObject:headImageSectionViewModel];
              [tweetList addObject:contentSectionViewModel];
              [tweetList addObject:commentSectionViewModel];
          }
     }];
        self.allArray = [tweetList mutableCopy];
        [self reloadTweetsByFiveStep];
    });
}

- (void)reloadTweetsByFiveStep {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *onePageList = nil;
        if (self.cursor >= self.realCount) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        
        [self.collectionView.mj_footer endRefreshing];
        NSInteger diff = self.realCount - self.cursor;
        if (diff <= 5) {
            onePageList = [self.allArray subarrayWithRange:NSMakeRange(self.cursor * 3, diff * 3)];
        } else {
            onePageList = [self.allArray subarrayWithRange:NSMakeRange(self.cursor * 3, 5 * 3)];
        }
        [self.dataArray addObjectsFromArray:onePageList];
        [self.adapter reloadDataWithCompletion:nil];
        self.cursor += 5;
    });
}

#pragma mark - IGListAdapterDataSource

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
    view.backgroundColor = [UIColor greenColor];
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

- (NSInteger)realCount {
    return self.allArray.count / 3;
}

@end
