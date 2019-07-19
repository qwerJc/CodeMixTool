//
//  MixClassNameManager.m
//  CodeMixTool
//
//  Created by 贾辰 on 2019/6/19.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import "MixClassNameManager.h"
#import "FileMixedHelper.h"

@interface MixClassNameManager()

@end

@implementation MixClassNameManager

#pragma mark - 开始混淆
- (void)startMixed {
//    NSError *error = nil;
//    NSString *projContentPath = [NSString stringWithFormat:@"%@/project.pbxproj",[FileMixedHelper sharedHelper].projPath];
//    NSMutableString *projectContent = [NSMutableString stringWithContentsOfFile:projContentPath
//                                                                       encoding:NSUTF8StringEncoding
//                                                                          error:&error];
//    if (error) {
//        NSLog(@"打开工程文件 失败,%@",error.description);
//        return ;
//    }
    
    if ([FileMixedHelper sharedHelper].arrSonPath.count > 0){
        for (NSString *path in [FileMixedHelper sharedHelper].arrSonPath) {
            [self changeRandomClassNameWithCodeFilePath:path];
            
            
        }
    } else {
        [self changeRandomClassNameWithCodeFilePath:[FileMixedHelper sharedHelper].sourceCodePath];
    }
}

#pragma mark - Private
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
            if (![path containsString:@"/assets/images"] && ![path containsString:[FileMixedHelper sharedHelper].ignorePath]) {
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
            if (![[FileMixedHelper sharedHelper].categoryFileSet containsObject:fileName] && [[FileMixedHelper sharedHelper] isNeedChangedFileName:fileName]) {
                
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
                            [[FileMixedHelper sharedHelper] modifyFilesClassNameWithSourceCodeDir:[FileMixedHelper sharedHelper].sourceCodePath
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

- (void)changeFileNameInProject_pbxprojWithOldClassName:(NSString *)oldName andNewClassName:(NSString *)newName {
    // 打开工程文件
    NSString *projContentPath = [NSString stringWithFormat:@"%@/project.pbxproj",[FileMixedHelper sharedHelper].projPath];
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
    
    if ([[FileMixedHelper sharedHelper].arrLibraryProjPath count]>0) {
        for (NSString *path in [FileMixedHelper sharedHelper].arrLibraryProjPath) {
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
    if ([FileMixedHelper sharedHelper].modelMixed.lengthRandomClassName.location>0 || [FileMixedHelper sharedHelper].modelMixed.lengthRandomClassName.length>0) {

        return [FileMixedHelper randomWordClassName];
    } else {
        NSString *newClassName;
        NSString *preName;
        // 如果存在 固定前缀/随机前缀
        if ([FileMixedHelper sharedHelper].modelMixed.preName.length > 0) {
            preName = [FileMixedHelper sharedHelper].modelMixed.preName;
        } else if ([FileMixedHelper sharedHelper].modelMixed.lengthPreName.location>0 || [FileMixedHelper sharedHelper].modelMixed.lengthPreName.length>0) {
            NSUInteger length = arc4random_uniform((uint32_t)[FileMixedHelper sharedHelper].modelMixed.lengthPreName.length) + [FileMixedHelper sharedHelper].modelMixed.lengthPreName.location;
            preName = [FileMixedHelper randomString:length];
        }
        
        // 如果存在 固定中缀/随机中缀
        if ([FileMixedHelper sharedHelper].modelMixed.infixName.length > 0) {
            if (oldClassName.length > 1) {
                NSUInteger index = oldClassName.length/2;
                newClassName = [[[preName stringByAppendingString:[oldClassName substringToIndex:index]]
                                               stringByAppendingString:[FileMixedHelper sharedHelper].modelMixed.infixName]
                                               stringByAppendingString:[oldClassName substringFromIndex:index]];
            }
        } else if ([FileMixedHelper sharedHelper].modelMixed.lengthInfixName.location>0 || [FileMixedHelper sharedHelper].modelMixed.lengthInfixName.length>0) {
            if (oldClassName.length > 1) {
                NSUInteger length = arc4random_uniform((uint32_t)[FileMixedHelper sharedHelper].modelMixed.lengthInfixName.length) + [FileMixedHelper sharedHelper].modelMixed.lengthInfixName.location;
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
