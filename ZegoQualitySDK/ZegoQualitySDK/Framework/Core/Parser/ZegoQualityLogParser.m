//
//  ZegoLogFilter.m
//  go_class
//
//  Created by MartinNie on 2021/6/9.
//  Copyright © 2021 zego. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZegoQualityLogParser.h"
#import "ZegoQualityLogDataBase.h"

//NSString * const ZegoStartPlayingStreamTask           = @"StartPlayingStream ";
NSString * const ZegoPerformanceStatusUpdateTask        = @"onPerformanceStatusUpdate ";
NSString * const ZegostartPublishingStreamTask          = @"startPublishingStream ";
NSString * const ZegoStopPublishingStreamTask           = @"StopPublishingStream ";
NSString * const ZegoStopPlayingStreamTask              = @"StopPlayingStream ";
NSString * const ZegoEnableCameraTask                   = @"EnableCamera ";
NSString * const ZegoEnableAudioCaptureDeviceTask       = @"MuteMicrophone ";
NSString * const ZegoPublisherQualityUpdateTask         = @"onPublisherQualityUpdate ";
NSString * const ZegoPlayerQualityUpdateTask            = @"onPlayerQualityUpdate ";
NSString * const ZegoLogoutRoomTask                     = @"LogoutRoom ";


@interface ZegoQualityLogParser ()

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, assign) NSTimeInterval loginSpeed;
@property (nonatomic, copy) NSString *publishStream;
@property (nonatomic, copy) NSString *currentDeviceInfo;
@property (nonatomic, strong) NSDateFormatter *dateFormat;
@property (nonatomic, strong) NSRegularExpression *dataRegular;
@property (nonatomic, strong) dispatch_queue_t dataHandleQue;
@property (nonatomic, strong) NSString *deviceMemoryString;
@property (nonatomic, strong) NSMutableCharacterSet *characterSet;
@property (nonatomic, strong) ZegoQualityLogDataBase *qualityDB;

@end


@implementation ZegoQualityLogParser

- (instancetype)init {
  if (self = [super init]) {
    self.userId = @"";
    self.roomId = @"";
    self.loginSpeed = 0;
    self.characterSet = [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    self.dateFormat = formatter;
    
    self.dataRegular = [NSRegularExpression regularExpressionWithPattern:@"\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}" options:0 error:nil];
    
    self.dataHandleQue = dispatch_queue_create("log_filter_queue", DISPATCH_QUEUE_SERIAL);
    
    self.currentDeviceInfo = [NSString stringWithFormat:@"%@ %@",[UIDevice currentDevice].systemName,[UIDevice currentDevice].systemVersion];
    
    self.qualityDB = [[ZegoQualityLogDataBase alloc] init];
  }
  return self;
}

- (NSString *)deviceMemoryString {
  if (!_deviceMemoryString) {
    CGFloat deviceMemorySize = [NSProcessInfo processInfo].physicalMemory / (1024.0 * 1024.0);
    _deviceMemoryString = [NSString stringWithFormat:@"%.0f", deviceMemorySize];
  }
  return _deviceMemoryString;
}
- (void)parse:(NSString *)data {
  if(data.length < 21) return;
  dispatch_async(self.dataHandleQue, ^{
    NSString *time = [self getLogTime:data];
    NSDictionary *performanceDic = [self getDataFromString:data specialTask:ZegoPerformanceStatusUpdateTask];
    if (performanceDic) {
      ZegoDeviceInfoTableModel *model = [[ZegoDeviceInfoTableModel alloc] init];
      model.user_id = self.userId;
      model.room_id = self.roomId;
      model.cpu_usage_app = performanceDic[@"cpu_usage_app"];
      if (model.cpu_usage_app <= 0 ) return;
      model.cpu_usage_sys = performanceDic[@"cpu_usage_system"];
      model.memory_usage_app = performanceDic[@"memory_usage_app"];
      model.memory_usage_sys = performanceDic[@"memory_usage_system"];
      model.memory_device = [self deviceMemoryString];
      model.sys_version = self.currentDeviceInfo;
      model.timestamp = time;
      [self.qualityDB executeUpdateWithDeviceInfo:model];
      return;
    }
    NSDictionary *publishQualityDic = [self getDataFromString:data specialTask:ZegoPublisherQualityUpdateTask];
    if (publishQualityDic){
      
      ZegoStreamQualityTableModel *model = [[ZegoStreamQualityTableModel alloc] init];
      model.user_id = self.userId;
      model.room_id = self.roomId;
      model.video_bit_rate = publishQualityDic[@"video_kbps"];
      model.audio_bit_rate = publishQualityDic[@"audio_kbps"];
      model.video_frame_rate = publishQualityDic[@"video_capture_fps"];
      model.audio_frame_rate = publishQualityDic[@"audio_capture_fps"];
      model.stream_id_push = self.publishStream;
      model.timestamp = time;
      model.peer_to_peer_delay = publishQualityDic[@"peer_to_peer_delay"];
      [self.qualityDB executeUpdateWithStreamQuality:model];
      return;
    }
    NSDictionary *playQualityDic = [self getDataFromString:data specialTask:ZegoPlayerQualityUpdateTask];
    if (playQualityDic){
      
      ZegoStreamQualityTableModel *model = [[ZegoStreamQualityTableModel alloc] init];
      model.user_id = self.userId;
      model.room_id = self.roomId;
      model.video_bit_rate = playQualityDic[@"video_kbps"];
      model.audio_bit_rate = playQualityDic[@"audio_kbps"];
      model.video_frame_rate = playQualityDic[@"video_recv_fps"];
      model.audio_frame_rate = playQualityDic[@"audio_recv_fps"];
      model.stream_id_play = playQualityDic[@"stream_id"];
      model.video_break_rate = playQualityDic[@"video_cumulative_break_rate"];
      model.audio_break_rate = playQualityDic[@"audio_cumulative_break_rate"];
      model.timestamp = time;
      model.peer_to_peer_delay = playQualityDic[@"peer_to_peer_delay"];
      [self.qualityDB executeUpdateWithStreamQuality:model];
      return;
    }
    //        NSDictionary *playStreamDic = [self getDataFromString:data specialTask:ZegoStartPlayingStreamTask];
    //        if (playStreamDic){
    //            ZegoUserEventTableModel *model = [[ZegoUserEventTableModel alloc] init];
    //            model.user_id = self.userId;
    //            model.room_id = self.roomId;
    //            model.type = @"5";
    //            model.timestamp = time;
    //            model.error_code = playStreamDic[@"error_code"];
    //            model.stream_id = playStreamDic[@"stream_id"];
    //            [self.qualityDB executeUpdateWithUserEvent:model];
    //            return;
    //        }
    NSDictionary *stopPlayDic = [self getDataFromString:data specialTask:ZegoStopPlayingStreamTask];
    if (stopPlayDic){
      ZegoUserEventTableModel *model = [[ZegoUserEventTableModel alloc] init];
      model.user_id = self.userId;
      model.room_id = self.roomId;
      model.type = @"6";
      model.timestamp = time;
      model.error_code = stopPlayDic[@"error_code"];
      model.stream_id = stopPlayDic[@"stream_id"];
      [self.qualityDB executeUpdateWithUserEvent:model];
      return;
    }
    NSDictionary *startPublishDic = [self getDataFromString:data specialTask:ZegostartPublishingStreamTask];
    if (startPublishDic){
      ZegoUserEventTableModel *model = [[ZegoUserEventTableModel alloc] init];
      model.user_id = self.userId;
      model.room_id = self.roomId;
      model.type = @"3";
      model.timestamp = time;
      model.error_code = startPublishDic[@"error_code"];
      model.stream_id = self.publishStream;
      [self.qualityDB executeUpdateWithUserEvent:model];
      return;
    }
    NSDictionary *stopPublishDic =  [self getDataFromString:data specialTask:ZegoStopPublishingStreamTask];
    if (stopPublishDic){
      ZegoUserEventTableModel *model = [[ZegoUserEventTableModel alloc] init];
      model.user_id = self.userId;
      model.room_id = self.roomId;
      model.type = @"4";
      model.timestamp = time;
      model.error_code = stopPublishDic[@"error_code"];
      model.stream_id = self.publishStream;
      [self.qualityDB executeUpdateWithUserEvent:model];
      return;
    }
    NSDictionary *muteCameraDic = [self getDataFromString:data specialTask:ZegoEnableCameraTask];
    if (muteCameraDic){
      ZegoUserEventTableModel *model = [[ZegoUserEventTableModel alloc] init];
      model.user_id = self.userId;
      model.room_id = self.roomId;
      model.type = @"7";
      model.timestamp = time;
      model.error_code = muteCameraDic[@"error_code"];;
      [self.qualityDB executeUpdateWithUserEvent:model];
      return;
    }
    NSDictionary *muteAudioDic = [self getDataFromString:data specialTask:ZegoEnableAudioCaptureDeviceTask];
    if (muteAudioDic){
      ZegoUserEventTableModel *model = [[ZegoUserEventTableModel alloc] init];
      model.user_id = self.userId;
      model.room_id = self.roomId;
      model.type = @"8";
      model.timestamp = time;
      model.error_code = muteAudioDic[@"error_code"];
      [self.qualityDB executeUpdateWithUserEvent:model];
      return;
    }
    NSDictionary *logoutDic = [self getDataFromString:data specialTask:ZegoLogoutRoomTask];
    if (logoutDic){
      ZegoUserEventTableModel *model = [[ZegoUserEventTableModel alloc] init];
      model.user_id = self.userId;
      model.room_id = self.roomId;
      model.type = @"2";
      model.timestamp = time;
      model.error_code = logoutDic[@"error_code"];
      [self.qualityDB executeUpdateWithUserEvent:model];
      return;
    }
  });
}

- (void)setPublishStreamID:(NSString *)streamID {
  dispatch_async(self.dataHandleQue, ^{
    self.publishStream = streamID;
  });
}

- (void)setUserID:(NSString *)userID {
  dispatch_async(self.dataHandleQue, ^{
    self.userId = userID;
  });
}

- (void)setRoomID:(NSString *)roomID {
  dispatch_async(self.dataHandleQue, ^{
    self.roomId = roomID;
  });
}

- (void)setLoginTimeConsuming:(NSTimeInterval)speed {
  dispatch_async(self.dataHandleQue, ^{
    self.loginSpeed = speed;
    ZegoUserEventTableModel *model = [[ZegoUserEventTableModel alloc] init];
    model.user_id = self.userId;
    model.room_id = self.roomId;
    model.type = @"1";
    model.timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    model.error_code = @"0";
    model.stream_id = @"0";
    model.processing_time = [NSString stringWithFormat:@"%.0f",speed * 1000];
    [self.qualityDB executeUpdateWithUserEvent:model];
  });
}

- (void)setFirstFrameRenderTimeConsuming:(NSTimeInterval)timeInterval forPlayerStream:(NSString *)streamID {
  dispatch_async(self.dataHandleQue, ^{
    ZegoUserEventTableModel *model = [[ZegoUserEventTableModel alloc] init];
    model.user_id = self.userId;
    model.room_id = self.roomId;
    model.type = @"5";
    model.timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    model.error_code = @"0";
    model.stream_id = streamID;
    model.processing_time = [NSString stringWithFormat:@"%.0f",timeInterval * 1000];
    [self.qualityDB executeUpdateWithUserEvent:model];
  });
}

- (NSDictionary *)getDataFromString:(NSString *)dataString specialTask:(NSString *)task {
  
  NSRange range = [dataString rangeOfString:task];
  if (range.length > 0) {
    unsigned long  startIndex = range.length + range.location;
    NSString *content = [dataString substringWithRange:NSMakeRange(startIndex,dataString.length - startIndex)];
    return  [self getCommonFormatDataFromString:content];
  } else {
    return  nil;
  }
}

- (NSString *)getLogTime:(NSString *)dataString {
  if (!dataString) {
    return @"";
  }
  
  NSRange timeRange = [self.dataRegular rangeOfFirstMatchInString:dataString options:0 range:NSMakeRange(0, dataString.length)];
  if (timeRange.length < 1) {
    return @"";
  }
  NSString *theTime = [dataString substringWithRange:timeRange];
  
  NSDate *dateTodo = [self.dateFormat dateFromString:theTime];
  NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[dateTodo timeIntervalSince1970]];
  return timeSp;
  
}

- (NSDictionary *)getCommonFormatDataFromString:(NSString *)contentString {
  NSArray *component = [contentString componentsSeparatedByString:@","];
  NSMutableDictionary *dic = [NSMutableDictionary dictionary];
  for (NSString *para in component) {
    NSArray *unitData1 = [para componentsSeparatedByString:@"="];
    if (unitData1.count > 1) {
      NSString *value = [unitData1.firstObject stringByTrimmingCharactersInSet:self.characterSet];
      NSString *key = [unitData1.lastObject stringByTrimmingCharactersInSet:self.characterSet];
      if (key.length > 0 && value > 0) {
        [dic setValue:key forKey:value];
        
      } else {
        return nil;
      }
    }
    //这里由于拉流质量回调日志中流id是用：区分的，其他字段是用=区分的
    NSArray *unitData2 = [para componentsSeparatedByString:@":"];
    if (unitData2.count > 1) {
      NSString *value = [unitData2.firstObject stringByTrimmingCharactersInSet:self.characterSet];
      NSString *key = [unitData2.lastObject stringByTrimmingCharactersInSet:self.characterSet];
      if (key.length > 0 && value > 0) {
        [dic setValue:key forKey:value];
        
      } else {
        return nil;
      }
    }
  }
  ZegoQualityLog(@"=== %@",dic.description);
  return dic.copy;
}

@end
