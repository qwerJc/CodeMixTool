//
//  IntegrateManager.h
//  CodeMixTool
//
//  Created by 贾辰 on 2019/8/7.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IntegrateManager : NSObject

/**
 初始化方法
 
 @param isDelIntegratedFile 为Yes时，保存成功后会删除旧文件
 @param isDelSumDir         为Yes时，全部保存成功后会删除旧的文件夹
 @param isJudgeInProject    是否判读当前文件在项目中
 */
- (void)setupWithIsDelIntegratedFile:(BOOL)isDelIntegratedFile
               isDelIntegratedSumDir:(BOOL)isDelSumDir
                    isJudgeInProject:(BOOL)isJudgeInProject;

/* 开始整合（需要先调用 setupWithIsDelIntegratedFile... 方法） */
- (void)startIntegrateFile;
@end

NS_ASSUME_NONNULL_END
