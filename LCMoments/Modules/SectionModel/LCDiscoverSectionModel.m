//
//  LCDiscoverSectionModel.m
//  LCMoments
//
//  Created by Richard on 2020/3/3.
//  Copyright © 2020 Richard. All rights reserved.
//

#import "LCDiscoverSectionModel.h"

@implementation LCDiscoverSectionModel

- (nonnull id<NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(nullable id<IGListDiffable>)object {
    return [self isEqual:object];
}

@end