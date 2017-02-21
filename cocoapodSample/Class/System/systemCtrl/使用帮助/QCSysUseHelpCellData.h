//
//  QCSysUseHelpCellData.h
//  cocoapodSample
//
//  Created by cnc on 16/9/6.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCSysUseHelpCellData : NSObject
+ (QCSysUseHelpCellData *)shareInstance;
- (NSMutableArray *)cellDataWithStrng;
@end
