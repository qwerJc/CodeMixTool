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

@property (assign, nonatomic) NSRange randomClassNameRange; // 是否使用随机类名

@property (strong, nonatomic) NSString *preName;
@property (assign, nonatomic) NSRange preNameLengthRange;

@property (strong, nonatomic) NSString *infixName;
@property (assign, nonatomic) NSRange infixNameLengthRange;

@property (strong, nonatomic) NSString *suffixName;
@property (assign, nonatomic) NSRange suffixNameLengthRange;
@end

@implementation MixClassNameManager
#pragma mark - 修改随机类名
- (void)setRandomClassNameWithLengthRange:(NSRange)range {
    _randomClassNameRange = range;
}
#pragma mark - 添加类名 前缀
- (void)addFixClassPreName:(NSString *)preName {
    _preName = preName;
}

- (void)addRandomClassPreNameWithLengthRange:(NSRange)range {
    _preNameLengthRange = range;
}

#pragma mark - 添加类名 中缀
- (void)addFixClassInfixName:(NSString *)infixName {
    _infixName = infixName;
}

- (void)addRandomClassInfixNameWithLengthRange:(NSRange)range {
    _infixNameLengthRange = range;
}

#pragma mark - 添加类名 后缀
- (void)addFixClassSuffixName:(NSString *)suffixName {
    _suffixName = suffixName;
}

- (void)addRandomClassSuffixNameWithLengthRange:(NSRange)range {
    _suffixNameLengthRange = range;
}

#pragma mark - 开始混淆
- (void)startMixedWithCodeFilePath:(NSString *)codeFilePath andProjPath:(NSString *)projPath {
    @autoreleasepool {
        // 打开工程文件
        NSError *error = nil;
        NSMutableString *projectContent = [NSMutableString stringWithContentsOfFile:projPath encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            printf("JJC-打开工程文件 %s 失败：%s\n", projPath.UTF8String, error.localizedDescription.UTF8String);
            return ;
        }
        
        NSLog(@"=========================");
        [[FileMixedHelper sharedHelper] getCategoryFileClassSet:projectContent
                                               andSourceCodeDir:codeFilePath
                                                   andIgnoreDir:nil];
        NSLog(@"输出所有category 文件：%@",[FileMixedHelper sharedHelper].categoryFileSet);
        NSLog(@"=========================");
        
        [self changeRandomClassNameWithProjPath:projectContent andCodeFilePath:codeFilePath];
        
        [projectContent writeToFile:projPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

#pragma mark - Private
- (void)changeRandomClassNameWithProjPath:(NSMutableString *)projectContent andCodeFilePath:(NSString *)sourceCodeDir {

    NSFileManager *fm = [NSFileManager defaultManager];
    
    // 遍历源代码文件 h 与 m 配对，swift
    NSArray<NSString *> *files = [fm contentsOfDirectoryAtPath:sourceCodeDir error:nil];
    
    if (!files) {
        NSLog(@"JJC错误：该路径下没有文件，请检查sonPath设置是否正确");
    }
    
    BOOL isDirectory;
    for (NSString *filePath in files) {
        NSString *path = [sourceCodeDir stringByAppendingPathComponent:filePath];
        
        // fileExistsAtPath 判断当前路径下是否为路径，若isDirectory为Yes则是路径
        if ([fm fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory) {
            if (![path containsString:@"/assets/images"]) {
                [self changeRandomClassNameWithProjPath:projectContent andCodeFilePath:path];
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
                    
                    NSString *oldFilePath = [[sourceCodeDir stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"h"];
                    NSString *newFilePath = [[sourceCodeDir stringByAppendingPathComponent:newClassName] stringByAppendingPathExtension:@"h"];
                    [[FileMixedHelper sharedHelper] resaveFileWithOldFilePath:oldFilePath andNewFilePath:newFilePath];
                    
                    oldFilePath = [[sourceCodeDir stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"m"];
                    newFilePath = [[sourceCodeDir stringByAppendingPathComponent:newClassName] stringByAppendingPathExtension:@"m"];
                    [[FileMixedHelper sharedHelper] resaveFileWithOldFilePath:oldFilePath andNewFilePath:newFilePath];
                    
                    oldFilePath = [[sourceCodeDir stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"xib"];
                    
                    if ([fm fileExistsAtPath:oldFilePath]) {
                        newFilePath = [[sourceCodeDir stringByAppendingPathComponent:newClassName] stringByAppendingPathExtension:@"xib"];
                        [[FileMixedHelper sharedHelper] resaveFileWithOldFilePath:oldFilePath andNewFilePath:newFilePath];
                    }
                    
                    // 遍历所有工程文件，替换类名
                    @autoreleasepool {
                        [[FileMixedHelper sharedHelper] modifyFilesClassNameWithSourceCodeDir:sourceCodeDir
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
    // 如果当前需要混淆固定类名
    if (_randomClassNameRange.location>0 || _randomClassNameRange.length>0) {
        NSUInteger length = arc4random_uniform((uint32_t)_randomClassNameRange.length) + _randomClassNameRange.location;
        return [FileMixedHelper randomString:length];
    } else {
        NSString *newClassName;
        // 如果存在 固定前缀/随机前缀
        if (_preName) {
            newClassName = _preName;
        } else if (_preNameLengthRange.location>0 || _preNameLengthRange.length>0) {
            NSUInteger length = arc4random_uniform((uint32_t)_preNameLengthRange.length) + _preNameLengthRange.location;
            newClassName = [FileMixedHelper randomString:length];
        }
        
        // 如果存在 固定中缀/随机中缀
        if (_infixName) {
            if (oldClassName.length > 1) {
                NSUInteger index = oldClassName.length/2;
                newClassName = [[[newClassName stringByAppendingString:[oldClassName substringToIndex:index]]
                                               stringByAppendingString:_infixName]
                                               stringByAppendingString:[oldClassName substringFromIndex:index]];
            }
        } else if (_infixNameLengthRange.location>0 || _infixNameLengthRange.length>0) {
            if (oldClassName.length > 1) {
                NSUInteger length = arc4random_uniform((uint32_t)_infixNameLengthRange.length) + _infixNameLengthRange.location;
                NSString *randomString = [FileMixedHelper randomString:length];
                
                NSUInteger index = oldClassName.length/2;
                newClassName = [[[newClassName stringByAppendingString:[oldClassName substringToIndex:index]]
                                 stringByAppendingString:randomString]
                                stringByAppendingString:[oldClassName substringFromIndex:index]];
            }
        }
        
        // 如果存在 固定后缀/随机后缀
        if (_suffixName) {
            newClassName = [newClassName stringByAppendingString:_suffixName];
        } else if (_suffixNameLengthRange.location>0 || _suffixNameLengthRange.length>0) {
            NSUInteger length = arc4random_uniform((uint32_t)_suffixNameLengthRange.length) + _suffixNameLengthRange.location;
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
