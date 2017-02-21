//
//  SPClearCacheTool.h
//  SPClearCacheTool
//
//  Created by leshengping on 16/9/20.
//  Copyright © 2016年 leshengping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPClearCacheTool : NSObject
/**
 *  获取缓存大小
 */
+ (NSString *)getCacheSize;


/**
 *  清理缓存
 */
+ (BOOL)clearCaches;

@end
