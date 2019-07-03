//
//  MixClassNameManager.m
//  CodeMixTool
//
//  Created by 贾辰 on 2019/6/19.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import "MixClassNameManager.h"
#import "FileMixedHelper.h"

@interface MixClassNameManager ()
//
//@property (assign, nonatomic) NSRange randomClassNameRange; // 是否使用随机类名
//
//@property (strong, nonatomic) NSString *preName;
//@property (assign, nonatomic) NSRange preNameLengthRange;
//
//@property (strong, nonatomic) NSString *infixName;
//@property (assign, nonatomic) NSRange infixNameLengthRange;
//
//@property (strong, nonatomic) NSString *suffixName;
//@property (assign, nonatomic) NSRange suffixNameLengthRange;
@end

@implementation MixClassNameManager


#pragma mark - 开始混淆
- (void)startMixed {
    @autoreleasepool {
        // 打开工程文件
        NSError *error = nil;
        
        NSString *projContentPath = [NSString stringWithFormat:@"%@/project.pbxproj",[FileMixedHelper sharedHelper].projPath];
        
        NSMutableString *projectContent = [NSMutableString stringWithContentsOfFile:projContentPath
                                                                           encoding:NSUTF8StringEncoding
                                                                              error:&error];
        if (error) {
            NSLog(@"打开工程文件 失败,%@",error.description);
            return ;
        }
        
        [self changeRandomClassNameWithXCProjContent:projectContent
                                     andCodeFilePath:[FileMixedHelper sharedHelper].sourceCodePath];
        
        [projectContent writeToFile:projContentPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

#pragma mark - Private
- (void)changeRandomClassNameWithXCProjContent:(NSMutableString *)projectContent andCodeFilePath:(NSString *)pathCodeFile {

    NSFileManager *fm = [NSFileManager defaultManager];
    
    // 遍历源代码文件 h 与 m 配对，swift
    NSArray<NSString *> *files = [fm contentsOfDirectoryAtPath:pathCodeFile error:nil];
    
    if (!files) {
        NSLog(@"JJC错误：该路径下没有文件，请检查sonPath设置是否正确");
    }
    
    BOOL isDirectory;
    for (NSString *filePath in files) {
        NSString *path = [pathCodeFile stringByAppendingPathComponent:filePath];
        
        // fileExistsAtPath 判断当前路径下是否为路径，若isDirectory为Yes则是路径
        if ([fm fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory) {
            if (![path containsString:@"/assets/images"]) {
                [self changeRandomClassNameWithXCProjContent:projectContent andCodeFilePath:path];
            } else {
                NSLog(@"忽略");
            }
            continue;
        }
        
        NSString *fileName = filePath.lastPathComponent.stringByDeletingPathExtension;
        NSString *fileExtension = filePath.pathExtension;
        NSString *newClassName;
        
        // 当前为.h文件 且 为可以更改的文件（不是AppDelegate,ViewController等）
        if ([fileExtension isEqualToString:@"h"] && [FileMixedHelper isNeedChangedFileName:fileName]) {
            // 当前不是Category文件 & 不是 main.m 文件
            
            if (![fileName containsString:@"+"] && ![[FileMixedHelper sharedHelper].categoryFileSet containsObject:fileName] && ![fileName isEqualToString:@"main"]) {
                newClassName = [self getNewClassNameWithOldClassName:fileName];
                
                // 若当前的.h文件存在对应的.m文件
                NSString *mFileName = [fileName stringByAppendingPathExtension:@"m"];
                if ([files containsObject:mFileName]) {
                    NSLog(@"fileName : %@ -> %@",fileName,newClassName);
                    
                    NSString *oldFilePath = [[pathCodeFile stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"h"];
                    NSString *newFilePath = [[pathCodeFile stringByAppendingPathComponent:newClassName] stringByAppendingPathExtension:@"h"];
                    [[FileMixedHelper sharedHelper] resaveFileWithOldFilePath:oldFilePath andNewFilePath:newFilePath];
                    
                    oldFilePath = [[pathCodeFile stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"m"];
                    newFilePath = [[pathCodeFile stringByAppendingPathComponent:newClassName] stringByAppendingPathExtension:@"m"];
                    [[FileMixedHelper sharedHelper] resaveFileWithOldFilePath:oldFilePath andNewFilePath:newFilePath];
                    
                    oldFilePath = [[pathCodeFile stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"xib"];
                    
                    if ([fm fileExistsAtPath:oldFilePath]) {
                        newFilePath = [[pathCodeFile stringByAppendingPathComponent:newClassName] stringByAppendingPathExtension:@"xib"];
                        [[FileMixedHelper sharedHelper] resaveFileWithOldFilePath:oldFilePath andNewFilePath:newFilePath];
                    }
                    
                    // 遍历所有工程文件，替换类名
                    @autoreleasepool {
                        [[FileMixedHelper sharedHelper] modifyFilesClassNameWithSourceCodeDir:[FileMixedHelper sharedHelper].sourceCodePath
                                                                              andOldClassName:fileName
                                                                              andNewClassName:newClassName];
                    }
                    
                    // 修改 project.pbxproj 中 文件名的引用名
                    [[FileMixedHelper sharedHelper] regularReplacement:projectContent
                                                     regularExpression:[NSString stringWithFormat:@"\\b%@.h\\b", fileName]
                                                             newString:[NSString stringWithFormat:@"%@.h",newClassName]];
                    
                    [[FileMixedHelper sharedHelper] regularReplacement:projectContent
                                                     regularExpression:[NSString stringWithFormat:@"\\b%@.m\\b", fileName]
                                                             newString:[NSString stringWithFormat:@"%@.m",newClassName]];

                }
                
            }
        }
    }
}

- (NSString *)getNewClassNameWithOldClassName:(NSString *)oldClassName {
    // 如果当前需要混淆 随机类名
    if ([FileMixedHelper sharedHelper].modelMixed.lengthRandomClassName.location>0 || [FileMixedHelper sharedHelper].modelMixed.lengthRandomClassName.length>0) {
        NSUInteger length = arc4random_uniform((uint32_t)[FileMixedHelper sharedHelper].modelMixed.lengthRandomClassName.length) + [FileMixedHelper sharedHelper].modelMixed.lengthRandomClassName.location;
        return [FileMixedHelper randomString:length];
    } else {
        NSString *newClassName;
        // 如果存在 固定前缀/随机前缀
        if ([FileMixedHelper sharedHelper].modelMixed.preName) {
            newClassName = [FileMixedHelper sharedHelper].modelMixed.preName;
        } else if ([FileMixedHelper sharedHelper].modelMixed.lengthPreName.location>0 || [FileMixedHelper sharedHelper].modelMixed.lengthPreName.length>0) {
            NSUInteger length = arc4random_uniform((uint32_t)[FileMixedHelper sharedHelper].modelMixed.lengthPreName.length) + [FileMixedHelper sharedHelper].modelMixed.lengthPreName.location;
            newClassName = [FileMixedHelper randomString:length];
        }
        
        // 如果存在 固定中缀/随机中缀
        if ([FileMixedHelper sharedHelper].modelMixed.infixName) {
            if (oldClassName.length > 1) {
                NSUInteger index = oldClassName.length/2;
                newClassName = [[[newClassName stringByAppendingString:[oldClassName substringToIndex:index]]
                                               stringByAppendingString:[FileMixedHelper sharedHelper].modelMixed.infixName]
                                               stringByAppendingString:[oldClassName substringFromIndex:index]];
            }
        } else if ([FileMixedHelper sharedHelper].modelMixed.lengthInfixName.location>0 || [FileMixedHelper sharedHelper].modelMixed.lengthInfixName.length>0) {
            if (oldClassName.length > 1) {
                NSUInteger length = arc4random_uniform((uint32_t)[FileMixedHelper sharedHelper].modelMixed.lengthInfixName.length) + [FileMixedHelper sharedHelper].modelMixed.lengthInfixName.location;
                NSString *randomString = [FileMixedHelper randomString:length];
                
                NSUInteger index = oldClassName.length/2;
                newClassName = [[[newClassName stringByAppendingString:[oldClassName substringToIndex:index]]
                                 stringByAppendingString:randomString]
                                stringByAppendingString:[oldClassName substringFromIndex:index]];
            }
        }
        
        // 如果存在 固定后缀/随机后缀
        if ([FileMixedHelper sharedHelper].modelMixed.suffixName) {
            newClassName = [newClassName stringByAppendingString:[FileMixedHelper sharedHelper].modelMixed.suffixName];
            
        } else if ([FileMixedHelper sharedHelper].modelMixed.lengthSuffixName.location>0 || [FileMixedHelper sharedHelper].modelMixed.lengthSuffixName.length>0) {
            NSUInteger length = arc4random_uniform((uint32_t)[FileMixedHelper sharedHelper].modelMixed.lengthSuffixName.length) + [FileMixedHelper sharedHelper].modelMixed.lengthSuffixName.location;
            NSString *randomString = [FileMixedHelper randomString:length];
            newClassName = [newClassName stringByAppendingString:randomString];
        }
        
        if (newClassName.length>0 && ![newClassName isEqualToString:oldClassName]) {
            return newClassName;
        } else {
            return oldClassName;
        }
    }
}

@end
