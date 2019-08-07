//
//  IntegrateManager.m
//  CodeMixTool
//
//  Created by 贾辰 on 2019/8/7.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import "IntegrateManager.h"
#import "ModelLocator.h"
#import "FileMixedHelper.h"

@interface IntegrateManager()
@property (assign, nonatomic) BOOL isDelSumDir;             // 是否删除替换的文件夹
@property (assign, nonatomic) BOOL isJudgeInProject;        // 是否判读当前文件在项目中
@end

@implementation IntegrateManager

/**
 初始化方法
 注：isJudgeInProject为yes时，文件夹中没有引入到项目的文件，不会进行删除
 此时：
    isDelIntegratedFile 为Yes 只会删除引入过的文件
    isDelSumDir         为Yes 会删除全部的文件夹
 */
- (void)setupWithIsDelIntegratedSumDir:(BOOL)isDelSumDir
                    isJudgeInProject:(BOOL)isJudgeInProject {
    
    _isDelSumDir = isDelSumDir;
    _isJudgeInProject = isJudgeInProject;
}

- (void)startIntegrateFile {
    if (model.modifyFileSavePath.length == 0) {
        return ;
    }
    
    BOOL isTotalSuccess = YES; // 是否全部文件整合成功
    
    NSMutableArray *arrDuplicationFileName = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString *path in [model.msetModifyFilePath copy]) {
        NSString *fileName = path.lastPathComponent.stringByDeletingPathExtension;
        NSString *fileExtension = path.pathExtension;
        
        // 判断projectContent是否包含
        if ([self judgeIsProjContentContainFileWithFileName:[fileName stringByAppendingPathExtension:fileExtension]]) {
            
            NSError *errorMove;
            NSString *newPath = [[NSString stringWithFormat:@"%@/%@",model.modifyFileSavePath,fileName] stringByAppendingPathExtension:fileExtension];
            
            errorMove = [self moveFileWithOldFilePath:path andNewFilePath:newPath];
            
            if (errorMove) {
                isTotalSuccess = NO;
                if (errorMove.code == 516) {
                    // 重复文件
                    [arrDuplicationFileName addObject:fileName];
                } else {
                    // 其他错误
                    [FileMixedHelper showAlert:@"【整合】 - 移动文件 失败" andDetailString:errorMove.localizedDescription];
                    break;
                }
            } else {
                NSLog(@"【整合】 - %@ 文件 移动成功",path);
            }
        }
    }
    
    // 判断是否需要删除旧的文件夹
    if (isTotalSuccess) {
        [self judgeIsNeedDelSumDir];
    } else {
        if (arrDuplicationFileName.count > 0) {
            NSLog(@"【存在重名文件】");
            NSLog(@"%@",[arrDuplicationFileName copy]);
        }
    }
    
}

// 判断当前是否在XCode引用文件中
// fileName:xxx.h 这样的文件，注意要加后缀，否则如果文件夹名和未在引用的类名相同，会把该类也整合进去
- (BOOL)judgeIsProjContentContainFileWithFileName:(NSString *)fileName {
    
    if (_isJudgeInProject) {
        NSString *projContentPath = [NSString stringWithFormat:@"%@/project.pbxproj",model.projPath];
        NSMutableString *projectContent = [NSMutableString stringWithContentsOfFile:projContentPath
                                                                           encoding:NSUTF8StringEncoding
                                                                              error:nil];
        if ([projectContent containsString:fileName]) {
            return YES;
        } else {
            return NO;
        }
    } else {
        // 如果当前不需要判断（比如一些特殊的文件,不在project.pbxproj 中,则直接返回yes）
        return YES;
    }
}

- (NSError *)moveFileWithOldFilePath:(NSString *)oldPath andNewFilePath:(NSString *)newPath {
    NSError *errorMove = nil;
    
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm moveItemAtPath:oldPath toPath:newPath error:&errorMove];
    
    return errorMove;
//    if (errorMove) {
//
//        return NO;
//    } else {
//
//        return YES;
//    }
}

/**
 判断是否需要删除 整个文件夹
 */
- (void)judgeIsNeedDelSumDir {
    if (_isDelSumDir ) {
        NSError *errorRemove = nil;
        if (model.arrSonPath.count > 0) {
            for (NSString *path in model.arrSonPath) {
                NSFileManager *fm = [NSFileManager defaultManager];
                [fm removeItemAtPath:path error:&errorRemove];
            }
        } else {
            NSFileManager *fm = [NSFileManager defaultManager];
            [fm removeItemAtPath:model.sourceCodePath error:&errorRemove];
        }
        
        if (errorRemove) {
            [FileMixedHelper showAlert:@"【整合】- 删除旧文件 失败  需要手动删除" andDetailString:errorRemove.localizedDescription];
        }
    }
}
@end
