//
//  ZegoQualityFactory.m
//  go_class
//
//  Created by Vic on 2021/6/12.
//  Copyright © 2021 zego. All rights reserved.
//

#import "ZegoQualityFactory.h"
#import "ZegoQualityViewController.h"
#import "ZegoQualityManager_internal.h"

@implementation ZegoQualityFactory

+ (UIViewController *)qualityViewControllerWithDelegate:(id<ZegoQualityViewControllerProtocol>)delegate {
  ZegoQualityManager_internal *_manager = [ZegoQualityManager_internal shared];
  
  ZegoQualityVCConfig *config = [[ZegoQualityVCConfig alloc] init];
  config.userID = _manager.userID;
  config.userName = _manager.userName;
  config.roomID = _manager.roomID;
  config.productName = _manager.productName;
  config.appVersion = _manager.AppVersion;
  config.languageType = _manager.languageType;
  
  ZegoQualityViewController *qualityVC = [[ZegoQualityViewController alloc] initWithConfig:config];
  qualityVC.delegate = delegate;
  return qualityVC;
}

@end
