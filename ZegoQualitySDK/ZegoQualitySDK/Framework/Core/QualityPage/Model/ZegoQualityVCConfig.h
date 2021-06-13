//
//  ZegoQualityVCConfig.h
//  go_class
//
//  Created by Vic on 2021/6/10.
//  Copyright © 2021 zego. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZegoQualityDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZegoQualityVCConfig : NSObject

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *roomID;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, assign) ZegoQualityLanguageType languageType;

@end

NS_ASSUME_NONNULL_END
