//
//  QCTabBarController.m
//  chargePileManage
//
//  Created by YuMing on 16/5/19.
//  Copyright © 2016年 shQianChen. All rights reserved.
//

#import "QCTabBarController.h"
#import "QCTableBar.h"

#import "XYNaviGationController.h"
#import "QCPileListCtrl.h"
#import "QCHistoryRecord.h"
#import "QCSysManageCtrl.h"
#import "QCSystemManager.h"

@interface QCTabBarController () <QCTableBarDelegate>
/**
 *  自定义tabbar，这样才能够调用tabbar属性
 */
@property (nonatomic,weak) QCTableBar *custtomTabbar;

@end

@implementation QCTabBarController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    // 添加tabbar
    [self setupTabbar];
    // 添加子控制器

    [self setupAllChildViewControllers];
}
/**
 *  把tabBar中原先的Button移除
 *
 *  @param animated None
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    NSLog(@"WQLog——+——+——+——+——+%@",self.tabBar.subviews);
    for (UIView *child in self.tabBar.subviews) {
        // 如果子控件是按钮控件
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
        
    }
    
}
#pragma mark - UITableViewDateSource

#pragma mark - UITableViewDelegate

#pragma mark - CustomDelegate
/**
 *  监听tabBar按钮的改变
 *
 *  @param tabBar tabBar
 *  @param from   原来选中的位置
 *  @param to     最橷选中的位置
 */
- (void)tabBar:(QCTableBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to {
    self.selectedIndex = to;
    if (from == to) {
        return;
    }

    [self setHidesBottomBarWhenPushed:YES];
    CATransition *animation =[CATransition animation];
    [animation setDuration:0.35f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setType:kCATransitionMoveIn];
    [animation setSubtype:kCATransitionReveal];
    [self.view.layer addAnimation:animation forKey:@"reveal"];
}
#pragma mark - event response

#pragma mark - private methods
/**
 *  设置tabbar
 */

- (void)setupTabbar
{
    QCTableBar *custtomTabbar = [[QCTableBar alloc]init];
    
    custtomTabbar.delegate = self;              // 控制器成为tabbar的代理
    
    custtomTabbar.frame = self.tabBar.bounds;   // 设置自定义tabBar大小与tabBarViewController内部的tabBar大小相同
    
    [self.tabBar addSubview:custtomTabbar];
    
    self.custtomTabbar = custtomTabbar;         // 创建好tabbar后，赋给属性值
}

- (void) setupAllChildViewControllers
{
    // 1.统计
    
    QCHistoryRecord *message = [[QCHistoryRecord alloc]init];
    message.tabBarItem.badgeValue = @"10";
    [self setupChildViewController:message title:@"首页" imageName:@"historyRecord" selectedImageName:@"select_HisRecord"];
    
    // 2.列表
    QCSystemManager *home = [[QCSystemManager alloc]init];
    home.tabBarItem.badgeValue = @"10";
    [self setupChildViewController:home title:@"查询" imageName:@"pile_list" selectedImageName:@"pile_select_list"];
    
    
    // 3.系统管理
    QCSysManageCtrl *me = [[QCSysManageCtrl alloc]init];
    me.tabBarItem.badgeValue = @"10";
    [self setupChildViewController:me title:@"系统管理" imageName:@"sys_manager" selectedImageName:@"select_sysManage"];
    
}
/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void) setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 1.设置控制器属性
    childVc.title = title;   // 同时设置了tabBarController和NavigationController的title属性
    
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    if (IS_IOS_7) {   // iOS7会开启渲染，这里是告诉控制器不要进行图片的渲染
        childVc.tabBarItem.selectedImage = [[UIImage imageNamed: selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    }
    // 2.包装一个导航控制器
    XYNaviGationController *nav = [[XYNaviGationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
    // 3.添加一个tabbar的内部按钮
    [self.custtomTabbar addTabBarButtonWithItem:childVc.tabBarItem];
    
}
#pragma mark - getters and setters
@end
