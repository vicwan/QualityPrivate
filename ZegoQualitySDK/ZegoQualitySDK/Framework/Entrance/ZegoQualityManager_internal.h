//
//  ZegoQualityManager_internal.h
//  go_class
//
//  Created by Vic on 2021/6/12.
//  Copyright © 2021 zego. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZegoQualityDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZegoQualityManager_internal : NSObject

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *roomID;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *AppVersion;
@property (nonatomic, assign) ZegoQualityLanguageType languageType;

+ (instancetype)shared;

- (void)initQuality;

- (void)unInitQuality;

- (void)parsingLog:(NSString *)log;

- (void)setLoginOnStart;

- (void)setLoginOnFinish;

- (void)setPlayerStreamOnStart:(NSString *)streamID;

- (void)setPlayerStreamOnFirstFrame:(NSString *)streamID;

- (void)setPublishStreamID:(NSString *)streamID;

@end

NS_ASSUME_NONNULL_END
