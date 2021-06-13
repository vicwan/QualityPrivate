//
//  ZegoQualityCalculator.m
//  go_class
//
//  Created by Vic on 2021/6/12.
//  Copyright © 2021 zego. All rights reserved.
//

#import "ZegoQualityCalculator.h"

@interface ZegoQualityCalculator ()

@property (nonatomic, strong) NSMutableDictionary *streamMap; // streamID: NSDate
@property (nonatomic, strong) NSDate *loginStartDate;

@end

@implementation ZegoQualityCalculator

- (void)setLoginOnStart {
  self.loginStartDate = [NSDate date];
}

- (NSTimeInterval)timeIntervalOnLoginFinish {
  if (!self.loginStartDate) {
    return -1;
  }
  NSDate *loginFinishDate = [NSDate date];
  NSTimeInterval timeConsuming = [loginFinishDate timeIntervalSinceDate:self.loginStartDate];
  return timeConsuming;
}

- (void)setPlayerStreamOnStart:(NSString *)streamID {
  NSDate *streamStartPlayDate = [NSDate date];
  [self.streamMap setObject:streamStartPlayDate forKey:streamID];
}

- (NSTimeInterval)timeIntervalForPlayerStreamOnFirstFrame:(NSString *)streamID {
  NSDate *startDate = self.streamMap[streamID];
  if (!startDate) {
    return -1;
  }
  NSDate *endDate = [NSDate date];
  NSTimeInterval interval = [endDate timeIntervalSinceDate:startDate];
  return interval;
}


#pragma mark - lazy
- (NSMutableDictionary *)streamMap {
  if (!_streamMap) {
    _streamMap = [NSMutableDictionary dictionary];
  }
  return _streamMap;
}
@end
