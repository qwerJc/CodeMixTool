//
//  FileMixedHelper.h
//  CodeMixTool
//
//  Created by 贾辰 on 2019/6/24.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileMixedHelper : NSObject
@property (strong, nonatomic,readonly) NSSet *categoryFileSet; // category文件的集合
+(instancetype)sharedHelper;

#pragma mark - 替换
/**
 正则替换（修改 project.pbxproj 中的引用名）
 
 @param originalString 源代码
 @param regularExpression 正则替换规则（iOS下的正则 和 普通的正则有细微差别，如：xcode下\\为对\的转义）
 @param newString 新的字符串
 */
- (BOOL)regularReplacement:(NSMutableString *)originalString regularExpression:(NSString *)regularExpression newString:(NSString *)newString;

/**
 遍历全部code文件 替换类名

 @param sourceCodeDir code文件总路径
 @param oldClassName 旧类名
 @param newClassName 新类名
 */
- (void)modifyFilesClassNameWithSourceCodeDir:(NSString *)sourceCodeDir andOldClassName:(NSString *)oldClassName andNewClassName:(NSString *)newClassName;

/**
 重新保存文件（替换）

 @param oldPath 旧的文件路径
 @param newPath 新保存的文件路径
 */
- (void)resaveFileWithOldFilePath:(NSString *)oldPath andNewFilePath:(NSString *)newPath;
#pragma mark - 返回随机字符串
/**
 返回随机字符串

 @param length 字符串长度
 */
+ (NSString *)randomString:(NSInteger )length;

/** 返回随机单个字符 */
+ (NSString *)randomLetter;

/** 返回随机单个 大写 字符 */
+ (NSString *)randomCapital;

/** 返回随机单个数字 */
+ (NSString *)randomNum;
#pragma mark - 忽略文件
/* 当前类名是否需要替换 */
+ (BOOL)isNeedChangedFileName:(NSString *)name;

// 获取category所拓展的文件合集
- (void)getCategoryFileClassSet:(NSMutableString *)projectContent andSourceCodeDir:(NSString *)sourceCodeDir andIgnoreDir:(NSArray<NSString *> *)ignoreDirNames;
@end

NS_ASSUME_NONNULL_END