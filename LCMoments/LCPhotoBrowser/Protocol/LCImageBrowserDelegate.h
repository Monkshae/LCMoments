//
//  LCImageBrowserDelegate.h
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCDataProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class LCImageBrowser;

@protocol LCImageBrowserDelegate <NSObject>

@optional

- (void)lc_imageBrowser:(LCImageBrowser *)imageBrowser pageChanged:(NSInteger)page data:(id<LCDataProtocol>)data;

- (void)lc_imageBrowser:(LCImageBrowser *)imageBrowser respondsToLongPressWithData:(id<LCDataProtocol>)data;

- (void)lc_imageBrowser:(LCImageBrowser *)imageBrowser beginTransitioningWithIsShow:(BOOL)isShow;

- (void)lc_imageBrowser:(LCImageBrowser *)imageBrowser endTransitioningWithIsShow:(BOOL)isShow;

@end


@protocol LCImageBrowserDataSource <NSObject>

@required

- (NSInteger)lc_numberOfCellsInImageBrowser:(LCImageBrowser *)imageBrowser;

- (id<LCDataProtocol>)lc_imageBrowser:(LCImageBrowser *)imageBrowser dataForCellAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
