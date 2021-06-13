//
//  ZegoQualityLogWebBridge.m
//  NewOne
//
//  Created by Vic on 2021/6/9.
//

#import "ZegoQualityLogWebBridge.h"
#import "ZegoQualityLogDataBase.h"


@interface ZegoQualityLogWebBridge ()

@property (nonatomic, strong) ZegoQualityLogDataBase *db;

@end

@implementation ZegoQualityLogWebBridge

- (ZegoQualityLogDataBase *)db {
  if (!_db) {
    _db = [[ZegoQualityLogDataBase alloc] init];
  }
  return _db;
}

- (void)execQueryWithModel:(ZegoQualityLogWebQueryRequestModel *)rqst complete:(void (^)(ZegoQualityLogWebQueryResponseModel * _Nonnull))complete {
  
  NSString *tableName = rqst.queryTableName;
  NSString *sql = rqst.querySqlString;
  
  ZegoQualityLogWebQueryResponseModel *rsp = [[ZegoQualityLogWebQueryResponseModel alloc] init];
  rsp.seq = rqst.seq;
  
  if ([tableName isEqualToString:kUserEventTableName]) {
    [self.db executeQueryUserEventWithSql:sql complete:^(NSArray<ZegoUserEventTableModel *> * _Nonnull models) {
      rsp.dataModel = models;
      if (complete) {
        complete(rsp);
      }
    }];
    
  }else if ([tableName isEqualToString:kDeviceInfoTableName]) {
    [self.db executeQueryDeviceInfoWithSql:sql complete:^(NSArray<ZegoDeviceInfoTableModel *> * _Nonnull models) {
      rsp.dataModel = models;
      if (complete) {
        complete(rsp);
      }
    }];
    
  }else if ([tableName isEqualToString:kStreamQualityTableName]) {
    [self.db executeQueryStreamQualityWithSql:sql complete:^(NSArray<ZegoStreamQualityTableModel *> * _Nonnull models) {
      rsp.dataModel = models;
      if (complete) {
        complete(rsp);
      }
    }];
  }
}

@end
