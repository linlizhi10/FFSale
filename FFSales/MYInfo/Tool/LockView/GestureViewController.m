
#import "GestureViewController.h"
#import "PCCircleView.h"
#import "PCCircleViewConst.h"
#import "PCLockLabel.h"
#import "PCCircleInfoView.h"
#import "PCCircle.h"
#import "DDLoginVC.h"
#import "MainTab.h"
#import "FIUser.h"
#import "DataManager.h"
#import "FFGestureData.h"
#import <UINavigationController+FDFullscreenPopGesture.h>
#import "FFSetVC.h"

@interface GestureViewController ()<UINavigationControllerDelegate, CircleViewDelegate>

/**
 *  提示Label
 */
@property (nonatomic, strong) PCLockLabel *msgLabel;

/**
 *  解锁界面
 */
@property (nonatomic, strong) PCCircleView *lockView;

/**
 *  infoView
 */
@property (nonatomic, strong) PCCircleInfoView *infoView;

@property (nonatomic, assign) int fromTag; //0 设置， 1 注册， 2 开起
@end

@implementation GestureViewController
- (instancetype)initWithRegister:(int)fromTag{
    self = [super init];
    if (self) {
        _fromTag = fromTag;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.fd_interactivePopDisabled = YES;
    // 进来先清空存的第一个密码
    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.fd_interactivePopDisabled = NO;

    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view setBackgroundColor:[UIColor whiteColor]];

    self.navigationController.delegate = self;

    if (_fromTag == YES) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"跳过" style:UIBarButtonItemStylePlain target:self action:@selector(ignoreAction)];
        self.navigationItem.rightBarButtonItem.tintColor = RGBCOLORV(0x333333);
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem = nil;
    }
    // 1.界面相同部分生成器
    [self setupSameUI];
    
    // 2.界面不同部分生成器
    [self setupDifferentUI];
}

#pragma mark - 界面不同部分生成器
- (void)setupDifferentUI
{
    switch (self.type) {
        case GestureViewControllerTypeSetting:
            self.title = @"设置手势密码";
            [self setupSubViewsSettingVc];
            break;
        case GestureViewControllerTypeLogin:
            [self setupSubViewsLoginVc];
            break;
        default:
            break;
    }
}

#pragma mark - 界面相同部分生成器
- (void)setupSameUI
{
    // 解锁界面
    PCCircleView *lockView = [[PCCircleView alloc] init];
    lockView.delegate = self;
    self.lockView = lockView;
    [self.view addSubview:lockView];
    
    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(0, 0, kScreenW, 14);
    msgLabel.center = CGPointMake(kScreenW/2, CGRectGetMinY(lockView.frame) - 30);
    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];
}

#pragma mark - 设置手势密码界面
- (void)setupSubViewsSettingVc
{
    [self.lockView setType:CircleViewTypeSetting];
    
    self.title = @"设置手势密码";
    
    [self.msgLabel showNormalMsg:gestureTextBeforeSet];
    
    PCCircleInfoView *infoView = [[PCCircleInfoView alloc] init];
    infoView.frame = CGRectMake(0, 0, CircleRadius * 2 * 0.6, CircleRadius * 2 * 0.6);
    infoView.center = CGPointMake(kScreenW/2, CGRectGetMinY(self.msgLabel.frame) - CGRectGetHeight(infoView.frame)/2 - 10);
    self.infoView = infoView;
    [self.view addSubview:infoView];
}

#pragma mark - 登陆手势密码界面
- (void)setupSubViewsLoginVc
{
    [self.lockView setType:CircleViewTypeLogin];
    
    // 头像
    UIImageView  *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, 65, 65);
    imageView.center = CGPointMake(kScreenW/2, kScreenH/5);
    [imageView setImage:[UIImage imageNamed:@"head"]];
    [self.view addSubview:imageView];
    
    // 管理手势密码
    UIButton *leftBtn = [UIButton new];
    [self creatButton:leftBtn frame:CGRectMake(CircleViewEdgeMargin + 20, kScreenH - 60, kScreenW/2, 20) title:@"管理手势密码" alignment:UIControlContentHorizontalAlignmentLeft tag:buttonTagManager];
    
    // 登录其他账户
    UIButton *rightBtn = [UIButton new];
    [self creatButton:rightBtn frame:CGRectMake(kScreenW/2 - CircleViewEdgeMargin - 20, kScreenH - 60, kScreenW/2, 20) title:@"登陆其他账户" alignment:UIControlContentHorizontalAlignmentRight tag:buttonTagForget];
}

#pragma mark - 创建UIButton
- (void)creatButton:(UIButton *)btn frame:(CGRect)frame title:(NSString *)title alignment:(UIControlContentHorizontalAlignment)alignment tag:(NSInteger)tag
{
    btn.frame = frame;
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setContentHorizontalAlignment:alignment];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)ignoreAction{
    
    NSLog(@"跳过");
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    if (self.finishBlock) {
        self.finishBlock();
    }
#pragma mark -  8-7 跳过后不提醒
    NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"phone"];
    [[DataManager shareDataManager] updateGestureOn:NO closeFlag:YES userId:uid];
    
    NSInteger selectIndex = [MainTab shareInstance].selectedIndex;
    UINavigationController *nav = [MainTab shareInstance].viewControllers[selectIndex];
    [nav popToRootViewControllerAnimated:YES];
    [MainTab shareInstance].selectedIndex = 0;


}
- (void)didClickRightItem {
    NSLog(@"点击了重设按钮");
    // 1.隐藏按钮
    self.navigationItem.rightBarButtonItem.title = nil;
    if (_fromTag == YES) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"跳过" style:UIBarButtonItemStylePlain target:self action:@selector(ignoreAction)];
        self.navigationItem.rightBarButtonItem.tintColor = RGBCOLORV(0x333333);
    }
    // 2.infoView取消选中
    [self infoViewDeselectedSubviews];

    // 3.msgLabel提示文字复位
    [self.msgLabel showNormalMsg:gestureTextBeforeSet];

    // 4.清除之前存储的密码
    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
}

#pragma mark - button点击事件
- (void)didClickBtn:(UIButton *)sender
{
    NSLog(@"%ld", (long)sender.tag);
    switch (sender.tag) {
        case buttonTagManager:
        {
            NSLog(@"点击了管理手势密码按钮");
            
        }
            break;
        case buttonTagForget:
            NSLog(@"点击了登录其他账户按钮");
            
            break;
        default:
            break;
    }
}

#pragma mark - circleView - delegate
#pragma mark - circleView - delegate - setting
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type connectCirclesLessThanNeedWithGesture:(NSString *)gesture
{
    NSString *gestureOne = [PCCircleViewConst getGestureWithKey:gestureOneSaveKey];

    // 看是否存在第一个密码
    if ([gestureOne length]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重设" style:UIBarButtonItemStylePlain target:self action:@selector(didClickRightItem)];
        self.navigationItem.rightBarButtonItem.tintColor = RGBCOLORV(0x333333);
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    } else {
        NSLog(@"密码长度不合法%@", gesture);
        [self.msgLabel showWarnMsgAndShake:gestureTextConnectLess];
    }
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetFirstGesture:(NSString *)gesture
{
    NSLog(@"获得第一个手势密码%@", gesture);
    [self.msgLabel showNormalMsg:gestureTextDrawAgain];
    
    // infoView展示对应选中的圆
    [self infoViewSelectedSubviewsSameAsCircleView:view];
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal
{
    NSLog(@"获得第二个手势密码%@",gesture);
    
    if (equal) {
        [WToast showWithTextCenter:@"设置成功"];
        NSLog(@"两次手势匹配！可以进行本地化保存了");
        
        [self.msgLabel showNormalMsg:gestureTextSetSuccess];
        [PCCircleViewConst saveGesture:gesture Key:gestureFinalSaveKey];
        //set open status
        [FFGestureData insertGestureState:@"open" key:GestureStateString];
        //reset count
        [FFGestureData updateCount:5 key:GestureCounteString];
        if (_fromTag == 1) {
            //注册跳转
            [self presentViewController:[MainTab shareInstance] animated:NO completion:nil];

        }else if (_fromTag == 2){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setSuccess" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
//            [self.navigationController popToRootViewControllerAnimated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setSuccess" object:nil];
            
            BOOL has = NO;
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[FFSetVC class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                    has = YES;
                }
            }
            if (has == NO) {
                [self.navigationController popToRootViewControllerAnimated:YES];

            }
        }
    } else {
        NSLog(@"两次手势不匹配！");
        
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重设" style:UIBarButtonItemStylePlain target:self action:@selector(didClickRightItem)];
        self.navigationItem.rightBarButtonItem.tintColor = RGBCOLORV(0x333333);

    }
}

#pragma mark - circleView - delegate - login or verify gesture
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal
{
    // 此时的type有两种情况 Login or verify
    if (type == CircleViewTypeLogin) {
        
        if (equal) {
            NSLog(@"登陆成功！");
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            NSLog(@"密码错误！");
            [self.msgLabel showWarnMsgAndShake:gestureTextGestureVerifyError];
        }
    } else if (type == CircleViewTypeVerify) {
        
        if (equal) {
            NSLog(@"验证成功，跳转到设置手势界面");
            
        } else {
            NSLog(@"原手势密码输入错误！");
            
        }
    }
}

#pragma mark - infoView展示方法
#pragma mark - 让infoView对应按钮选中
- (void)infoViewSelectedSubviewsSameAsCircleView:(PCCircleView *)circleView {
    for (PCCircle *circle in circleView.subviews) {
        
        if (circle.state == CircleStateSelected || circle.state == CircleStateLastOneSelected) {
            
            for (PCCircle *infoCircle in self.infoView.subviews) {
                if (infoCircle.tag == circle.tag) {
                    [infoCircle setState:CircleStateSelected];
                }
            }
        }
    }
}

#pragma mark - 让infoView对应按钮取消选中

- (void)infoViewDeselectedSubviews {
    [self.infoView.subviews enumerateObjectsUsingBlock:^(PCCircle *obj, NSUInteger idx, BOOL *stop) {
        [obj setState:CircleStateNormal];
    }];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

    BOOL isLoginType = [viewController isKindOfClass:[self class]];

    if (self.type == GestureViewControllerTypeLogin) {
        [self.navigationController setNavigationBarHidden:isLoginType animated:YES];
    }
}


@end
