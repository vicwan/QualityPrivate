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
//+ (instancetype)shareManager;

// 此接口需要在高级配置中打开
//@"allow_verbose_print_high_frequency_content":@"true",
//@"enable_callback_verbose":@"true"
//然后在onRecvExperimentalAPI中调用此方法
- (void)filterLogData:(NSString *)data;
//需要在登录房间之前调用此方法
- (void)setupUserID:(NSString *)userID;
- (void)setupRoomID:(NSString *)roomID;
//需要在登录完成回调中调用此方法，设置登录耗时
- (void)setupLoginSpeed:(NSTimeInterval)speed;
//需要在拉流首帧回调接口中调用此方法，设置首帧耗时
- (void)setupPlayStream:(NSString *)streamId FirstFrameSpeed:(NSTimeInterval)speed;
//在推流前调用
- (void)setupPublishStream:(NSString *)publishStream;
@end

NS_ASSUME_NONNULL_END
