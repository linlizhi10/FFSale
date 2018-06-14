
#import "PCCircleViewConst.h"
#import "DataManager.h"
#import "FIUser.h"
@implementation PCCircleViewConst

+ (void)saveGesture:(NSString *)gesture Key:(NSString *)key
{
    if ([key isEqualToString:gestureOneSaveKey]) {
        [[NSUserDefaults standardUserDefaults] setObject:gesture forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else if ([key isEqualToString:gestureFinalSaveKey]){
        DataManager *dataM = [DataManager shareDataManager];
        NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"phone"];

        [dataM updateGesture:gesture userId:uid];
    }
//    DataManager *dataM = [DataManager shareDataManager];
//    [dataM updateGesture:gesture userId:[FIUser shareUser].uid];
}

+ (NSString *)getGestureWithKey:(NSString *)key
{
    
    if ([key isEqualToString:gestureOneSaveKey]) {
       return [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }else if ([key isEqualToString:gestureFinalSaveKey]){
        DataManager *dataM = [DataManager shareDataManager];
        NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"phone"];

        NSString *str = [dataM fetchGestureByUserId:uid].gestureWord;
        if ([str isEqualToString:@"(null)"]) {
            str = @"";
        }else if ([str isEqualToString:@"nil"]){
            str = @"";
        }else if(!str){
            str = @"";
        }
        return str;
    }
    return @"";
}
+ (BOOL)getGestureStatus{
    DataManager *dataM = [DataManager shareDataManager];
    NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"phone"];

    return [dataM fetchGestureByUserId:uid].gestureOn;
}
+ (BOOL)getGestureCloseFlag{
    DataManager *dataM = [DataManager shareDataManager];
    NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"phone"];

    return [dataM fetchGestureByUserId:uid].closeBySelf;
}
+ (UIColor *)getCircleConnectLineNormalColor{
   
    if ([self getTrackOn]) {
        return CircleConnectLineNormalColor;
    }else{
        return  [UIColor clearColor];
    }
}

+ (UIColor *)getCircleStateSelectedInsideColorType:(CircleType)type{
    if ([self getTrackOn]) {
        return CircleStateSelectedInsideColor;
    }else{
        if (type == CircleTypeInfo) {
            return CricleStateNormalInsideColorInfo;
        }
        return CircleStateNormalInsideColor;
    }
}
+ (UIColor *)getCircleStateSelectedOutsideColor{
    if ([self getTrackOn]) {
        return CircleStateSelectedOutsideColor;
    }else{
        return CircleStateNormalOutsideColor;
    }
}
+ (UIColor *)getCircleStateSelectedTrangleColor{
    if ([self getTrackOn]) {
        return CircleStateSelectedTrangleColor;
    }else{
        return [UIColor clearColor];
    }
}
+ (BOOL)getTrackOn{
    DataManager *dataM = [DataManager shareDataManager];
    NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"phone"];

    UserGesture *gesture = [dataM fetchGestureByUserId:uid];
    return gesture.trackOn;
}
@end
