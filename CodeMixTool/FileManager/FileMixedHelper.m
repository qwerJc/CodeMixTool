//
//  FileMixedHelper.m
//  CodeMixTool
//
//  Created by 贾辰 on 2019/6/24.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import "FileMixedHelper.h"

static const NSString *kRandomAlphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

@implementation FileMixedHelper
+(instancetype)sharedHelper {
    static FileMixedHelper *fileMixedHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fileMixedHelper = [[self alloc] init];
        
    });
    
    return fileMixedHelper;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createData];
    }
    return self;
}

- (void)createData {
    _categoryFileSet = [[NSMutableSet alloc] initWithCapacity:0];
}
#pragma mark - 替换
// 正则替换
- (BOOL)regularReplacement:(NSMutableString *)originalString regularExpression:(NSString *)regularExpression newString:(NSString *)newString {
    
    __block BOOL isChanged = NO;
    BOOL isGroupNo1 = [newString isEqualToString:@"\\1"]; // \1 代表与第一个小括号中要匹配的内容相同
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regularExpression options:NSRegularExpressionAnchorsMatchLines|NSRegularExpressionUseUnixLineSeparators error:nil];
    NSArray<NSTextCheckingResult *> *matches = [expression matchesInString:originalString options:0 range:NSMakeRange(0, originalString.length)];
    [matches enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!isChanged) {
            isChanged = YES;
        }
        if (isGroupNo1) {
            NSString *withString = [originalString substringWithRange:[obj rangeAtIndex:1]];
            [originalString replaceCharactersInRange:obj.range withString:withString];
        } else {
            [originalString replaceCharactersInRange:obj.range withString:newString];
        }
    }];
    return isChanged;
}

// 遍历所有文件替换类名
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
        
        NSString *fileName = filePath.lastPathComponent;
        if ([fileName hasSuffix:@".h"] || [fileName hasSuffix:@".m"] || [fileName hasSuffix:@".pch"] || [fileName hasSuffix:@".swift"] || [fileName hasSuffix:@".xib"] || [fileName hasSuffix:@".storyboard"]) {
            
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
        }
    }
}

// 新旧文件替换
- (void)resaveFileWithOldFilePath:(NSString *)oldPath andNewFilePath:(NSString *)newPath {
    NSError *error;
    [[NSFileManager defaultManager] moveItemAtPath:oldPath toPath:newPath error:&error];
    if (error) {
        printf("修改文件名称失败。\n  oldPath=%s\n  newPath=%s\n  ERROR:%s\n", oldPath.UTF8String, newPath.UTF8String, error.localizedDescription.UTF8String);
    }
}
#pragma mark - Return String

+ (NSString *)randomString:(NSInteger )length {
    NSMutableString *str = [NSMutableString stringWithCapacity:length];
    [str appendString:[self randomLetter]];
    for (int i = 0; i < length-1; i++) {
        [str appendFormat:@"%C",[kRandomAlphabet characterAtIndex:arc4random_uniform((uint32_t)[kRandomAlphabet length])]];
    }
    return str;
}

+ (NSString *)randomLetter {
    return [NSString stringWithFormat:@"%C", [kRandomAlphabet characterAtIndex:arc4random_uniform(52)]];
}

+ (NSString *)randomCapital {
    return [NSString stringWithFormat:@"%C", [kRandomAlphabet characterAtIndex:arc4random_uniform(26)]];
}

+ (NSString *)randomNum {
    return [NSString stringWithFormat:@"%d",(arc4random_uniform(8)+1)];
}

#pragma mark - 忽略列表
+ (BOOL)isNeedChangedFileName:(NSString *)name {
    if ([name isEqualToString:@"AppDelegate"] ||
        [name isEqualToString:@"ViewController"]
        ) {
        return NO;
    } else {
        return YES;
    }
}

- (void)getCategoryFileClassSet:(NSMutableString *)projectContent andSourceCodeDir:(NSString *)sourceCodeDir andIgnoreDir:(NSArray<NSString *> *)ignoreDirNames {
    if (!_categoryFileSet) {
        NSFileManager *fm = [NSFileManager defaultManager];
        
        // 遍历源代码文件 h 与 m 配对，swift
        NSArray<NSString *> *files = [fm contentsOfDirectoryAtPath:sourceCodeDir error:nil];
        BOOL isDirectory;
        
        NSMutableSet *mSet = [[NSMutableSet alloc] initWithCapacity:0];
        
        for (NSString *filePath in files) { // filePath
            NSString *path = [sourceCodeDir stringByAppendingPathComponent:filePath];
            if ([fm fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory) {
                if (![ignoreDirNames containsObject:filePath]) {
                    [self getCategoryFileClassSet:projectContent andSourceCodeDir:path andIgnoreDir:ignoreDirNames];
                }
            }
            
            NSString *fileName = filePath.lastPathComponent.stringByDeletingPathExtension; //类名：JJCView
            NSString *fileExtension = filePath.pathExtension; // h/m 文件
            
            // 当前为.h 或.m文件
            if ([fileExtension isEqualToString:@"h"] || [fileExtension isEqualToString:@"m"]) {
                //            NSLog(@"当前文件名 ： %@",fileName);
                
                //处理是category的情况。
                if ([fileName containsString:@"+"]) {
                    // 带+（category的方法）
                    
                    // category 所拓展的类名
                    NSUInteger index = [fileName rangeOfString:@"+"].location;
                    NSString *className = [fileName substringToIndex:index];
                    
                    [mSet addObject:className];
                }
            }
        }
        _categoryFileSet = [mSet copy];
    }
}
#pragma mark - Other
+ (void)showAlert:(NSString *)string andDetailString:(NSString *)detailString {
    NSLog(@"%@ \n %@",string, detailString);
}
@end
