
#import "DDCommonNaviVC.h"

@interface GestureVerifyViewController : DDCommonNaviVC
- (instancetype)initIsToSetNewGesture:(BOOL)isToSetNewGesture;
- (instancetype)initIsToSetNewGesture:(BOOL)isToSetNewGesture needCountLimit:(BOOL)countLimit;
@property (nonatomic, assign) BOOL isToSetNewGesture;

@end
