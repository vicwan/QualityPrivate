//
//  ZegoQualityLogDataBase.m
//  NewOne
//
//  Created by Vic on 2021/6/9.
//

#import "ZegoQualityLogDataBase.h"
#import "ZGDB.h"

@interface ZegoQualityLogDataBase ()

@property (nonatomic, strong) ZGDatabase *db;
@property (nonatomic, strong) ZGDatabaseQueue *dbQueue;
@property (nonatomic, copy) NSString *dbPath;

@property (nonatomic, strong) dispatch_queue_t dbExecutionQueue;

@end


@implementation ZegoQualityLogDataBase

- (dispatch_queue_t)dbExecutionQueue {
  if (!_dbExecutionQueue) {
    _dbExecutionQueue = dispatch_queue_create("quality_db_queue.zego.im", DISPATCH_QUEUE_CONCURRENT);
  }
  return _dbExecutionQueue;
}

- (NSString *)dbPath {
  if (!_dbPath) {
    _dbPath = [[[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject].path stringByAppendingPathComponent:@"Caches/ZegoQualityDB.db"];
  }
  return _dbPath;
}

- (ZGDatabase *)db {
  if (!_db) {
    _db = [ZGDatabase databaseWithPath:self.dbPath];
  }
  return _db;
}

- (ZGDatabaseQueue *)dbQueue {
  if (!_dbQueue) {
    _dbQueue = [ZGDatabaseQueue databaseQueueWithPath:self.dbPath];
  }
  return _dbQueue;
}

- (void)createQualityDB {
  // 先删除 db
//  NSString *dbPath = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject].path stringByAppendingPathComponent:@"ZegoQualityDB.db"];
  
//  [[NSFileManager defaultManager] removeItemAtPath:dbPath error:NULL];
  
//  ZGDatabase *db = [ZGDatabase databaseWithPath:dbPath];
//  self.db = db;
//
//  ZGDatabaseQueue *dbQueue = [ZGDatabaseQueue databaseQueueWithPath:dbPath];
//  self.dbQueue = dbQueue;
  
  BOOL open = [self.db open];
  NSLog(@"QUALITY DB OPEN: %d", open);
  
  NSString *createUserEventSql =
  [NSString stringWithFormat:
   @"CREATE TABLE IF NOT EXISTS %@ ("
   "ID integer PRIMARY KEY AUTOINCREMENT,"
   "user_id text,"
   "room_id text,"
   "timestamp text,"
   "type text,"
   "processing_time text,"
   "stream_id text,"
   "error_code text"
  ")", kUserEventTableName];
  
  NSString *createDeviceInfoSql =
  [NSString stringWithFormat:
   @"CREATE TABLE IF NOT EXISTS %@ ("
   "ID integer PRIMARY KEY AUTOINCREMENT,"
   "user_id text,"
   "room_id text,"
   "timestamp text,"
   "cpu_usage_app text,"
   "cpu_usage_sys text,"
   "memory_device text,"
   "memory_usage_app text,"
   "memory_usage_sys text,"
   "sys_version text"
  ")", kDeviceInfoTableName];
  
  NSString *createStreamQualitySql =
  [NSString stringWithFormat:
   @"CREATE TABLE IF NOT EXISTS %@ ("
   "ID integer PRIMARY KEY AUTOINCREMENT,"
   "user_id text,"
   "room_id text,"
   "timestamp text,"
   "video_bit_rate text,"
   "audio_bit_rate text,"
   "video_frame_rate text,"
   "audio_frame_rate text,"
   "stream_id_push text,"
   "stream_id_play text,"
   "video_break_rate text,"
   "audio_break_rate text,"
   "peer_to_peer_delay text"
   ")", kStreamQualityTableName];
  
  [self.dbQueue inTransaction:^(ZGDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
    [db executeStatements:createUserEventSql];
    [db executeStatements:createDeviceInfoSql];
    [db executeStatements:createStreamQualitySql];
  }];
}

- (void)closeDB {
  [self.db close];
}

- (void)executeUpdateWithUserEvent:(ZegoUserEventTableModel *)userEvent {
  performOnBackgroundThread(^{
    NSString *sql =
    [NSString stringWithFormat:
     @"INSERT OR REPLACE INTO %@ ("
     "user_id,"
     "room_id,"
     "timestamp,"
     "type,"
     "processing_time,"
     "stream_id,"
     "error_code"
    ") VALUES (?,?,?,?,?,?,?)", kUserEventTableName];
    
    [self.dbQueue inTransaction:^(ZGDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
      BOOL suc = [db executeUpdate:sql,
                  userEvent.user_id,
                  userEvent.room_id,
                  userEvent.timestamp,
                  userEvent.type,
                  userEvent.processing_time,
                  userEvent.stream_id,
                  userEvent.error_code];
      NSLog(@"update user event result: %d", suc);
    }];
  });
}

- (void)executeUpdateWithDeviceInfo:(ZegoDeviceInfoTableModel *)deviceInfo {
  performOnBackgroundThread(^{
    NSString *sql =
    [NSString stringWithFormat:
     @"INSERT OR REPLACE INTO %@ ("
     "user_id,"
     "room_id,"
     "timestamp,"
     "cpu_usage_app,"
     "cpu_usage_sys,"
     "memory_device,"
     "memory_usage_app,"
     "memory_usage_sys,"
     "sys_version"
    ") VALUES (?,?,?,?,?,?,?,?,?)", kDeviceInfoTableName];
    
    [self.dbQueue inTransaction:^(ZGDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
      BOOL suc = [db executeUpdate:sql,
                  deviceInfo.user_id,
                  deviceInfo.room_id,
                  deviceInfo.timestamp,
                  deviceInfo.cpu_usage_app,
                  deviceInfo.cpu_usage_sys,
                  deviceInfo.memory_device,
                  deviceInfo.memory_usage_app,
                  deviceInfo.memory_usage_sys,
                  deviceInfo.sys_version];
      NSLog(@"update device info result: %d", suc);
    }];
  });
}

- (void)executeUpdateWithStreamQuality:(ZegoStreamQualityTableModel *)streamQuality {
  performOnBackgroundThread(^{
    NSString *sql =
    [NSString stringWithFormat:
     @"INSERT OR REPLACE INTO %@ ("
     "user_id,"
     "room_id,"
     "timestamp,"
     "video_bit_rate,"
     "audio_bit_rate,"
     "video_frame_rate,"
     "audio_frame_rate,"
     "stream_id_push,"
     "stream_id_play,"
     "video_break_rate,"
     "audio_break_rate,"
     "peer_to_peer_delay"
     ")VALUES (?,?,?,?,?,?,?,?,?,?,?,?)", kStreamQualityTableName];
    
    [self.dbQueue inTransaction:^(ZGDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
      BOOL suc = [db executeUpdate:sql,
                  streamQuality.user_id,
                  streamQuality.room_id,
                  streamQuality.timestamp,
                  streamQuality.video_bit_rate,
                  streamQuality.audio_bit_rate,
                  streamQuality.video_frame_rate,
                  streamQuality.audio_frame_rate,
                  streamQuality.stream_id_push,
                  streamQuality.stream_id_play,
                  streamQuality.video_break_rate,
                  streamQuality.audio_break_rate,
                  streamQuality.peer_to_peer_delay];
      NSLog(@"update stream quality result: %d", suc);
    }];
  });
}

#pragma mark - Query
- (void)executeQueryUserEventWithSql:(NSString *)sql complete:(nonnull void (^)(NSArray<ZegoUserEventTableModel *> * _Nonnull))complete {
  __block NSMutableArray *models = [NSMutableArray array];
  [self.dbQueue inTransaction:^(ZGDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
    ZGResultSet *res = [db executeQuery:sql];
    while ([res next]) {
      ZegoUserEventTableModel *model = [[ZegoUserEventTableModel alloc] init];
      model.ID = [NSString stringWithFormat:@"%d", [res intForColumn:@"ID"]];
      model.user_id = [res stringForColumn:@"user_id"];
      model.room_id = [res stringForColumn:@"room_id"];
      model.timestamp = [res stringForColumn:@"timestamp"];
      model.type = [res stringForColumn:@"type"];
      model.processing_time = [res stringForColumn:@"processing_time"];
      model.stream_id = [res stringForColumn:@"stream_id"];
      model.error_code = [res stringForColumn:@"error_code"];
      
      [models addObject:model];
    }
    [res close];
    
    if (complete) {
      complete(models);
    }
  }];
}

- (void)executeQueryDeviceInfoWithSql:(NSString *)sql complete:(nonnull void (^)(NSArray<ZegoDeviceInfoTableModel *> * _Nonnull))complete {
  __block NSMutableArray *models = [NSMutableArray array];
  [self.dbQueue inTransaction:^(ZGDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
    ZGResultSet *res = [db executeQuery:sql];
    while ([res next]) {
      ZegoDeviceInfoTableModel *model = [[ZegoDeviceInfoTableModel alloc] init];
      model.ID = [NSString stringWithFormat:@"%d", [res intForColumn:@"ID"]];
      model.user_id = [res stringForColumn:@"user_id"];
      model.room_id = [res stringForColumn:@"room_id"];
      model.timestamp = [res stringForColumn:@"timestamp"];
      model.cpu_usage_app = [res stringForColumn:@"cpu_usage_app"];
      model.cpu_usage_sys = [res stringForColumn:@"cpu_usage_sys"];
      model.memory_device = [res stringForColumn:@"memory_device"];
      model.memory_usage_app = [res stringForColumn:@"memory_usage_app"];
      model.memory_usage_sys = [res stringForColumn:@"memory_usage_sys"];
      model.sys_version = [res stringForColumn:@"sys_version"];
      
      [models addObject:model];
    }
    [res close];
    
    if (complete) {
      complete(models);
    }
  }];
}

- (void)executeQueryStreamQualityWithSql:(NSString *)sql complete:(nonnull void (^)(NSArray<ZegoStreamQualityTableModel *> * _Nonnull))complete {
  __block NSMutableArray *models = [NSMutableArray array];
  [self.dbQueue inTransaction:^(ZGDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
    ZGResultSet *res = [db executeQuery:sql];
    while ([res next]) {
      ZegoStreamQualityTableModel *model = [[ZegoStreamQualityTableModel alloc] init];
      model.ID = [NSString stringWithFormat:@"%d", [res intForColumn:@"ID"]];
      model.user_id = [res stringForColumn:@"user_id"];
      model.room_id = [res stringForColumn:@"room_id"];
      model.timestamp = [res stringForColumn:@"timestamp"];
      model.video_bit_rate = [res stringForColumn:@"video_bit_rate"];
      model.audio_bit_rate = [res stringForColumn:@"audio_bit_rate"];
      model.video_frame_rate = [res stringForColumn:@"video_frame_rate"];
      model.audio_frame_rate = [res stringForColumn:@"audio_frame_rate"];
      model.stream_id_push = [res stringForColumn:@"stream_id_push"];
      model.stream_id_play = [res stringForColumn:@"stream_id_play"];
      model.video_break_rate = [res stringForColumn:@"video_break_rate"];
      model.audio_break_rate = [res stringForColumn:@"audio_break_rate"];
      model.peer_to_peer_delay = [res stringForColumn:@"peer_to_peer_delay"];
      
      [models addObject:model];
    }
    [res close];
    
    if (complete) {
      complete(models);
    }
  }];
}

#pragma mark -
void performOnBackgroundThread(void(^block)(void)) {
  if (block) {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
      block();
    });
  }
}

@end
