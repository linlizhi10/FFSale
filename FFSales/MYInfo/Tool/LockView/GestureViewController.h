
#import "DDCommonNaviVC.h"

typedef enum{
    GestureViewControllerTypeSetting = 1,
    GestureViewControllerTypeLogin
}GestureViewControllerType;

typedef enum{
    buttonTagReset = 1,
    buttonTagManager,
    buttonTagForget
    
}buttonTag;

@interface GestureViewController : DDCommonNaviVC
@property (copy,nonatomic) void(^ finishBlock)(void);
- (instancetype)initWithRegister:(int)fromTag;
/**
 *  控制器来源类型
 */
@property (nonatomic, assign) GestureViewControllerType type;

@end
