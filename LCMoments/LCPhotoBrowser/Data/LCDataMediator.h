//
//  LCDataMediator.h
//  LCMoments
//
//  Created by Richard on 2020/3/7.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCImageBrowser.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCDataMediator : NSObject

- (instancetype)initWithBrowser:(LCImageBrowser *)browser;

- (NSInteger)numberOfCells;

- (id<LCDataProtocol>)dataForCellAtIndex:(NSInteger)index;

- (void)clear;

@end

NS_ASSUME_NONNULL_END
