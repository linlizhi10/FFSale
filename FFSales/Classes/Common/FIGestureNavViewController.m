//
//  FIGestureNavViewController.m
//  finance
//
//  Created by lin on 17/7/15.
//  Copyright © 2017年 李传政. All rights reserved.
//

#import "FIGestureNavViewController.h"

@interface FIGestureNavViewController ()

@end

@implementation FIGestureNavViewController
- (id)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self.navigationBar setBarTintColor:[UIColor whiteColor]];
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor darkTextColor],NSFontAttributeName:Font(18)};
    }
    return self;
}
- (id)init{
    self = [super init];
    if (self) {
        [self.navigationBar setBarTintColor:[UIColor whiteColor]];
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor darkTextColor],NSFontAttributeName:Font(18)};
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
