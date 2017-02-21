//
//  QCHomeHeadView.h
//  cocoapodSample
//
//  Created by cnc on 16/8/31.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCHomeHeadView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *headImg;

@property (strong, nonatomic) IBOutlet UILabel *name;

@property (strong, nonatomic) IBOutlet UILabel *TMLabel;
@property (strong, nonatomic) IBOutlet UILabel *TQLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalML;
@property (strong, nonatomic) IBOutlet UILabel *totalQL;

@property (strong, nonatomic) IBOutlet UIButton *pushBtn;
@end
