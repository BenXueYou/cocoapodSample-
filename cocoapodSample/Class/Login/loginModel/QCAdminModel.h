//
//  QCAdminModel.h
//  cocoapodSample
//
//  Created by cnc on 16/8/18.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCAdminModel : NSObject
@property (nonatomic,copy) NSString *userID;
@property (nonatomic,copy) NSString *passWord;
@property (nonatomic,strong) UIImage *icon;
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,copy) NSString *sex;
@property (nonatomic,copy) NSString *permission;
@property (nonatomic,copy) NSString *area;
@end
