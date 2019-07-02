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

- (void)setupWithXcodeProjPath:(NSString *)projPath andCodeFilePath:(NSString *)codePath andTask:(EnumTaskType)task;

#pragma mark - 删除
- (void)deleteUselessCode;
- (void)setSumFileCodePath:(NSString *)path;
#pragma mark - 混淆类名
- (void)randomClassName;

#pragma mark - 添加垃圾代码
- (void)addSpamCode;
@end

NS_ASSUME_NONNULL_END
