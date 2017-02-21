//
//  GlobalClass.h
//  cocoapodSample
//
//  Created by cnc on 16/8/16.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCAdminModel.h"
@interface GlobalClass : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) UIImage *Image;
@property (nonatomic,strong) NSString *gender;
@property (nonatomic,strong) QCAdminModel *model;


+ (GlobalClass *)sharedInStance;



#pragma mark -----areaTitle

@property (nonatomic,strong) NSString *AreaTitle;
@end
