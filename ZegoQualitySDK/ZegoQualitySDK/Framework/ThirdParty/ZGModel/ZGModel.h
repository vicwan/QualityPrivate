//
//  ZGModel.h
//  ZGModel <https://github.com/ibireme/ZGModel>
//
//  Created by ibireme on 15/5/10.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

#if __has_include(<ZGModel/ZGModel.h>)
FOUNDATION_EXPORT double ZGModelVersionNumber;
FOUNDATION_EXPORT const unsigned char ZGModelVersionString[];
#import <ZGModel/NSObject+ZGModel.h>
#import <ZGModel/ZGClassInfo.h>
#else
#import "NSObject+ZGModel.h"
#import "ZGClassInfo.h"
#endif
