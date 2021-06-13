//
//  ZegoQualityLogDataBase.h
//  NewOne
//
//  Created by Vic on 2021/6/9.
//

#import <Foundation/Foundation.h>
#import "ZegoQualityDataBaseTableModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZegoQualityLogDataBase : NSObject

- (void)createQualityDB;
- (void)closeDB;

- (void)executeUpdateWithUserEvent:(ZegoUserEventTableModel *)userEvent;
- (void)executeUpdateWithDeviceInfo:(ZegoDeviceInfoTableModel *)deviceInfo;
- (void)executeUpdateWithStreamQuality:(ZegoStreamQualityTableModel *)streamQuality;

- (void)executeQueryUserEventWithSql:(NSString *)sql complete:(void(^)(NSArray<ZegoUserEventTableModel *> *models))complete;
- (void)executeQueryDeviceInfoWithSql:(NSString *)sql complete:(void(^)(NSArray<ZegoDeviceInfoTableModel *> *models))complete;
- (void)executeQueryStreamQualityWithSql:(NSString *)sql complete:(void(^)(NSArray<ZegoStreamQualityTableModel *> *models))complete;

@end

NS_ASSUME_NONNULL_END
