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

@property (strong, nonatomic) NSString *categoryFileName;
@property (strong, nonatomic) NSString *outPath;
@end

@implementation SpamCodeCreateManager

#pragma mark - 设置 每个类中添加 垃圾属性的数量
- (void)setSpamPropertyNum:(NSRange)rangePropertyNum {
    NSRange propertyNameLength = NSMakeRange(15, 15);
    
    _modelPropertyCode = [[SpamPropertyModel alloc] initWithPropertyNameLength:propertyNameLength
                                                                   PropertyNum:rangePropertyNum];
}

- (void)setSpamCategoryPropertyNum:(NSRange)rangePropertyNum andMethodNum:(NSRange)rangeMethodNum {
//    _categoryFileName = [NSString stringWithFormat:@"JJC%@",[FileMixedHelper randomString:10]];
    _categoryFileName = @"qwerJJC";
    
    NSRange propertyNameLength = NSMakeRange(20, 20);
    NSRange methodNameLength = NSMakeRange(20, 30);
    
    _modelCategoryCode = [[SpamCategoryModel alloc] initWithPropertyNameLength:propertyNameLength
                                                                   PropertyNum:rangePropertyNum
                                                               andMethodLength:methodNameLength
                                                                  andMethodNum:rangeMethodNum];
}
#pragma mark - 入口方法
- (void)startMakeSpamCodeWithCodeFilePath:(NSString *)codeFilePath andProjPath:(NSString *)projPath {
    _outPath = [NSString stringWithFormat:@"%@/SpamCode",codeFilePath];
    
    @autoreleasepool {
        // 打开工程文件
        NSError *error = nil;
        NSMutableString *projectContent = [NSMutableString stringWithContentsOfFile:projPath encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            printf("JJC-打开工程文件 %s 失败：%s\n", projPath.UTF8String, error.localizedDescription.UTF8String);
            return ;
        }
        
        // 遍历全部文件,获取category文件
        [[FileMixedHelper sharedHelper] getCategoryFileClassSet:projectContent
                                               andSourceCodeDir:codeFilePath
                                                   andIgnoreDir:nil];
        
        // 遍历全部文件，准备添加垃圾代码
        [self traverseAllFileWithProjectContent:projectContent andCodeFilePath:codeFilePath];
    }
}

// 遍历全部文件
- (void)traverseAllFileWithProjectContent:(NSMutableString *)projectContent andCodeFilePath:(NSString *)sourceCodeDir {
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
                [self traverseAllFileWithProjectContent:projectContent andCodeFilePath:path];
            } else {
                NSLog(@"忽略");
            }
            continue;
        }
        
        NSString *fileName = filePath.lastPathComponent.stringByDeletingPathExtension;
        NSString *fileExtension = filePath.pathExtension;
        
        // 如果当前存在.h.m文件且不是Category
        if ([fileExtension isEqualToString:@"h"] && [files containsObject:[fileName stringByAppendingPathExtension:@"m"]] && [FileMixedHelper isNeedChangedFileName:fileName] && ![fileName containsString:@"+"]) {
            
            // 在.m文件中 添加 垃圾代码
            [self addSpamCodeInMFileWithClassName:fileName andSourceCodePath:sourceCodeDir];
            
            [self addSpamCategoryFileWithClassName:fileName andSourceCodeDir:sourceCodeDir];
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
    if (_modelCategoryCode) {
        newMFileContent = [self addCategoryImportWithMFileContent:newMFileContent
                                                     andClassName:className
                                                  andCategoryName:_categoryFileName];
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
    NSMutableString *hFileContent = [NSMutableString stringWithFormat:@"\n#import \"%@.h\"\n\n@interface %@ (%@)\n%@\n%@\n@end",className,className,_categoryFileName,_modelCategoryCode.propertyCode,_modelCategoryCode.hMethodCode];
    
    NSMutableString *mFileContent = [NSMutableString stringWithFormat:@"\n#import \"%@+%@.h\"\n\n@implementation %@ (%@)\n%@\n%@\n@end",className,_categoryFileName,className,_categoryFileName,_modelCategoryCode.mMethodCode,_modelCategoryCode.callMethodCode];
    
    
    if (hFileContent.length > 0) {
        NSError *error = nil;
        NSString *savePath = [NSString stringWithFormat:@"%@/%@+%@.h",_outPath,className,_categoryFileName];
        [hFileContent writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"hFileConten 保存文件 失败：%@\n",error.localizedDescription);
        } else {
            NSLog(@"保存成功 ：%@",savePath);
        }
    }
    
    if (mFileContent.length > 0) {
        NSError *error = nil;
        NSString *savePath = [NSString stringWithFormat:@"%@/%@+%@.m",_outPath,className,_categoryFileName];
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
            
            NSString *newInterfaceContent = [NSString stringWithFormat:@"%@%@\n@end",[interfaceContent substringToIndex:interfaceContent.length-4],_modelPropertyCode.propertyCode];
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
