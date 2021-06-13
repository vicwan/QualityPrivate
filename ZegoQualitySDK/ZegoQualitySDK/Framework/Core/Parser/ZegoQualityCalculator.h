//
//  ZegoQualityCalculator.h
//  go_class
//
//  Created by Vic on 2021/6/12.
//  Copyright © 2021 zego. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZegoQualityCalculator : NSObject

- (void)setLoginOnStart;
- (NSTimeInterval)timeIntervalOnLoginFinish;

- (void)setPlayerStreamOnStart:(NSString *)streamID;
- (NSTimeInterval)timeIntervalForPlayerStreamOnFirstFrame:(NSString *)streamID;

@end

NS_ASSUME_NONNULL_END
