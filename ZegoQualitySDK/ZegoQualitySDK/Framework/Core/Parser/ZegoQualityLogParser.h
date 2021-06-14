//
//  ZegoLogFilter.h
//  go_class
//
//  Created by MartinNie on 2021/6/9.
//  Copyright © 2021 zego. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZegoQualityLogParser : NSObject

- (void)parse:(NSString *)data;

- (void)setUserID:(NSString *)userID;

- (void)setRoomID:(NSString *)roomID;

- (void)setLoginTimeConsuming:(NSTimeInterval)timeInterval;

- (void)setFirstFrameRenderTimeConsuming:(NSTimeInterval)timeInterval forPlayerStream:(NSString *)streamID;

- (void)setPublishStreamID:(NSString *)streamID;

@end

NS_ASSUME_NONNULL_END
