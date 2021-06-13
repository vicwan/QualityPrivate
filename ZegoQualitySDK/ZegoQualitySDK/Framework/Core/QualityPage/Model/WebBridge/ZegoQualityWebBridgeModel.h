//
//  ZegoQualityWebBridgeModel.h
//  go_class
//
//  Created by Vic on 2021/6/10.
//  Copyright © 2021 zego. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZegoQualityDataBaseTableModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZegoQualityLogWebQueryRequestModel : NSObject

@property (nonatomic, assign) NSNumber *seq;
@property (nonatomic, copy) NSString *queryTableName;
@property (nonatomic, copy) NSString *querySqlString;

@end

@interface ZegoQualityLogWebQueryResponseModel : NSObject

@property (nonatomic, assign) NSNumber *seq;
@property (nonatomic, strong) NSArray<ZegoQualityDataBaseTableModel *> *dataModel;

@end

NS_ASSUME_NONNULL_END
