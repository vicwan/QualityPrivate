//
//  ZegoQualityManager.h
//  go_class
//
//  Created by Vic on 2021/6/11.
//  Copyright © 2021 zego. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZegoQualitySDK/ZegoQualityDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZegoQualityManager : NSObject

/// 初始化 QualitySDK
/// 包括创建、链接资源等
+ (void)init;

/// 反初始化 QualitySDK
/// 包括释放资源、删除临时文件等
+ (void)unInit;

/// 异步解析日志
/// 在解析之前需要设置必要参数
/// 需要在 `onRecvExperimentalAPI:` 回调方法中调用
/// @param log 日志文本
+ (void)parsingLog:(NSString *)log;

@end


/// 完整展示质量报告的必要数据设置
@interface ZegoQualityManager (Setup)

/// 设置用户 ID
/// @param userID 用户 ID
+ (void)setUserID:(NSString *)userID;

/// 设置用户名称
/// @param userName 用户名称
+ (void)setUserName:(NSString *)userName;

/// 设置房间 ID
/// @param roomID 房间 ID
+ (void)setRoomID:(NSString *)roomID;

/// 设置产品名称
/// @param productName 产品名称
+ (void)setProductName:(NSString *)productName;

/// 设置应用版本号
/// @param appVersion 应用版本号
+ (void)setAppVersion:(NSString *)appVersion;

/// 设置评分页和质量报告页面的显示语言
/// @param languageType 中文 / 英文
+ (void)setLanguageType:(ZegoQualityLanguageType)languageType;

/// 开始登录的时候调用，用于记录登录耗时，在登录房间之前调用
/// 必须与 `setLoginOnFinish` 方法成对使用
+ (void)setLoginOnStart;

/// 登录成功的时候调用，用于记录登录耗时
/// 必须与 `setLoginOnStart` 方法成对使用
+ (void)setLoginOnFinish;

/// 开始拉流的时候调用
/// 用于记录某条流的首帧渲染耗时
/// 必须与 `setPlayerStreamOnFirstFrame:` 方法成对使用
/// @param streamID 拉流的流 ID
+ (void)setPlayerStreamOnStart:(NSString *)streamID;

/// 拉流首帧渲染成功回调 `onPlayerRenderVideoFirstFrame` 中调用
/// 用于记录某条流的首帧渲染耗时
/// 必须与 `setPlayerStreamOnStart:` 方法成对使用
/// @param streamID 拉流的流 ID
+ (void)setPlayerStreamOnFirstFrame:(NSString *)streamID;

/// 设置推流的流 ID，主要用于展示流 ID 明文
/// 在 `publishStream:` 方法中调用，于推流前使用
/// @param streamID 推流的流 ID
+ (void)setPublishStreamID:(NSString *)streamID;

@end

NS_ASSUME_NONNULL_END
