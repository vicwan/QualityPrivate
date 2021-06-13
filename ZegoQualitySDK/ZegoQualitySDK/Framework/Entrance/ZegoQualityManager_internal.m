//
//  ZegoQualityManager_internal.m
//  go_class
//
//  Created by Vic on 2021/6/12.
//  Copyright © 2021 zego. All rights reserved.
//

#import "ZegoQualityManager_internal.h"
#import "ZegoQualityLogParser.h"
#import "ZegoQualityLogDataBase.h"
#import "ZegoQualityCalculator.h"

@interface ZegoQualityManager_internal ()

@property (nonatomic, strong) ZegoQualityLogDataBase *qualityDB;
@property (nonatomic, strong) ZegoQualityCalculator *qualityCalculator;
@property (nonatomic, strong) ZegoQualityLogParser *logFilter;

@end

@implementation ZegoQualityManager_internal

static dispatch_once_t onceToken;
static id _instance;
+ (instancetype)shared {
  dispatch_once(&onceToken, ^{
    _instance = [[self alloc] init];
  });
  return _instance;
}

- (void)destroy {
  // 释放单例
  onceToken = 0;
  _instance = nil;
}

- (void)initQuality {
  /*
   创建并打开数据库
   */
  [self.qualityDB createQualityDB];
}

- (void)unInitQuality {
  /*
   1. 关闭数据库（暂不销毁）
   2. 释放 qualityCalculator 资源（ARC 大概率自动释放了）
   */
  [self.qualityDB closeDB];
  [self destroy];
}

- (void)parsingLog:(NSString *)log {
  [self.logFilter filterLogData:log];
}

- (void)setUserID:(NSString *)userID {
  _userID = userID;
  [self.logFilter setupUserID:userID];
}

- (void)setRoomID:(NSString *)roomID {
  _roomID = roomID;
  [self.logFilter setupRoomID:roomID];
}

- (void)setLoginOnStart {
  [self.qualityCalculator setLoginOnStart];
}

- (void)setLoginOnFinish {
  NSTimeInterval loginTimeConsuming = [self.qualityCalculator timeIntervalOnLoginFinish];
  [self.logFilter setupLoginSpeed:loginTimeConsuming];
}

- (void)setPlayerStreamOnStart:(NSString *)streamID {
  [self.qualityCalculator setPlayerStreamOnStart:streamID];
}

- (void)setPlayerStreamOnFirstFrame:(NSString *)streamID {
  NSTimeInterval firstFrameTimeConsuming = [self.qualityCalculator timeIntervalForPlayerStreamOnFirstFrame:streamID];
  [self.logFilter setupPlayStream:streamID FirstFrameSpeed:firstFrameTimeConsuming];
}

- (void)setPublishStreamID:(NSString *)streamID {
  [self.logFilter setupPublishStream:streamID];
}


#pragma mark - Lazy
- (ZegoQualityLogDataBase *)qualityDB {
  if (!_qualityDB) {
    _qualityDB = [[ZegoQualityLogDataBase alloc] init];
  }
  return _qualityDB;
}

- (ZegoQualityCalculator *)qualityCalculator {
  if (!_qualityCalculator) {
    _qualityCalculator = [[ZegoQualityCalculator alloc] init];
  }
  return _qualityCalculator;
}

- (ZegoQualityLogParser *)logFilter {
  if (!_logFilter) {
    _logFilter = [[ZegoQualityLogParser alloc] init];
  }
  return _logFilter;
}

@end
