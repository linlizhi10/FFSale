//
//  DataManager.h
//  CRM
//
//  Created by lin on 16/8/18.
//  Copyright © 2016年 CRM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserGesture : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *gestureWord;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, assign) int count;
@property (nonatomic, assign) long timeStamp;
@property (nonatomic, assign) long lastDay;
@property (nonatomic, assign) BOOL gestureOn;
@property (nonatomic, assign) BOOL trackOn;
@property (nonatomic, assign) BOOL fastLogin;
@property (nonatomic, assign) BOOL closeBySelf;
@end

@interface DataManager : NSObject
+ (instancetype)shareDataManager;

- (void)insertObject:(UserGesture *)searchObj;
- (void)deleteUser:(NSString *)userId;
- (void)updateObject:(UserGesture *)searchObj;
//更新除手势外的数据
- (void)updateBaseInfo:(UserGesture *)gesture;
- (void)updatePhone:(NSString *)phone userId:(NSString *)userId;
//更新手势可输入次数
- (void)updateCount:(int)count userId:(NSString *)userId;
//更新手势
- (void)updateGesture:(NSString *)gestureWord userId:(NSString *)userId;
- (void)updateGestureOn:(BOOL)gestureOn closeFlag:(BOOL)closeFlag userId:(NSString *)userId;
- (void)updateTrackOn:(BOOL)trackOn userId:(NSString *)userId;
//清除手势相关
- (void)cleanGestureUserId:(NSString *)userId;
- (void)cleanGestureWithCloseUserId:(NSString *)userId;

- (NSArray *)fetchAllSearchResult;
//- (UserGesture *)fetchUserInfoByPhone:(NSString *)phone;
- (UserGesture *)fetchUserInfoByUserId:(NSString *)userId;
- (UserGesture *)fetchGestureByUserId:(NSString *)userId;
- (void)createTable;
- (void)dropTable;

@end
