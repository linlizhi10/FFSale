/**
 * @class WToast
 */


typedef enum{
	//以下是枚举成员
    Success = 0,//操作成功
    Error = 1,//操作失败
    Warning = 2//警告操作
}ToastType;

@interface WToast : UIView

/**
 *  提示在中间
 *
 *  @param text      text description
 *  @param toastType 不同的提示类型
 */
+ (void)showWithText:(NSString *)text forToastType:(ToastType)toastType;

+ (void)showWithTextCenter:(NSString *)text;

/**
 *  提示框在下部
 *
 */
+ (void)showWithText:(NSString *)text;

+ (void)showWithImage:(UIImage *)image;

+ (void)showWithText:(NSString *)text forToastType:(ToastType)toastType duration:(float)duration backgroundColor:(UIColor *)color;

@end
