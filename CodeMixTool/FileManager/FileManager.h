//
//  FileManager.h
//  CodeMixTool
//
//  Created by 贾辰 on 2019/4/2.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FunctionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FileManager : NSObject

#pragma mark - 删除
- (void)deleteUselessCode;
#pragma mark - 混淆类名
- (void)randomClassName;

#pragma mark - 添加垃圾代码
- (void)addSpamCodeWithOutPath:(NSString *)outPath;

#pragma mark - 整合
- (void)modifyCodeFile;
@end

NS_ASSUME_NONNULL_END
