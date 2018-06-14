//
//  DataManager.m
//  CRM
//
//  Created by lin on 16/8/18.
//  Copyright © 2016年 CRM. All rights reserved.
//

#import "DataManager.h"
#import <FMDB.h>
@implementation UserGesture
@end
@interface DataManager()
@property (nonatomic, strong) FMDatabase *db;
@end
@implementation DataManager
+ (instancetype)shareDataManager
{
    static DataManager *dbM = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        dbM = [[DataManager alloc] init];
    });
    return dbM;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dbPath = [NSString stringWithFormat:@"%@/%@",path,@"order.sqlite"];
        NSLog(@"path is ----- %@",dbPath);
        _db = [[FMDatabase alloc] initWithPath:dbPath];
        BOOL rec = [_db open];
        if (rec) {
            
        }else{
            NSLog(@"error is %@",[_db lastErrorMessage]);
        }
    }
    return self;
}
- (void)createTable
{
    /*
     @property (nonatomic, copy) NSString *userId;
     @property (nonatomic, copy) NSString *gestureWord;
     @property (nonatomic, copy) NSString *phone;
     @property (nonatomic, assign) long timeStamp;
     */
    NSString *createOrderTable = @"create table if not exists UserInfo(id integer primary key autoincrement,gestureWord varchar(40),userId varchar(20),phone varchar(20),timeStamp integer,count integer,lastDay interger,gestureOn bool,trackOn bool,fastLogin bool,attribute1 bool);";
    BOOL rec = [_db executeUpdate:createOrderTable];
    if (rec == NO) {
        NSLog(@"error is %@",[_db lastErrorMessage]);
    }

}

- (void)insertObject:(UserGesture *)searchObj{
    NSString *insertStr = [NSString stringWithFormat:@"insert into UserInfo(gestureWord,userId,phone,timeStamp,count,lastDay,gestureOn,trackOn,fastLogin,attribute1) values('%@','%@','%@','%ld','%d','%ld','%d','%d','%d','%d');",searchObj.gestureWord,searchObj.userId,searchObj.phone,searchObj.timeStamp,searchObj.count,searchObj.lastDay,searchObj.gestureOn,searchObj.trackOn,searchObj.fastLogin,searchObj.closeBySelf];
    BOOL rec = [_db executeUpdate:insertStr];
    if (rec == NO) {
        NSLog(@"error is %@",[_db lastErrorMessage]);
    }
}
- (void)deleteUser:(NSString *)userId{
    NSString *insertStr = [NSString stringWithFormat:@"delete from UserInfo where userId=%@;",userId];
    BOOL rec = [_db executeUpdate:insertStr];
    if (rec == NO) {
        NSLog(@"error is %@",[_db lastErrorMessage]);
    }

}
- (void)updateObject:(UserGesture *)searchObj{
    NSString *updateStr = [NSString stringWithFormat:@"update UserInfo set gestureWord=%@,phone=%@,timeStamp=%ld,count=%d,lastDay=%ld where userId=%@;",searchObj.gestureWord,searchObj.phone,searchObj.timeStamp,searchObj.count,searchObj.lastDay,searchObj.userId];
    
    BOOL rec = [_db executeUpdate:updateStr];
    if (!rec) {
        NSLog(@"error is %@",[_db lastErrorMessage]);
    }
}

- (void)updateBaseInfo:(UserGesture *)gesture{
    NSString *updateStr = [NSString stringWithFormat:@"update UserInfo set phone=%@,timeStamp=%ld,fastLogin=%d where userId=%@;",gesture.phone,gesture.timeStamp,gesture.fastLogin,gesture.userId];
    
    BOOL rec = [_db executeUpdate:updateStr];
    if (!rec) {
        NSLog(@"error is %@",[_db lastErrorMessage]);
    }
}
- (void)updatePhone:(NSString *)phone userId:(NSString *)userId{
    NSString *updateStr = [NSString stringWithFormat:@"update UserInfo set phone=%@ where userId=%@;",phone,userId];
    
    BOOL rec = [_db executeUpdate:updateStr];
    if (!rec) {
        NSLog(@"error is %@",[_db lastErrorMessage]);
    }
}
- (void)updateGesture:(NSString *)gestureWord userId:(NSString *)userId{
    NSString *updateStr = [NSString stringWithFormat:@"update UserInfo set gestureWord=%@ where userId=%@;",gestureWord,userId];
    BOOL rec = [_db executeUpdate:updateStr];
    if (!rec) {
        NSLog(@"error is %@",[_db lastErrorMessage]);
    }
}
- (void)updateCount:(int)count userId:(NSString *)userId{
    NSString *updateStr = [NSString stringWithFormat:@"update UserInfo set count=%d where userId=%@;",count,userId];
    BOOL rec = [_db executeUpdate:updateStr];
    if (!rec) {
        NSLog(@"error is %@",[_db lastErrorMessage]);
    }
}
- (void)updateGestureOn:(BOOL)gestureOn closeFlag:(BOOL)closeFlag userId:(NSString *)userId{
    NSString *updateStr = [NSString stringWithFormat:@"update UserInfo set gestureOn=%d ,attribute1='%d' where userId=%@;",gestureOn,closeFlag,userId];
    BOOL rec = [_db executeUpdate:updateStr];
    if (!rec) {
        NSLog(@"error is %@",[_db lastErrorMessage]);
    }
}
- (void)updateTrackOn:(BOOL)trackOn userId:(NSString *)userId{
    NSString *updateStr = [NSString stringWithFormat:@"update UserInfo set trackOn=%d where userId=%@;",trackOn,userId];
    BOOL rec = [_db executeUpdate:updateStr];
    if (!rec) {
        NSLog(@"error is %@",[_db lastErrorMessage]);
    }
}
- (void)cleanGestureUserId:(NSString *)userId{
    NSString *updateStr = [NSString stringWithFormat:@"update UserInfo set gestureWord='',gestureOn='0',trackOn='1',count=5 where userId=%@;",userId];
    BOOL rec = [_db executeUpdate:updateStr];
    if (!rec) {
        NSLog(@"error is %@",[_db lastErrorMessage]);
    }
}

- (void)cleanGestureWithCloseUserId:(NSString *)userId{
    NSString *updateStr = [NSString stringWithFormat:@"update UserInfo set gestureWord='',gestureOn=0,trackOn='1',count=5 where userId=%@;",userId];
    BOOL rec = [_db executeUpdate:updateStr];
    if (!rec) {
        NSLog(@"error is %@",[_db lastErrorMessage]);
    }
}

- (NSArray *)fetchAllSearchResult
{
    NSString *fetchS = [NSString stringWithFormat:@"select * from UserInfo where fastLogin='0' order by timeStamp desc limit 5;"];
    return [self fetchObj:fetchS];
}
//- (UserGesture *)fetchUserInfoByPhone:(NSString *)phone
//{
//    NSString *fetchS = [NSString stringWithFormat:@"select * from UserInfo where phone=%@;",phone];
//    if ([self fetchObj:fetchS].count > 0) {
//        return [self fetchObj:fetchS][0];
//    }else{
//        return nil;
//    }
//    
//}

- (UserGesture *)fetchUserInfoByUserId:(NSString *)userId
{
    NSString *fetchS = [NSString stringWithFormat:@"select * from UserInfo where userId=%@;",userId];
    if ([self fetchObj:fetchS].count > 0) {
        return [self fetchObj:fetchS][0];
    }else{
        return nil;
    }
    
}
- (UserGesture *)fetchGestureByUserId:(NSString *)userId{
    NSString *fetchS = [NSString stringWithFormat:@"select * from UserInfo where userId=%@;",userId];
    FMResultSet *set = [_db executeQuery:fetchS];
    while ([set next]) {
        UserGesture *gesture = [[UserGesture alloc] init];
        NSString *gestureWord = [set stringForColumn:@"gestureWord"];
        BOOL gestureOn = [set boolForColumn:@"gestureOn"];
        BOOL trackOn = [set boolForColumn:@"trackOn"];
        int count = [set intForColumn:@"count"];
        BOOL closeBySelf = [set boolForColumn:@"attribute1"];
        if ([gestureWord isEqualToString:@"(null)"]) {
            gestureWord = @"";
        }
        gesture.gestureWord = gestureWord;
        gesture.gestureOn = gestureOn;
        gesture.trackOn = trackOn;
        gesture.count = count;
        gesture.closeBySelf = closeBySelf;
        return gesture;
    }
    return nil;
}
- (NSArray *)fetchObj:(NSString *)fetchStr
{
    NSMutableArray *arrm = [[NSMutableArray alloc] init];
    FMResultSet *set = [_db executeQuery:fetchStr];
    while ([set next]) {
        NSString *gestureWord = [set stringForColumn:@"gestureWord"];
        NSString *userId = [set stringForColumn:@"userId"];
        NSString *phone = [set stringForColumn:@"phone"];
        NSInteger timeStamp = [set longForColumn:@"timeStamp"];
        int count = [set intForColumn:@"count"];
        NSInteger lastDay = [set longForColumn:@"lastDay"];
        BOOL closeBySelf = [set boolForColumn:@"attribute1"];
        UserGesture *obj = [[UserGesture alloc] init];
        obj.gestureWord = gestureWord;
        obj.userId = userId;
        obj.phone = phone;
        obj.timeStamp = timeStamp;
        obj.count = count;
        obj.lastDay = lastDay;
        obj.closeBySelf = closeBySelf;
        [arrm addObject:obj];
    }
    return arrm;
}

- (void)dropTable
{
    NSString *dropTableN = @"drop table UserInfo";
    [_db executeUpdate:dropTableN];
}

@end
