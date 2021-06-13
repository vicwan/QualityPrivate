//
//  ZegoQualityManager.m
//  go_class
//
//  Created by Vic on 2021/6/11.
//  Copyright © 2021 zego. All rights reserved.
//

#import "ZegoQualityManager.h"
#import "ZegoQualityManager_internal.h"

@implementation ZegoQualityManager

NS_INLINE ZegoQualityManager_internal * _internal(void) {
  return [ZegoQualityManager_internal shared];
}

+ (void)init {
  [_internal() initQuality];
}

+ (void)unInit {
  [_internal() unInitQuality];
}

+ (void)parsingLog:(NSString *)log {
  [_internal() parsingLog:log];
}

@end

@implementation ZegoQualityManager (Setup)

+ (void)setUserID:(NSString *)userID {
  [_internal() setUserID:userID];
}

+ (void)setUserName:(NSString *)userName {
  [_internal() setUserName:userName];
}

+ (void)setRoomID:(NSString *)roomID {
  [_internal() setRoomID:roomID];
}

+ (void)setProductName:(NSString *)productName {
  [_internal() setProductName:productName];
}

+ (void)setAppVersion:(NSString *)appVersion {
  [_internal() setAppVersion:appVersion];
}

+ (void)setLanguageType:(ZegoQualityLanguageType)languageType {
  [_internal() setLanguageType:languageType];
}

+ (void)setLoginOnStart {
  [_internal() setLoginOnStart];
}

+ (void)setLoginOnFinish {
  [_internal() setLoginOnFinish];
}

+ (void)setPlayerStreamOnStart:(NSString *)streamID {
  [_internal() setPlayerStreamOnStart:streamID];
}

+ (void)setPlayerStreamOnFirstFrame:(NSString *)streamID {
  [_internal() setPlayerStreamOnFirstFrame:streamID];
}

+ (void)setPublishStreamID:(NSString *)streamID {
  [_internal() setPublishStreamID:streamID];
}

@end

