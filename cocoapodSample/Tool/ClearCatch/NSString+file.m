//
//  NSString+file.m
//  SPClearCacheTool
//
//  Created by Libo on 16/9/21.
//  Copyright © 2016年 idress. All rights reserved.
//

#import "NSString+file.h"

@implementation NSString (file)
- (long long)fileSize
{
    // 1.文件管理者
    NSFileManager *manager = [NSFileManager defaultManager];
    
    // 2.判断file是否存在
    BOOL isDirectory = NO;
    BOOL fileExists = [manager fileExistsAtPath:self isDirectory:&isDirectory];
    // 文件\文件夹不存在
    if (fileExists == NO) return 0;
    
    // 3.判断file是否为文件夹
    if (isDirectory) { // 是文件夹
        NSArray *subpaths = [manager contentsOfDirectoryAtPath:self error:nil];
        long long totalSize = 0;
        for (NSString *subpath in subpaths) {
            NSString *fullSubpath = [self stringByAppendingPathComponent:subpath];
            totalSize += [fullSubpath fileSize];
        }
        return totalSize;
    } else { // 不是文件夹, 文件
        // 直接计算当前文件的尺寸
        NSDictionary *attr = [manager attributesOfItemAtPath:self error:nil];
        return [attr[NSFileSize] longLongValue];
    }
}
@end
