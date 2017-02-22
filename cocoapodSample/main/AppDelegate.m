//
//  AppDelegate.m
//  cocoapodSample
//
//  Created by cnc on 16/8/5.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "AppDelegate.h"
#import "QCLoginCtrl.h"
#import "QCTabBarController.h"
#import "WZGuideViewController.h"
@interface AppDelegate ()
@property (nonatomic,strong) UILabel *label;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
//    self.window.rootViewController = [[QCTabBarController alloc]init];
    
    self.window.rootViewController = [[QCLoginCtrl alloc] init];
    [self.window makeKeyAndVisible];
    
    
    //隐藏状态栏
//    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    
    //样式白色
//    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //设置系统导航栏
    [self setupSystem];
    
//  判断APP是否是第一次运行
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];//标记APP已经运行过
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];//标记此次是第一次运行
    }
    
    //设置启动页 launchimage 停留时间
    [NSThread sleepForTimeInterval:1];
    
    //======rootviewEnd=====
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        [ WZGuideViewController show];
    }
    //----------------引导页结束-------------

    
        
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];//注册本地推送
    
    return YES;
}

//通知回调
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    
    NSLog(@"%@",notification.alertBody);
    
    NSString *index = [notification.alertBody substringWithRange:NSMakeRange(6, 1)];
    
    if ([index  isEqual: @"-"]) {
        return;
    }
    
    UILabel*label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, -60, [UIScreen mainScreen].bounds.size.width, 60);
    label.layer.cornerRadius = 10;
    label.backgroundColor = [UIColor blackColor];
    label.text = notification.alertBody;
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    
    self.label = label;
    
    [self appearView];
    [self.window addSubview:self.label];
}

//顶部弹窗动画
-(void)appearView{
    
    [UIView animateWithDuration:1 animations:^{
        self.label.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60);
    } completion:^(BOOL finished) {}];
    [self returnNotificationLabel];
}
//顶部弹窗消失
-(void)returnNotificationLabel{
    
    [UIView animateWithDuration:1 delay:2 options:0 animations:^{
        self.label.frame = CGRectMake(0, -60, [UIScreen mainScreen].bounds.size.width, 60);
    } completion:^(BOOL finished) {
    }];
}




//设置系统导航栏
- (void) setupSystem
{
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //    导航栏肤色
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHex:0x299dff]];
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithHex:0x15A230]]; // selected color
    
//    [[UITabBar appearance] setTintColor:XYCOLOR(0, 0, 0, 1)];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x15A230]} forState:UIControlStateSelected];
//    [[UITabBar appearance] setBarTintColor:[UIColor colorWithHex:0xE1E1E1]];
    [[UITabBar appearance] setBarTintColor:XYCOLOR(255, 255, 255, 1)];
}


-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
