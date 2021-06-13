//
//  ZegoQualityViewController.h
//  go_class
//
//  Created by Vic on 2021/6/10.
//  Copyright © 2021 zego. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZegoQualityVCConfig.h"
#import "ZegoQualityViewControllerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZegoQualityViewController : UIViewController

@property (nonatomic, weak) id<ZegoQualityViewControllerProtocol> delegate;

- (instancetype)initWithConfig:(ZegoQualityVCConfig *)config;

@end

NS_ASSUME_NONNULL_END
