//
//  GlobalClass.m
//  cocoapodSample
//
//  Created by cnc on 16/8/16.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "GlobalClass.h"

__strong static GlobalClass *singleton = nil;

@implementation GlobalClass

+ (GlobalClass *)sharedInStance
{
    static dispatch_once_t pred = 0;
    
    dispatch_once(&pred, ^{
        singleton = [[super allocWithZone:NULL] init];
    });
    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInStance];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


-(QCAdminModel *)model{

    if (!_model) {
        _model = [[QCAdminModel alloc]init];
    }
    return _model;
}

@end
