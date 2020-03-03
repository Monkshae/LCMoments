//
//  LCTweetModel.h
//  LCMoments
//
//  Created by Richard on 2020/3/3.
//  Copyright © 2020 Richard. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCImageModel : NSObject

@property (nonatomic, strong) NSString *url;

@end

@interface LCSenderModel : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *avatar;

@end


@interface LCCommentModel : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) LCSenderModel *sender;

@end


@interface LCTweetModel : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSArray<LCImageModel *> *images;
@property (nonatomic, strong) LCSenderModel *sender;
@property (nonatomic, strong) NSArray<LCCommentModel *> *comments;

@end

NS_ASSUME_NONNULL_END
