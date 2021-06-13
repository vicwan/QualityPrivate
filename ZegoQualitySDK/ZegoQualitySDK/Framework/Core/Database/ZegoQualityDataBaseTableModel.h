//
//  ZegoQualityDataBaseTableModel.h
//  go_class
//
//  Created by Vic on 2021/6/10.
//  Copyright © 2021 zego. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const kUserEventTableName;
FOUNDATION_EXPORT NSString * const kDeviceInfoTableName;
FOUNDATION_EXPORT NSString * const kStreamQualityTableName;

@interface ZegoQualityDataBaseTableModel : NSObject

@end

@interface ZegoDeviceInfoTableModel : ZegoQualityDataBaseTableModel

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *room_id;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, copy) NSString *cpu_usage_app;
@property (nonatomic, copy) NSString *cpu_usage_sys;
@property (nonatomic, copy) NSString *memory_device;
@property (nonatomic, copy) NSString *memory_usage_app;
@property (nonatomic, copy) NSString *memory_usage_sys;
@property (nonatomic, copy) NSString *sys_version;

@end

@interface ZegoStreamQualityTableModel : ZegoQualityDataBaseTableModel

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *room_id;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, copy) NSString *video_bit_rate;
@property (nonatomic, copy) NSString *audio_bit_rate;
@property (nonatomic, copy) NSString *video_frame_rate;
@property (nonatomic, copy) NSString *audio_frame_rate;
@property (nonatomic, copy) NSString *stream_id_push;
@property (nonatomic, copy) NSString *stream_id_play;
@property (nonatomic, copy) NSString *video_break_rate;
@property (nonatomic, copy) NSString *audio_break_rate;
@property (nonatomic, copy) NSString *peer_to_peer_delay;

@end

@interface ZegoUserEventTableModel : ZegoQualityDataBaseTableModel

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *room_id;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *processing_time;
@property (nonatomic, copy) NSString *stream_id;
@property (nonatomic, copy) NSString *error_code;

@end

NS_ASSUME_NONNULL_END
