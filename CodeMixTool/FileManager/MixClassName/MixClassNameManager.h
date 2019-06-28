//
//  MixClassNameManager.h
//  CodeMixTool
//
//  Created by 贾辰 on 2019/6/19.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MixClassNameManager : NSObject
#pragma mark - 基础设置
/**
 将类名改为随机字符串
 */
- (void)setRandomClassNameWithLengthRange:(NSRange)range;
/**
 添加 类名 前缀
 
 添加固定前缀时调用 【addFixClassPreName】
 添加随机前缀时调用 【addRandomClassPreName】
 若都不调用 则默认不添加 前缀
 */
- (void)addFixClassPreName:(NSString *)preName;
- (void)addRandomClassPreNameWithLengthRange:(NSRange)range;

/** 添加 类名 中缀 */
- (void)addFixClassInfixName:(NSString *)infixName;
- (void)addRandomClassInfixNameWithLengthRange:(NSRange)range;

/** 添加 类名 后缀  */
- (void)addFixClassSuffixName:(NSString *)suffixName;
- (void)addRandomClassSuffixNameWithLengthRange:(NSRange)range;

#pragma mark - 修改类名
/** 开始混淆  */
- (void)startMixedWithCodeFilePath:(NSString *)codeFilePath andProjPath:(NSString *)projPath;
@end

NS_ASSUME_NONNULL_END
