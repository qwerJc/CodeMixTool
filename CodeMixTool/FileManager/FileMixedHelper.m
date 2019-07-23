//
//  FileMixedHelper.m
//  CodeMixTool
//
//  Created by 贾辰 on 2019/6/24.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import "FileMixedHelper.h"

static const NSString *kRandomAlphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

@implementation DeleteFunctionModel
- (NSString *)description {
    return [NSString stringWithFormat:@"\nisDeleteLineBreak: %d \nisDeleteAnnotation: %d \nisDeleteNSLog: %d",self.isDeleteLineBreak,self.isDeleteAnnotation,self.isDeleteNSLog];
}
@end

@implementation SpamCodeFunctionModel
@end

@implementation MixedFunctionModel
@end


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
    
    self.modelDelete = [[DeleteFunctionModel alloc] init];
    self.modelSpamCode = [[SpamCodeFunctionModel alloc] init];
    self.modelMixed = [[MixedFunctionModel alloc] init];
    
    _ignorePath = @"/Users/jiachen/xiuchang_iPhone/greenhouse-iPhone/ThirdParty_Components/";
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
+ (NSString *)randomWordWithIndex:(NSInteger)index {
    // index : 1-4
    
    if (index == 0) {
        // n.
        NSInteger i = arc4random()%[FileMixedHelper sharedHelper].arrayNWordLibrary.count;
        return [FileMixedHelper sharedHelper].arrayNWordLibrary[i];
    
    } else if (index == 1) {
        // adv.(修饰adj,vt)
        NSInteger i = arc4random()%[FileMixedHelper sharedHelper].arrayAdvWordLibrary.count;
        return [FileMixedHelper sharedHelper].arrayAdvWordLibrary[i];
        
    } else if (index == 2) {
        // adj.
        NSInteger i = arc4random()%[FileMixedHelper sharedHelper].arrayAdjWordLibrary.count;
        return [FileMixedHelper sharedHelper].arrayAdjWordLibrary[i];
        
    } else if (index == 3) {
        // vt.
        NSInteger i = arc4random()%[FileMixedHelper sharedHelper].arrayVtWordLibrary.count;
        return [FileMixedHelper sharedHelper].arrayVtWordLibrary[i];
    }
    return @"";
}

+ (NSString *)randomWordPropertyName {
    NSMutableString *mstr = [[NSMutableString alloc] initWithCapacity:0];
    
    NSInteger lengthN = arc4random()%3;
    if (lengthN == 0) {
        [mstr appendString:[[self randomWordWithIndex:2] capitalizedString]];
    }
    [mstr appendString:[[self randomWordWithIndex:0] capitalizedString]];
    [mstr appendString:[[self randomWordWithIndex:0] capitalizedString]];
    
    return [mstr copy];
}

+ (NSString *)randomWordClassName {
    NSMutableString *mstr = [[NSMutableString alloc] initWithCapacity:0];
    
    NSInteger lengthAdj = arc4random()%1+1;
    if (lengthAdj==0) {
        [mstr appendString:[self randomWordWithIndex:2]];
    } else {
        [mstr appendString:[[self randomWordWithIndex:2] capitalizedString]];
    }
    
    
    NSInteger lengthN = arc4random()%2+2;
    for (int i = 0; i<lengthN ; i++) {
        [mstr appendString:[[self randomWordWithIndex:0] capitalizedString]];
    }
    
    [mstr appendString:[[self randomWordWithIndex:1] capitalizedString]];
    [mstr appendString:[[self randomWordWithIndex:2] capitalizedString]];
    [mstr appendString:[[self randomWordWithIndex:0] capitalizedString]];
    return [mstr copy];
}

+ (NSString *)randomWordMethodName {
    NSMutableString *mstr = [[NSMutableString alloc] initWithCapacity:0];
    
    NSInteger lengthADV = arc4random()%1+1;
    if (lengthADV==0) {
        [mstr appendString:[self randomWordWithIndex:1]];
    } else {
        [mstr appendString:[[self randomWordWithIndex:1] capitalizedString]];
    }
    
    NSInteger lengthVT = arc4random()%1+1;
    for (int i = 0; i<lengthVT ; i++) {
        [mstr appendString:[[self randomWordWithIndex:3] capitalizedString]];
    }
    
    [mstr appendString:[[self randomWordWithIndex:0] capitalizedString]];
    [mstr appendString:[[self randomWordWithIndex:0] capitalizedString]];

    return [mstr copy];
}

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
- (BOOL)isNeedChangedFileName:(NSString *)name {
    if ([_ignoreClassNamesSet containsObject:name]) {
        return NO;
    } else {
        return YES;
    }
}

- (void)getAllCategoryFileClassNameWithSourceCodeDir:(NSString *)sourceCodeDir {
    NSFileManager *fm = [NSFileManager defaultManager];
    
    // 遍历源代码文件 h 与 m 配对，swift
    NSArray<NSString *> *files = [fm contentsOfDirectoryAtPath:sourceCodeDir error:nil];
    BOOL isDirectory;
    
    for (NSString *file in files) { // filePath
        NSString *filePath = [sourceCodeDir stringByAppendingPathComponent:file];
        if ([fm fileExistsAtPath:filePath isDirectory:&isDirectory] && isDirectory) {
            [self getIgnoreFileWithSourceCodeDir:filePath];
            continue;
        }
        
        NSString *fileName = file.lastPathComponent.stringByDeletingPathExtension; //类名：JJCView
        NSString *fileExtension = file.pathExtension; // h/m 文件
        
        if ([fileExtension isEqualToString:@"h"] || [fileExtension isEqualToString:@"m"]) {
            // 获取文件名带+的
            [self getAllCategoryFileWithFileName:fileName];
        }
    }
}
- (void)getIgnoreFileWithSourceCodeDir:(NSString *)sourceCodeDir {
    NSFileManager *fm = [NSFileManager defaultManager];
    
    // 遍历源代码文件 h 与 m 配对，swift
    NSArray<NSString *> *files = [fm contentsOfDirectoryAtPath:sourceCodeDir error:nil];
    BOOL isDirectory;
    
    for (NSString *file in files) { // filePath
        NSString *filePath = [sourceCodeDir stringByAppendingPathComponent:file];
        if ([fm fileExistsAtPath:filePath isDirectory:&isDirectory] && isDirectory) {
            [self getIgnoreFileWithSourceCodeDir:filePath];
            continue;
        }
        
        NSString *fileName = file.lastPathComponent.stringByDeletingPathExtension; //类名：JJCView
        NSString *fileExtension = file.pathExtension; // h/m 文件
        
//        if ([fileExtension isEqualToString:@"h"] && ![files containsObject:[fileName stringByAppendingPathExtension:@"m"]]) {
//            // 当前为.h且不存在.m
//            // 可能为实现文件在库中，暴露出了.h
//            [_categoryFileSet addObject:fileName];
//            continue;
//        }
        
        if ([fileExtension isEqualToString:@"h"] || [fileExtension isEqualToString:@"m"]) {
            // 获取文件名带+的
            [self getAllCategoryFileWithFileName:fileName];
            
//            // 获取import<>的和@class的
//            NSMutableString *fileContent = [NSMutableString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//            [self getImportFileNameWithFileContent:fileContent];
        }
    }
}
- (void)getAllCategoryFileWithFileName:(NSString *)fileName {
    //处理是category的情况。
    if ([fileName containsString:@"+"]) {
        // 带+（category的方法）
        [_categoryFileSet addObject:fileName];
        
        // category 所拓展的类名q
        NSUInteger index = [fileName rangeOfString:@"+"].location;
        NSString *className = [fileName substringToIndex:index];
        
        if (![_categoryFileSet containsObject:className]) {
            [_categoryFileSet addObject:className];
        }
    }
}

- (void)getImportFileNameWithFileContent:(NSString *)fileContent {
    
    // #import"" 和 #import<>
    NSString *mRegularExpression = [NSString stringWithFormat:@"(?<=[<]).*(?=.h[>])"];
    NSRegularExpression *mExpression = [NSRegularExpression regularExpressionWithPattern:mRegularExpression options:NSRegularExpressionAnchorsMatchLines|NSRegularExpressionUseUnixLineSeparators error:nil];
    NSArray<NSTextCheckingResult *> *mMatches = [mExpression matchesInString:fileContent options:0 range:NSMakeRange(0, fileContent.length)];
    
    if (mMatches.count > 0) {
        for (NSTextCheckingResult *result in mMatches) {
            NSRange range = result.range;
            NSString *className = [fileContent substringWithRange:range];
            if (![_categoryFileSet containsObject:className]) {
                [_categoryFileSet addObject:className];
            }
        }
    }
    
    // @class XX,xx,xx;
    NSString *classRegularExpression = [NSString stringWithFormat:@"(?<=@class ).*(?=;)"];
    mExpression = [NSRegularExpression regularExpressionWithPattern:classRegularExpression options:NSRegularExpressionAnchorsMatchLines|NSRegularExpressionUseUnixLineSeparators error:nil];
    mMatches = [mExpression matchesInString:fileContent options:0 range:NSMakeRange(0, fileContent.length)];
    if (mMatches.count > 0) {
        for (NSTextCheckingResult *result in mMatches) {
            NSRange range = result.range;
            // sumClassName 中可能包含
            NSString *sumClassName = [fileContent substringWithRange:range];
            
            if ([sumClassName containsString:@","]) {
                for (NSString *className in [sumClassName componentsSeparatedByString:@","]) {
                    if (![_categoryFileSet containsObject:className]) {
                        [_categoryFileSet addObject:className];
                    }
                }
            } else {
                // @class 只包含一个
                if (![_categoryFileSet containsObject:sumClassName]) {
                    [_categoryFileSet addObject:sumClassName];
                }
            }
        }
    }
}


#pragma mark - Other
+ (void)showAlert:(NSString *)string andDetailString:(NSString *)detailString {
    NSLog(@"%@ \n %@",string, detailString);
}

+ (BOOL)isFolderEmpryWithPath:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray<NSString *> *arrFiles = [fm contentsOfDirectoryAtPath:path error:nil];
    
    if ([arrFiles count] == 0) {
        return YES;
    } else {
        return NO;
    }
}
@end
