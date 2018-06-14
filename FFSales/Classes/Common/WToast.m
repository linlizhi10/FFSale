/**
 * @class WToast
 * @author Nik S Dyonin <wolf.step@gmail.com>
 * Small popup message inspired by Android Toast object
 */

#import "WToast.h"
#import <QuartzCore/QuartzCore.h>

//判断是否为ios7
#define IOS7_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

@implementation WToast

- (void)__showDuration:(float)duration {
	[UIView beginAnimations:@"show" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationDidStopSelector:@selector(__animationDidStop:__finished:__context:)];
	self.alpha = 1.0f;
	[UIView commitAnimations];
}

- (void)__hide {
	[self performSelectorOnMainThread:@selector(__hideThread) withObject:nil waitUntilDone:NO];
}

- (void)__hideThread {
	[UIView beginAnimations:@"hide" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.8f];
	[UIView setAnimationDidStopSelector:@selector(__animationDidStop:__finished:__context:)];
	self.alpha = 0.0f;
	[UIView commitAnimations];
}

- (void)__animationDidStop:(NSString *)animationID __finished:(NSNumber *)finished __context:(void *)context {
	if ([animationID isEqualToString:@"hide"]) {
		[self removeFromSuperview];
	}
	else if ([animationID isEqualToString:@"show"]) {
		[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(__hide) userInfo:nil repeats:NO];
	}
}


+ (WToast *)__createWithText:(NSString *)text forToastType:(ToastType)toastType duration:(NSInteger)duration backgroundColor:(UIColor *)color {

	UILabel *textLabel = [[UILabel alloc] init];
	textLabel.textAlignment = NSTextAlignmentCenter;
	textLabel.font = [UIFont systemFontOfSize:18];
	textLabel.textColor=[UIColor whiteColor];
	textLabel.backgroundColor = [UIColor clearColor];
	textLabel.numberOfLines = 0;
    
	textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
	label.lineBreakMode = NSLineBreakByWordWrapping;
	label.font = [UIFont boldSystemFontOfSize:18];
	label.numberOfLines = 0;
	label.opaque = NO; // 选中Opaque表示视图后面的任何内容都不应该绘制
	label.backgroundColor = [UIColor clearColor];
	label.text = text;
	CGSize constraintSize= CGSizeMake(120,MAXFLOAT);

    CGSize expectedSize = CGSizeMake(10, 10);
    if (IOS7_OR_LATER) {
        NSDictionary *attributeDicL = [NSDictionary dictionaryWithObjectsAndKeys:label.font,NSFontAttributeName, nil];
        
        expectedSize = [label.text boundingRectWithSize:constraintSize
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:attributeDicL
                                                       context:nil].size;
    }else{
        expectedSize = [label.text sizeWithFont:label.font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    }
   
    
    
	label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, expectedSize.width, expectedSize.height);
	
	
	
	
	CGRect tmpRect;

	
	tmpRect.size.width = 130;
	tmpRect.size.height = 70+label.frame.size.height;
	tmpRect.origin.x =(SCREEN_WIDTH-130)/2.0f;
	tmpRect.origin.y =(SCREEN_WIDTH-100)/2;
	
	
	WToast *toast = [[WToast alloc] initWithFrame:tmpRect];
    toast.backgroundColor = color;
	CALayer *layer = toast.layer;
	layer.masksToBounds = YES;
	layer.cornerRadius = 5.0f;
	
	textLabel.text = text;

	textLabel.frame = CGRectMake(5,55, 120,label.frame.size.height);
//	textLabel.frame =tmpRect;
	[toast addSubview:textLabel];
	
	toast.alpha = 1.0f;
	
	
	
	UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((tmpRect.size.width-32)/2, 10, 32, 32)];
	if(toastType==Success){
		[image setImage:[UIImage imageNamed:@"ok"]];
	}else if(toastType==Error){
		[image setImage:[UIImage imageNamed:@"cancel"]];
	}else if (toastType==Warning){
        [image setImage:[UIImage imageNamed:@"感叹号"]];
    }
	
	[toast addSubview:image];
	
	return toast;
}

+ (WToast *)__createWithText:(NSString *)text center:(BOOL)center{
	float screenWidth = [UIScreen mainScreen].bounds.size.width;
	float screenHeight = [UIScreen mainScreen].bounds.size.height;
	float x = 10.0f;
	float width = screenWidth - x * 2.0f;

	UILabel *textLabel = [[UILabel alloc] init];
	textLabel.textAlignment = NSTextAlignmentCenter;
	textLabel.font = [UIFont systemFontOfSize:16];
	textLabel.textColor=[UIColor whiteColor];
	textLabel.backgroundColor = [UIColor clearColor];
	textLabel.numberOfLines = 0;
	textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
//	CGSize sz = [text sizeWithFont:textLabel.font
//				 constrainedToSize:CGSizeMake(width - 60.0f, 9999.0f)
//					 lineBreakMode:textLabel.lineBreakMode];
    CGSize sz = CGSizeMake(10, 10);
    if (IOS7_OR_LATER) {
        NSDictionary *attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil];
        
        sz = [text boundingRectWithSize:CGSizeMake(width - 60.0f, 9999.0)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attributeDic
                                       context:nil].size;
  
    }else{
        sz = [text sizeWithFont:textLabel.font
                     constrainedToSize:CGSizeMake(width - 60.0f, 9999.0f)
                         lineBreakMode:textLabel.lineBreakMode];
    }
   	
	
	
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
	label.lineBreakMode = NSLineBreakByWordWrapping;
	label.font = [UIFont systemFontOfSize:16];
	label.numberOfLines = 0;
	label.opaque = NO; // 选中Opaque表示视图后面的任何内容都不应该绘制
	label.backgroundColor = [UIColor clearColor];
	label.text = text;
	CGSize constraintSize= CGSizeMake(250,MAXFLOAT);
    
//	CGSize expectedSize = [label.text sizeWithFont:label.font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    CGSize expectedSize = CGSizeMake(10, 10);
    if (IOS7_OR_LATER) {
        NSDictionary *attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:label.font,NSFontAttributeName, nil];
        expectedSize = [label.text boundingRectWithSize:constraintSize
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                        
                        
                                             attributes:attributeDic
                                                       context:nil].size;
    }else{
        expectedSize = [label.text sizeWithFont:label.font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    }
   
    
	label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, expectedSize.width, expectedSize.height);
	
	
	
	
	CGRect tmpRect;
	int tempWidth =label.frame.size.width+20;
	tmpRect.size.width = tempWidth;
	tmpRect.size.height = MAX(sz.height + 20.0f, 38.0f);
//	tmpRect.origin.x = floor((screenWidth - width) / 2.0f);
	tmpRect.origin.x =(screenWidth-tempWidth)/2.0f;
    tmpRect.origin.y = floor(screenHeight - tmpRect.size.height - 15.0f)-50;
    if (center) {
        tmpRect.origin.y = floor((screenHeight - tmpRect.size.height)/2 - 15.0f);

    }

	WToast *toast = [[WToast alloc] initWithFrame:tmpRect];
	toast.backgroundColor = RGBAColor(1, 1, 1, 0.6f);
	CALayer *layer = toast.layer;
	layer.masksToBounds = YES;
	layer.cornerRadius = 5.0f;

	textLabel.text = text;
	tmpRect.origin.x = floor((toast.frame.size.width - sz.width) / 2.0f);
	tmpRect.origin.y = floor((toast.frame.size.height - sz.height) / 2.0f);
	tmpRect.size = sz;
	textLabel.frame =tmpRect;
	[toast addSubview:textLabel];
	
	toast.alpha = 0.0f;	
	return toast;
}

+ (WToast *)__createWithImage:(UIImage *)image {
	float screenWidth = [UIScreen mainScreen].bounds.size.width;
	float screenHeight = [UIScreen mainScreen].bounds.size.height;
	float x = 10.0f;
	float width = screenWidth - x * 2.0f;

	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	CGSize sz = imageView.frame.size;

	CGRect tmpRect;
	tmpRect.size.width = width;
	tmpRect.size.height = MAX(sz.height + 20.0f, 38.0f);
	tmpRect.origin.x = floor((screenWidth - width) / 2.0f);
	tmpRect.origin.y = floor(screenHeight - tmpRect.size.height - 15.0f);

	WToast *toast = [[WToast alloc] initWithFrame:tmpRect];
	toast.backgroundColor = RGBAColor(1, 1, 1, 0.6f);
	CALayer *layer = toast.layer;
	layer.masksToBounds = YES;
	layer.cornerRadius = 5.0f;

	tmpRect.origin.x = floor((toast.frame.size.width - sz.width) / 2.0f);
	tmpRect.origin.y = floor((toast.frame.size.height - sz.height) / 2.0f);
	tmpRect.size = sz;
	imageView.frame = tmpRect;
	[toast addSubview:imageView];
	
	toast.alpha = 0.0f;
	
	return toast;
}
/**
 * Show toast with text in application window
 * @param text Text to print in toast window
 */
+ (void)showWithText:(NSString *)text forToastType:(ToastType)toastType{

	WToast *toast = [WToast __createWithText:text forToastType:toastType duration:0.2 backgroundColor:RGBAColor(1, 1, 1,0.6f)];
	
	UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
    mainWindow.windowLevel = UIWindowLevelNormal;
	[mainWindow addSubview:toast];
    [toast __showDuration:0.2];
}

+ (void)showWithText:(NSString *)text forToastType:(ToastType)toastType duration:(float)duration backgroundColor:(UIColor *)color
{
    WToast *toast = [WToast __createWithText:text forToastType:toastType duration:duration backgroundColor:color];
    UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
    mainWindow.windowLevel = UIWindowLevelNormal;
    [mainWindow addSubview:toast];
    [toast __showDuration:duration];

}

/**
 * Show toast with text in application window
 * @param text Text to print in toast window
 */
+ (void)showWithTextCenter:(NSString *)text{
    WToast *toast = [WToast __createWithText:text center:YES];
    
    UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
    mainWindow.windowLevel = UIWindowLevelNormal;
    [mainWindow addSubview:toast];
    //    //UIView *_v = [v retain];
    //    [v addSubview:toast];
    //    [toast release];
    
    [toast __showDuration:0.2f];
}

/**
 * Show toast with text in application window
 * @param text Text to print in toast window
 */
+ (void)showWithText:(NSString *)text{
	WToast *toast = [WToast __createWithText:text center:NO];

	UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
     mainWindow.windowLevel = UIWindowLevelNormal;
	[mainWindow addSubview:toast];
//	//UIView *_v = [v retain];
//	[v addSubview:toast];
//	[toast release];

	[toast __showDuration:0.2f];
}

/**
 * Show toast with image in application window
 * @param image Image to show in toast window
 */
+ (void)showWithImage:(UIImage *)image {
	WToast *toast = [WToast __createWithImage:image];
	
	UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
     mainWindow.windowLevel = UIWindowLevelNormal;
	[mainWindow addSubview:toast];
	
	[toast __showDuration:0.2f];
}

@end
