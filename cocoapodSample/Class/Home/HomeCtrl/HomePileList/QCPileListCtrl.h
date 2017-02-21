//
//  QCPileListCtrl.h
//  cocoapodSample
//
//  Created by cnc on 16/8/17.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCPileListCtrl : UIViewController
@property (nonatomic,strong) UIBarButtonItem *leftBarButton;
@property (nonatomic,assign) BOOL fromHome;
@property (nonatomic,assign) BOOL isfromHome;
@property (nonatomic,assign) NSInteger commstate;
@property (nonatomic,strong) UIBarButtonItem *searchBar;
@end
