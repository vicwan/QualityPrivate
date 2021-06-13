//
//  ZGDatabasePool.h
//  fmdb
//
//  Created by August Mueller on 6/22/11.
//  Copyright 2011 Flying Meat Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ZGDatabase;

/** Pool of @c ZGDatabase  objects.

 See also
 
 - @c ZGDatabaseQueue
 - @c ZGDatabase

 @warning Before using @c ZGDatabasePool , please consider using @c ZGDatabaseQueue  instead.

 If you really really really know what you're doing and @c ZGDatabasePool  is what
 you really really need (ie, you're using a read only database), OK you can use
 it.  But just be careful not to deadlock!

 For an example on deadlocking, search for:
 `ONLY_USE_THE_POOL_IF_YOU_ARE_DOING_READS_OTHERWISE_YOULL_DEADLOCK_USE_ZGDATABASEQUEUE_INSTEAD`
 in the main.m file.
 */

@interface ZGDatabasePool : NSObject

/** Database path */

@property (atomic, copy, nullable) NSString *path;

/** Delegate object */

@property (atomic, assign, nullable) id delegate;

/** Maximum number of databases to create */

@property (atomic, assign) NSUInteger maximumNumberOfDatabasesToCreate;

/** Open flags */

@property (atomic, readonly) int openFlags;

/**  Custom virtual file system name */

@property (atomic, copy, nullable) NSString *vfsName;


///---------------------
/// @name Initialization
///---------------------

/** Create pool using path.
 
 @param aPath The file path of the database.
 
 @return The @c ZGDatabasePool  object. @c nil  on error.
 */

+ (instancetype)databasePoolWithPath:(NSString * _Nullable)aPath;

/** Create pool using file URL.
 
 @param url The file @c NSURL  of the database.
 
 @return The @c ZGDatabasePool  object. @c nil  on error.
 */

+ (instancetype)databasePoolWithURL:(NSURL * _Nullable)url;

/** Create pool using path and specified flags
 
 @param aPath The file path of the database.
 @param openFlags Flags passed to the openWithFlags method of the database.
 
 @return The @c ZGDatabasePool  object. @c nil  on error.
 */

+ (instancetype)databasePoolWithPath:(NSString * _Nullable)aPath flags:(int)openFlags;

/** Create pool using file URL and specified flags
 
 @param url The file @c NSURL  of the database.
 @param openFlags Flags passed to the openWithFlags method of the database.
 
 @return The @c ZGDatabasePool  object. @c nil  on error.
 */

+ (instancetype)databasePoolWithURL:(NSURL * _Nullable)url flags:(int)openFlags;

/** Create pool using path.
 
 @param aPath The file path of the database.
 
 @return The @c ZGDatabasePool  object. @c nil  on error.
 */

- (instancetype)initWithPath:(NSString * _Nullable)aPath;

/** Create pool using file URL.
 
 @param url The file `NSURL of the database.
 
 @return The @c ZGDatabasePool  object. @c nil  on error.
 */

- (instancetype)initWithURL:(NSURL * _Nullable)url;

/** Create pool using path and specified flags.
 
 @param aPath The file path of the database.
 @param openFlags Flags passed to the openWithFlags method of the database
 
 @return The @c ZGDatabasePool  object. @c nil  on error.
 */

- (instancetype)initWithPath:(NSString * _Nullable)aPath flags:(int)openFlags;

/** Create pool using file URL and specified flags.
 
 @param url The file @c NSURL  of the database.
 @param openFlags Flags passed to the openWithFlags method of the database
 
 @return The @c ZGDatabasePool  object. @c nil  on error.
 */

- (instancetype)initWithURL:(NSURL * _Nullable)url flags:(int)openFlags;

/** Create pool using path and specified flags.
 
 @param aPath The file path of the database.
 @param openFlags Flags passed to the openWithFlags method of the database
 @param vfsName The name of a custom virtual file system
 
 @return The @c ZGDatabasePool  object. @c nil  on error.
 */

- (instancetype)initWithPath:(NSString * _Nullable)aPath flags:(int)openFlags vfs:(NSString * _Nullable)vfsName;

/** Create pool using file URL and specified flags.
 
 @param url The file @c NSURL  of the database.
 @param openFlags Flags passed to the openWithFlags method of the database
 @param vfsName The name of a custom virtual file system
 
 @return The @c ZGDatabasePool  object. @c nil  on error.
 */

- (instancetype)initWithURL:(NSURL * _Nullable)url flags:(int)openFlags vfs:(NSString * _Nullable)vfsName;

/** Returns the Class of 'ZGDatabase' subclass, that will be used to instantiate database object.

 Subclasses can override this method to return specified Class of 'ZGDatabase' subclass.

 @return The Class of 'ZGDatabase' subclass, that will be used to instantiate database object.
 */

+ (Class)databaseClass;

///------------------------------------------------
/// @name Keeping track of checked in/out databases
///------------------------------------------------

/** Number of checked-in databases in pool
 */

@property (nonatomic, readonly) NSUInteger countOfCheckedInDatabases;

/** Number of checked-out databases in pool
 */

@property (nonatomic, readonly) NSUInteger countOfCheckedOutDatabases;

/** Total number of databases in pool
 */

@property (nonatomic, readonly) NSUInteger countOfOpenDatabases;

/** Release all databases in pool */

- (void)releaseAllDatabases;

///------------------------------------------
/// @name Perform database operations in pool
///------------------------------------------

/** Synchronously perform database operations in pool.

 @param block The code to be run on the @c ZGDatabasePool  pool.
 */

- (void)inDatabase:(__attribute__((noescape)) void (^)(ZGDatabase *db))block;

/** Synchronously perform database operations in pool using transaction.
 
 @param block The code to be run on the @c ZGDatabasePool  pool.
 
 @warning   Unlike SQLite's `BEGIN TRANSACTION`, this method currently performs
            an exclusive transaction, not a deferred transaction. This behavior
            is likely to change in future versions of ZGDB, whereby this method
            will likely eventually adopt standard SQLite behavior and perform
            deferred transactions. If you really need exclusive tranaction, it is
            recommended that you use `inExclusiveTransaction`, instead, not only
            to make your intent explicit, but also to future-proof your code.
  */

- (void)inTransaction:(__attribute__((noescape)) void (^)(ZGDatabase *db, BOOL *rollback))block;

/** Synchronously perform database operations in pool using exclusive transaction.
 
 @param block The code to be run on the @c ZGDatabasePool  pool.
 */

- (void)inExclusiveTransaction:(__attribute__((noescape)) void (^)(ZGDatabase *db, BOOL *rollback))block;

/** Synchronously perform database operations in pool using deferred transaction.

 @param block The code to be run on the @c ZGDatabasePool  pool.
 */

- (void)inDeferredTransaction:(__attribute__((noescape)) void (^)(ZGDatabase *db, BOOL *rollback))block;

/** Synchronously perform database operations on queue, using immediate transactions.

 @param block The code to be run on the queue of @c ZGDatabaseQueue
 */

- (void)inImmediateTransaction:(__attribute__((noescape)) void (^)(ZGDatabase *db, BOOL *rollback))block;

/** Synchronously perform database operations in pool using save point.

 @param block The code to be run on the @c ZGDatabasePool  pool.
 
 @return @c NSError  object if error; @c nil  if successful.

 @warning You can not nest these, since calling it will pull another database out of the pool and you'll get a deadlock. If you need to nest, use @c startSavePointWithName:error:  instead.
*/

- (NSError * _Nullable)inSavePoint:(__attribute__((noescape)) void (^)(ZGDatabase *db, BOOL *rollback))block;

@end


/** ZGDatabasePool delegate category
 
 This is a category that defines the protocol for the ZGDatabasePool delegate
 */

@interface NSObject (ZGDatabasePoolDelegate)

/** Asks the delegate whether database should be added to the pool. 
 
 @param pool     The @c ZGDatabasePool  object.
 @param database The @c ZGDatabase  object.
 
 @return @c YES if it should add database to pool; @c NO if not.
 
 */

- (BOOL)databasePool:(ZGDatabasePool*)pool shouldAddDatabaseToPool:(ZGDatabase*)database;

/** Tells the delegate that database was added to the pool.
 
 @param pool     The @c ZGDatabasePool  object.
 @param database The @c ZGDatabase  object.

 */

- (void)databasePool:(ZGDatabasePool*)pool didAddDatabase:(ZGDatabase*)database;

@end

NS_ASSUME_NONNULL_END
