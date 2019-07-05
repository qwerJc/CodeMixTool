//
//  SpamCodeCreateManager.m
//  CodeMixTool
//
//  Created by 贾辰 on 2019/6/25.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import "SpamCodeCreateManager.h"
#import "FileMixedHelper.h"
#import "SpamPropertyModel.h"
#import "SpamCategoryModel.h"

@interface SpamCodeCreateManager ()
@property (strong, nonatomic) SpamPropertyModel *modelPropertyCode;
@property (strong, nonatomic) SpamCategoryModel *modelCategoryCode;

@end

@implementation SpamCodeCreateManager

- (void)startAddSpamCode {
    _modelPropertyCode = [[SpamPropertyModel alloc] initWithPropertyNameLength:[FileMixedHelper sharedHelper].modelSpamCode.lengthMFilePropertyName
                                                                   PropertyNum:[FileMixedHelper sharedHelper].modelSpamCode.numMFileProperty];
    
    _modelCategoryCode = [[SpamCategoryModel alloc] initWithPropertyNameLength:[FileMixedHelper sharedHelper].modelSpamCode.lengthCategoryPropertyName
                                                                   PropertyNum:[FileMixedHelper sharedHelper].modelSpamCode.numCategoryProperty
                                                               andMethodLength:[FileMixedHelper sharedHelper].modelSpamCode.lengthCategoryMethodName
                                                                  andMethodNum:[FileMixedHelper sharedHelper].modelSpamCode.numCategoryMethod];
    
    @autoreleasepool {
        
        if ([FileMixedHelper sharedHelper].arrSonPath.count > 0){
            for (NSString *path in [FileMixedHelper sharedHelper].arrSonPath) {
                // 遍历全部文件，准备添加垃圾代码
                [self addSpamCodeWithSourceCodeFilePath:path];
            }
        } else {
            // 遍历全部文件，准备添加垃圾代码
            [self addSpamCodeWithSourceCodeFilePath:[FileMixedHelper sharedHelper].sourceCodePath];
        }
    }
}

// 遍历全部文件
- (void)addSpamCodeWithSourceCodeFilePath:(NSString *)sourceCodeDir {
    NSString *projContentPath = [NSString stringWithFormat:@"%@/project.pbxproj",[FileMixedHelper sharedHelper].projPath];
    NSMutableString *projectContent = [NSMutableString stringWithContentsOfFile:projContentPath
                                                                       encoding:NSUTF8StringEncoding
                                                                          error:nil];
    
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
                [self addSpamCodeWithSourceCodeFilePath:path];
            } else {
                NSLog(@"忽略");
            }
            continue;
        }
        
        NSString *fileName = filePath.lastPathComponent.stringByDeletingPathExtension;
        NSString *fileExtension = filePath.pathExtension;
        
        // 如果当前文件未引入工程，则不进行垃圾代码的添加
        if (![projectContent containsString:fileName]) {
            break;
        }
        
        // 如果当前存在.h.m文件且不是Category
        if ([fileExtension isEqualToString:@"h"] && [files containsObject:[fileName stringByAppendingPathExtension:@"m"]] && [FileMixedHelper isNeedChangedFileName:fileName] && ![fileName containsString:@"+"]) {
            
            // 在.m文件中 添加 垃圾代码
            [self addSpamCodeInMFileWithClassName:fileName andSourceCodePath:sourceCodeDir];
            
            if ([FileMixedHelper sharedHelper].spamCodePath.length > 0) {
                [self addSpamCategoryFileWithClassName:fileName andSourceCodeDir:sourceCodeDir];
            }
        }
    }
}

#pragma mark -  添加 垃圾代码
// 修改.m 文件（添加 垃圾属性 及 垃圾category的import）
- (void)addSpamCodeInMFileWithClassName:(NSString *)className andSourceCodePath:(NSString *)sourceCodeDir {
    
    // .m文件中存在实现
    NSString *mFilePath = [[sourceCodeDir stringByAppendingPathComponent:className] stringByAppendingPathExtension:@"m"];
    NSError *mError = nil;
    NSMutableString *mFileContent = [NSMutableString stringWithContentsOfFile:mFilePath encoding:NSUTF8StringEncoding error:&mError];
    
    NSString *newMFileContent = [mFileContent copy];
    
    // 如果当前category文件不为空 则需要添加category文件的import
    if (_modelCategoryCode && [FileMixedHelper sharedHelper].spamCodePath.length > 0) {
        newMFileContent = [self addCategoryImportWithMFileContent:newMFileContent
                                                     andClassName:className
                                                  andCategoryName:[FileMixedHelper sharedHelper].modelSpamCode.categoryName];
    }
    
    if (_modelPropertyCode) {
        // 添加 interface 中的垃圾属性
        NSString *newInterfaceCode = [self addSpamPropertyCodeWithFileName:className andMFileContent:newMFileContent];
        if (newInterfaceCode.length > 0) {
            newMFileContent = newInterfaceCode;

            // 添加 垃圾属性的 统一调用方法
            NSString *newCallMethodCode = [self addCallMethodWithFileName:className andMFileContent:newInterfaceCode];
            if (newCallMethodCode.length > 0) {
                newMFileContent = newCallMethodCode;
            }

            // 添加 重写 垃圾属性的 set 方法
            NSString *newSetMethodCode = [self addSpamSetMethodWithFileName:className andMFileContent:newMFileContent];
            if (newSetMethodCode.length > 0) {
                newMFileContent = newSetMethodCode;
            }
        }
    }
    
    if (newMFileContent.length > 0) {
        NSError *error = nil;
        NSString *savePath = [NSString stringWithFormat:@"%@/%@.m",sourceCodeDir,className];
        [newMFileContent writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            printf("保存文件 %s 失败：%s\n", sourceCodeDir.UTF8String, error.localizedDescription.UTF8String);
        } else {
            NSLog(@"保存成功 ：%@",savePath);
        }
    }
}

// 创建并保存 Category .h和.m 文件
- (void)addSpamCategoryFileWithClassName:(NSString *)className andSourceCodeDir:(NSString *)sourceCodeDir {
    
    // 创建.h文件
    NSMutableString *hFileContent = [NSMutableString stringWithFormat:@"\n#import \"%@.h\"\n\n@interface %@ (%@)\n%@\n%@\n@end",className,className,[FileMixedHelper sharedHelper].modelSpamCode.categoryName,_modelCategoryCode.propertyCode,_modelCategoryCode.hMethodCode];
    
    NSMutableString *mFileContent = [NSMutableString stringWithFormat:@"\n#import \"%@+%@.h\"\n\n@implementation %@ (%@)\n%@\n%@\n@end",className,[FileMixedHelper sharedHelper].modelSpamCode.categoryName,className,[FileMixedHelper sharedHelper].modelSpamCode.categoryName,_modelCategoryCode.mMethodCode,_modelCategoryCode.callMethodCode];
    
    
    if (hFileContent.length > 0) {
        NSError *error = nil;
        NSString *savePath = [NSString stringWithFormat:@"%@%@+%@.h",[FileMixedHelper sharedHelper].spamCodePath,className,[FileMixedHelper sharedHelper].modelSpamCode.categoryName];
        [hFileContent writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"hFileConten 保存文件 失败：%@\n",error.localizedDescription);
        } else {
            NSLog(@"保存成功 ：%@",savePath);
        }
    }
    
    if (mFileContent.length > 0) {
        NSError *error = nil;
        NSString *savePath = [NSString stringWithFormat:@"%@/%@+%@.m",[FileMixedHelper sharedHelper].spamCodePath,className,[FileMixedHelper sharedHelper].modelSpamCode.categoryName];
        [mFileContent writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            printf("mFileContent 保存文件 %s 失败：%s\n", sourceCodeDir.UTF8String, error.localizedDescription.UTF8String);
        } else {
            NSLog(@"保存成功 ：%@",savePath);
        }
    }
}

#pragma mark - Private
// 添加 垃圾属性
- (NSString *)addSpamPropertyCodeWithFileName:(NSString *)className andMFileContent:(NSString *)mFileContent {
    // 添加 @interface中的属性
    NSString *mRegularExpression = [NSString stringWithFormat:@"@interface %@(.*\n*)*?@end",className];// (?<=[)])\\S+(?=.+[{])
    NSRegularExpression *mExpression = [NSRegularExpression regularExpressionWithPattern:mRegularExpression options:NSRegularExpressionAnchorsMatchLines|NSRegularExpressionUseUnixLineSeparators error:nil];
    NSArray<NSTextCheckingResult *> *mMatches = [mExpression matchesInString:mFileContent options:0 range:NSMakeRange(0, mFileContent.length)];
    
    if ([mMatches count] == 1) {
        NSRange range = mMatches[0].range;
        
        NSString *interfaceContent = [mFileContent substringWithRange:range];
        if ([interfaceContent hasSuffix:@"@end"] ) {
            
            NSString *newInterfaceContent = [NSString stringWithFormat:@"\n\n%@%@\n@end",[interfaceContent substringToIndex:interfaceContent.length-4],_modelPropertyCode.propertyCode];
            // = [interfaceContent stringByReplacingOccurrencesOfString:@"@end" withString:newPropertyCode];
            
            NSString *newMFileContent = [mFileContent stringByReplacingOccurrencesOfString:interfaceContent withString:newInterfaceContent];
            return newMFileContent;
        }
    }
    return @"";
}

// 重写 垃圾属性 set方法
- (NSString *)addSpamSetMethodWithFileName:(NSString *)className andMFileContent:(NSString *)mFileContent {
    // 添加 @interface中的属性
    NSString *mRegularExpression = [NSString stringWithFormat:@"@implementation.*%@(.*\n*)*?@end",className];// (?<=[)])\\S+(?=.+[{])
    NSRegularExpression *mExpression = [NSRegularExpression regularExpressionWithPattern:mRegularExpression options:NSRegularExpressionAnchorsMatchLines|NSRegularExpressionUseUnixLineSeparators error:nil];
    NSArray<NSTextCheckingResult *> *mMatches = [mExpression matchesInString:mFileContent options:0 range:NSMakeRange(0, mFileContent.length)];
    
    if ([mMatches count] == 1) {
        NSRange range = mMatches[0].range;
        
        NSString *implementationContent = [mFileContent substringWithRange:range];
        if ([implementationContent hasSuffix:@"@end"]) {
            
            NSString *newInterfaceContent = [implementationContent stringByReplacingOccurrencesOfString:@"@end" withString:[NSString stringWithFormat:@"%@\n@end",_modelPropertyCode.setMethodCode]];
            
            NSString *newMFileContent = [mFileContent stringByReplacingOccurrencesOfString:implementationContent withString:newInterfaceContent];
            return newMFileContent;
        }
    }
    return @"";
}

// 垃圾属性 初始化方法
- (NSString *)addCallMethodWithFileName:(NSString *)className andMFileContent:(NSString *)mFileContent {
    // 添加 @interface中的属性
    NSString *mRegularExpression = [NSString stringWithFormat:@"@implementation.*%@(.*\n*)*?@end",className];// (?<=[)])\\S+(?=.+[{])
    NSRegularExpression *mExpression = [NSRegularExpression regularExpressionWithPattern:mRegularExpression options:NSRegularExpressionAnchorsMatchLines|NSRegularExpressionUseUnixLineSeparators error:nil];
    NSArray<NSTextCheckingResult *> *mMatches = [mExpression matchesInString:mFileContent options:0 range:NSMakeRange(0, mFileContent.length)];
    
    if ([mMatches count] == 1) {
        NSRange range = mMatches[0].range;
        
        NSString *implementationContent = [mFileContent substringWithRange:range];
        if ([implementationContent hasSuffix:@"@end"]) {
            
            // 如果当前没有 jjc_callAllAddProperty 方法，则代表第一次添加垃圾代码
            if (![implementationContent containsString:@"(void)jjc_callAllAddProperty"]) {
                NSString *newCallMethod = [NSString stringWithFormat:@"- (void)jjc_callAllAddProperty { \n%@\n}\n@end",_modelPropertyCode.callMethodCode];
                
                NSString *newImplementationContent = [implementationContent stringByReplacingOccurrencesOfString:@"@end" withString:newCallMethod];
                
                NSString *newMFileContent = [mFileContent stringByReplacingOccurrencesOfString:implementationContent withString:newImplementationContent];
                return newMFileContent;
            } else {
                NSString *newInitMethod = [NSString stringWithFormat:@"- (void)jjc_callAllAddProperty { \n%@ ",_modelPropertyCode.callMethodCode];
                NSString *newImplementationContent = [implementationContent stringByReplacingOccurrencesOfString:@"- (void)jjc_callAllAddProperty {" withString:newInitMethod];
                NSString *newMFileContent = [mFileContent stringByReplacingOccurrencesOfString:implementationContent withString:newImplementationContent];
                return newMFileContent;
            }
        }
    }
    return @"";
}

// 添加 .m文件中对 垃圾Category的import
- (NSString *)addCategoryImportWithMFileContent:(NSString *)mFileContent
                                   andClassName:(NSString *)className
                                andCategoryName:(NSString *)categoryFileName {
    
    if (![mFileContent containsString:[NSString stringWithFormat:@"#import \"%@+%@.h\"",className,categoryFileName]]) {
        // 添加 interface 中的垃圾属性
        NSString *mRegularExpression = [NSString stringWithFormat:@"^#import\\s*\"%@\\.h\"$",className];
        NSRegularExpression *mExpression = [NSRegularExpression regularExpressionWithPattern:mRegularExpression options:NSRegularExpressionAnchorsMatchLines|NSRegularExpressionUseUnixLineSeparators error:nil];
        NSArray<NSTextCheckingResult *> *mMatches = [mExpression matchesInString:mFileContent options:0 range:NSMakeRange(0, mFileContent.length)];
        
        if ([mMatches count] == 1) {
            NSRange range = mMatches[0].range;
            
            NSString *oldImportContent = [mFileContent substringWithRange:range];
            NSString *newImportContent = [NSString stringWithFormat:@"%@\n#import \"%@+%@.h\"",oldImportContent,className,categoryFileName];
            
            NSString *newMFileContent = [mFileContent stringByReplacingCharactersInRange:range withString:newImportContent];
            
            return newMFileContent;
        }
    }
    return mFileContent;
}

@end
