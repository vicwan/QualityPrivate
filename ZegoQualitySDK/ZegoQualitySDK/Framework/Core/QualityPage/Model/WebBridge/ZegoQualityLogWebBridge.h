//
//  ZegoQualityLogWebBridge.h
//  NewOne
//
//  Created by Vic on 2021/6/9.
//

#import <Foundation/Foundation.h>
#import "ZegoQualityWebBridgeModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface ZegoQualityLogWebBridge : NSObject

- (void)execQueryWithModel:(ZegoQualityLogWebQueryRequestModel *)rqst complete:(void(^)(ZegoQualityLogWebQueryResponseModel *rsp))complete;

@end

NS_ASSUME_NONNULL_END
