//
//  QCPileModel.h
//  cocoapodSample
//
//  Created by cnc on 16/8/23.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCPileModel : NSObject
@property (nonatomic,strong) NSString *image;
@property (nonatomic,copy) NSString *cpid;
@property (nonatomic,copy) NSString *cpnm;

@property (nonatomic,copy) NSString *commstate;
@property (nonatomic,strong) NSString *timeserial;
@property (nonatomic,assign) float priceid;
@property (nonatomic,assign) int currstate;
@end
