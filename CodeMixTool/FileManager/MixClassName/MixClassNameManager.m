//
//  MixClassNameManager.m
//  CodeMixTool
//
//  Created by 贾辰 on 2019/6/19.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import "MixClassNameManager.h"
#import "FileMixedHelper.h"
#import "ModelLocator.h"

@interface MixClassNameManager()
@property (strong, nonatomic) dispatch_semaphore_t semaphore;
@end

@implementation MixClassNameManager

#pragma mark - 开始混淆
- (void)startMixed {
    
    _semaphore = dispatch_semaphore_create(0);
//    if (model.arrSonPath.count > 0){
//        for (NSString *path in model.arrSonPath) {
//            [self changeRandomClassNameWithCodeFilePath:path];
//
//        }
//    } else {
//        [self changeRandomClassNameWithCodeFilePath:model.sourceCodePath];
//    }
    [self newChangeRandomClassName];
}

#pragma mark - Private
- (void)newChangeRandomClassName {
    
    NSLog(@"%@",[model.msetModifyFilePath copy]);
    for (NSString *path in [model.msetModifyFilePath copy]) {
        @autoreleasepool {
            NSString *fileName = path.lastPathComponent.stringByDeletingPathExtension;
            NSString *fileExtension = path.pathExtension;
            NSString *fileDirPath = [path stringByDeletingLastPathComponent];// path文件所属的上一级文件夹路径
            NSFileManager *fm = [NSFileManager defaultManager];
            NSArray<NSString *> *files = [fm contentsOfDirectoryAtPath:fileDirPath error:nil];
            NSString *newClassName;

            // 当前为.h文件 且 为可以更改的文件（不是AppDelegate,ViewController等）
            if (![model.categoryFileSet containsObject:fileName] && [[FileMixedHelper sharedHelper] isNeedChangedFileName:fileName]) {

                // 当前为.h文件且同级目录下有对应的.m文件
                if ([fileExtension isEqualToString:@"h"] && [files containsObject:[fileName stringByAppendingPathExtension:@"m"]]) {
                    newClassName = [self getNewClassNameWithOldClassName:fileName];

                    // 若当前的.h文件存在对应的.m文件
                    NSString *mFileName = [fileName stringByAppendingPathExtension:@"m"];
                    if ([files containsObject:mFileName]) {
                        NSLog(@"fileName : %@ -> %@",fileName,newClassName);

                        NSString *oldFilePath = [[fileDirPath stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"h"];
                        NSString *newFilePath = [[fileDirPath stringByAppendingPathComponent:newClassName] stringByAppendingPathExtension:@"h"];
                        [[FileMixedHelper sharedHelper] resaveFileWithOldFilePath:oldFilePath andNewFilePath:newFilePath];

                        oldFilePath = [[fileDirPath stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"m"];
                        newFilePath = [[fileDirPath stringByAppendingPathComponent:newClassName] stringByAppendingPathExtension:@"m"];
                        [[FileMixedHelper sharedHelper] resaveFileWithOldFilePath:oldFilePath andNewFilePath:newFilePath];

                        oldFilePath = [[fileDirPath stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"xib"];

                        if ([fm fileExistsAtPath:oldFilePath]) {
                            newFilePath = [[fileDirPath stringByAppendingPathComponent:newClassName] stringByAppendingPathExtension:@"xib"];
                            [[FileMixedHelper sharedHelper] resaveFileWithOldFilePath:oldFilePath andNewFilePath:newFilePath];
                        }

                        // 遍历所有工程文件，替换类名
                        @autoreleasepool {
                            [self modifyFilesClassNameWithSourceCodeDir:model.sourceCodePath
                                                        andOldClassName:fileName
                                                        andNewClassName:newClassName];
                        }

                        // 替换 引用文件中的类名
                        @autoreleasepool {
                            [self changeFileNameInProject_pbxprojWithOldClassName:fileName andNewClassName:newClassName];
                        }
                    }

                }
            }
        }
    }
}

- (void)changeRandomClassNameWithCodeFilePath:(NSString *)pathCodeFile {

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
            if (![path containsString:@"/assets/images"] && ![path containsString:model.ignorePath]) {
                [self changeRandomClassNameWithCodeFilePath:path];
            } else {
                NSLog(@"忽略");
            }
            continue;
        }
        
        @autoreleasepool {
            NSString *fileName = filePath.lastPathComponent.stringByDeletingPathExtension;
            NSString *fileExtension = filePath.pathExtension;
            NSString *newClassName;
            
            // 当前为.h文件 且 为可以更改的文件（不是AppDelegate,ViewController等）
            if (![model.categoryFileSet containsObject:fileName] && [[FileMixedHelper sharedHelper] isNeedChangedFileName:fileName]) {
                
                // 当前为.h文件且同级目录下有对应的.m文件
                if ([fileExtension isEqualToString:@"h"] && [files containsObject:[fileName stringByAppendingPathExtension:@"m"]]) {
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
                            [self modifyFilesClassNameWithSourceCodeDir:model.sourceCodePath
                                                        andOldClassName:fileName
                                                        andNewClassName:newClassName];
                        }
                        
                        // 替换 引用文件中的类名
                        @autoreleasepool {
                            [self changeFileNameInProject_pbxprojWithOldClassName:fileName andNewClassName:newClassName];
                        }
                    }
                    
                }
            }
        }
        
    }
}

/**
 遍历全部code文件 替换类名
 
 @param sourceCodeDir code文件总路径
 @param oldClassName 旧类名
 @param newClassName 新类名
 */
- (void)modifyFilesClassNameWithSourceCodeDir:(NSString *)sourceCodeDir andOldClassName:(NSString *)oldClassName andNewClassName:(NSString *)newClassName {
    // 文件内容 Const > DDConst (h,m,swift,xib,storyboard)
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray<NSString *> *files = [fm contentsOfDirectoryAtPath:sourceCodeDir error:nil];
    BOOL isDirectory;
    for (NSString *filePath in files) {
        NSString *path = [sourceCodeDir stringByAppendingPathComponent:filePath];
        if ([fm fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory) {
            [self modifyFilesClassNameWithSourceCodeDir:path andOldClassName:oldClassName andNewClassName:newClassName];
            continue;
        }

        NSString *fileName = filePath.lastPathComponent.stringByDeletingPathExtension;// 带.h 后缀 如：AppDelegate.h
        NSString *fileExtension = filePath.pathExtension;
        
        if ([fileExtension isEqualToString:@"h"]||[fileExtension isEqualToString:@"m"]||[fileExtension isEqualToString:@"pch"]||[fileExtension isEqualToString:@"swift"]||[fileExtension isEqualToString:@"xib"]||[fileExtension isEqualToString:@"storyboard"]) {
            
            NSError *error = nil;
            NSMutableString *fileContent = [NSMutableString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                printf("打开文件 %s 失败：%s\n", path.UTF8String, error.localizedDescription.UTF8String);
            }
            
            // \b表示单词的前后边界,\\为XCode对\的转义
            NSString *regularExpression = [NSString stringWithFormat:@"\\b%@\\b", oldClassName];
            BOOL isChanged = [[FileMixedHelper sharedHelper] regularReplacement:fileContent
                                                              regularExpression:regularExpression
                                                                      newString:newClassName];
            
            if (!isChanged) continue;
            error = nil;
            [fileContent writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                printf("保存文件 %s 失败：%s\n", path.UTF8String, error.localizedDescription.UTF8String);
            }
            
            // 判断是否存在重名的.h
            if ([fileName isEqualToString:oldClassName]) {
                
                NSString *oldFilePath = [[sourceCodeDir stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:fileExtension];
                NSString *newFilePath = [[sourceCodeDir stringByAppendingPathComponent:newClassName] stringByAppendingPathExtension:fileExtension];
                [[FileMixedHelper sharedHelper] resaveFileWithOldFilePath:oldFilePath andNewFilePath:newFilePath];
            }
        }
    }
}

- (void)changeFileNameInProject_pbxprojWithOldClassName:(NSString *)oldName andNewClassName:(NSString *)newName {
    // 打开工程文件
    NSString *projContentPath = [NSString stringWithFormat:@"%@/project.pbxproj",model.projPath];
    NSMutableString *projectContent = [NSMutableString stringWithContentsOfFile:projContentPath
                                                                       encoding:NSUTF8StringEncoding
                                                                          error:nil];
    // 修改 project.pbxproj 中 文件名的引用名
    [[FileMixedHelper sharedHelper] regularReplacement:projectContent
                                     regularExpression:[NSString stringWithFormat:@"\\b%@.h\\b", oldName]
                                             newString:[NSString stringWithFormat:@"%@.h",newName]];
    
    [[FileMixedHelper sharedHelper] regularReplacement:projectContent
                                     regularExpression:[NSString stringWithFormat:@"\\b%@.m\\b", oldName]
                                             newString:[NSString stringWithFormat:@"%@.m",newName]];
    
    [projectContent writeToFile:projContentPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    // 如果存在多重.xcodeProj
    if ([model.arrLibraryProjPath count]>0) {
        for (NSString *path in model.arrLibraryProjPath) {
            NSString *libraryProjPath = [NSString stringWithFormat:@"%@/project.pbxproj",path];
            NSMutableString *libraryContent = [NSMutableString stringWithContentsOfFile:libraryProjPath
                                                                               encoding:NSUTF8StringEncoding
                                                                                  error:nil];
            // 修改 project.pbxproj 中 文件名的引用名
            [[FileMixedHelper sharedHelper] regularReplacement:libraryContent
                                             regularExpression:[NSString stringWithFormat:@"\\b%@.h\\b", oldName]
                                                     newString:[NSString stringWithFormat:@"%@.h",newName]];
            
            [[FileMixedHelper sharedHelper] regularReplacement:libraryContent
                                             regularExpression:[NSString stringWithFormat:@"\\b%@.m\\b", oldName]
                                                     newString:[NSString stringWithFormat:@"%@.m",newName]];
            [libraryContent writeToFile:libraryProjPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }
}

- (NSString *)getNewClassNameWithOldClassName:(NSString *)oldClassName {
    // 如果当前需要混淆 随机类名
    if (model.modelMixed.lengthRandomClassName.location>0 || model.modelMixed.lengthRandomClassName.length>0) {

        return [FileMixedHelper randomWordClassName];
    } else {
        NSString *newClassName;
        NSString *preName;
        // 如果存在 固定前缀/随机前缀
        if (model.modelMixed.preName.length > 0) {
            preName = model.modelMixed.preName;
        } else if (model.modelMixed.lengthPreName.location>0 || model.modelMixed.lengthPreName.length>0) {
            NSUInteger length = arc4random_uniform((uint32_t)model.modelMixed.lengthPreName.length) + model.modelMixed.lengthPreName.location;
            preName = [FileMixedHelper randomString:length];
        }
        
        // 如果存在 固定中缀/随机中缀
        if (model.modelMixed.infixName.length > 0) {
            if (oldClassName.length > 1) {
                NSUInteger index = oldClassName.length/2;
                newClassName = [[[preName stringByAppendingString:[oldClassName substringToIndex:index]]
                                               stringByAppendingString:model.modelMixed.infixName]
                                               stringByAppendingString:[oldClassName substringFromIndex:index]];
            }
        } else if (model.modelMixed.lengthInfixName.location>0 || model.modelMixed.lengthInfixName.length>0) {
            if (oldClassName.length > 1) {
                NSUInteger length = arc4random_uniform((uint32_t)model.modelMixed.lengthInfixName.length) + model.modelMixed.lengthInfixName.location;
                NSString *randomString = [FileMixedHelper randomString:length];
                
                NSUInteger index = oldClassName.length/2;
                newClassName = [[[preName stringByAppendingString:[oldClassName substringToIndex:index]]
                                 stringByAppendingString:randomString]
                                stringByAppendingString:[oldClassName substringFromIndex:index]];
            }
        } else {
            newClassName = [NSString stringWithFormat:@"%@%@",preName,oldClassName];
        }
        
        // 如果存在 固定后缀/随机后缀
        if (model.modelMixed.suffixName) {
            newClassName = [newClassName stringByAppendingString:model.modelMixed.suffixName];
            
        } else if (model.modelMixed.lengthSuffixName.location>0 || model.modelMixed.lengthSuffixName.length>0) {
            NSUInteger length = arc4random_uniform((uint32_t)model.modelMixed.lengthSuffixName.length) + model.modelMixed.lengthSuffixName.location;
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
