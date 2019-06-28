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
/**
 删除 无用代码

 @param isDelLineBreak  为Yes时，删除换行符
 @param isDelAnnotation  为Yes时，删除各种注释
 @param isDelNSLog      为Yes时，删除NSLog
 */
- (void)deleteUselessCodeWithLineBreak:(BOOL)isDelLineBreak andAnnotation:(BOOL)isDelAnnotation andNSLog:(BOOL)isDelNSLog;

#pragma mark - 混淆类名
- (void)randomClassName;

#pragma mark - 添加垃圾代码
- (void)addSpamCode;
@end

NS_ASSUME_NONNULL_END
