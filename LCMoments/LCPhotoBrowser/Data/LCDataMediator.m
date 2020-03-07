//
//  LCDataMediator.m
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCDataMediator.h"

@implementation LCDataMediator {
    __weak LCImageBrowser *_browser;
    NSCache<NSNumber *, id<LCDataProtocol>> *_dataCache;
}

#pragma mark - life cycle

- (instancetype)initWithBrowser:(LCImageBrowser *)browser {
    if (self = [super init]) {
        _browser = browser;
        _dataCache = [NSCache new];
    }
    return self;
}

#pragma mark - public

- (NSInteger)numberOfCells {
    return _browser.dataSource ? [_browser.dataSource lc_numberOfCellsInImageBrowser:_browser] : _browser.dataSourceArray.count;
}

- (id<LCDataProtocol>)dataForCellAtIndex:(NSInteger)index {
    if (index < 0 || index > self.numberOfCells - 1) return nil;
    
    id<LCDataProtocol> data = [_dataCache objectForKey:@(index)];
    if (!data) {
        data = _browser.dataSource ? [_browser.dataSource lc_imageBrowser:_browser dataForCellAtIndex:index] : _browser.dataSourceArray[index];
        [_dataCache setObject:data forKey:@(index)];
        [_browser implementGetBaseInfoProtocol:data];
    }
    return data;
}

- (void)clear {
    [_dataCache removeAllObjects];
}

@end
