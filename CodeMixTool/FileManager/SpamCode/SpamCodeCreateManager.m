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
@property (strong, nonatomic) NSArray<SpamPropertyModel *> *arrSpamPropertyCode;
@property (strong, nonatomic) SpamCategoryModel * modelCategoryCode;

@property (strong, nonatomic) NSArray<SpamPropertyModel *> *arrSpamCategoryPropertyCode;
@property (strong, nonatomic) NSArray<SpamPropertyModel *> *arrSpamCategoryMethodCode;
@end

@implementation SpamCodeCreateManager

#pragma mark - 设置 每个类中添加 垃圾属性的数量
- (void)setSpamPropertyNum:(NSUInteger)num {
    NSMutableArray *marr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i =0; i<num; i++) {
        // 创建随机的model
        NSUInteger nameLength = arc4random()%20+15;
        SpamPropertyModel *model = [[SpamPropertyModel alloc] initWithPropertyNameLength:nameLength];
        
        [marr addObject:model];
    }
    _arrSpamPropertyCode = [marr copy];
}

- (void)setSpamCategoryPropertyNum:(NSRange)rangePropertyNum andMethodNum:(NSRange)rangeMethodNum {
    NSRange propertyNameLength = NSMakeRange(20, 20);
    NSRange methodNameLength = NSMakeRange(20, 30);
    
    _modelCategoryCode = [[SpamCategoryModel alloc] initWithPropertyNameLength:propertyNameLength
                                                                   PropertyNum:rangePropertyNum
                                                               andMethodLength:methodNameLength
                                                                  andMethodNum:rangeMethodNum];
}
#pragma mark - 创建垃圾代码 入口方法
- (void)startMakeSpamCodeWithCodeFilePath:(NSString *)codeFilePath andProjPath:(NSString *)projPath {
    
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
        
        // 添加垃圾属性
//        [self makeSpamPropertyCodeWithCodeFilePath:projectContent andCodeFilePath:codeFilePath];
        
        // 添加 Category
        NSString *outPath = [NSString stringWithFormat:@"%@/SpamCode",codeFilePath];
        [self makeSpamClassCodeWithCodeFilePath:projectContent andCodeFilePath:codeFilePath andOutPath:outPath];
        
        [projectContent writeToFile:projPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}
#pragma mark - 创建垃圾 Category
- (void)makeSpamClassCodeWithCodeFilePath:(NSMutableString *)projectContent andCodeFilePath:(NSString *)sourceCodeDir andOutPath:(NSString *)outPath{
    
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
                [self makeSpamClassCodeWithCodeFilePath:projectContent andCodeFilePath:path andOutPath:outPath];
            } else {
                NSLog(@"忽略");
            }
            continue;
        }
        
        NSString *fileName = filePath.lastPathComponent.stringByDeletingPathExtension;
        NSString *fileExtension = filePath.pathExtension;
        
        // 如果当前存在.h.m文件且不是Category
        if ([fileExtension isEqualToString:@"h"] && [files containsObject:[fileName stringByAppendingPathExtension:@"m"]] && [FileMixedHelper isNeedChangedFileName:fileName] && ![fileName containsString:@"+"]) {
            
            [self createSpamCategoryClassCodeWithClassName:fileName andSourceCodeDir:sourceCodeDir andOutputPath:outPath];
        }
    }
}

- (void)addMFileCategoryImportWithMFilePath:(NSString *)mFilePath
                               andClassName:(NSString *)className
                            andCategoryName:(NSString *)categoryFileName {
    
    // .m文件中存在实现
    NSError *mError = nil;
    NSMutableString *mFileContent = [NSMutableString stringWithContentsOfFile:mFilePath encoding:NSUTF8StringEncoding error:&mError];
    
    
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
            
            NSError *error = nil;
            NSString *savePath = [NSString stringWithFormat:@"%@",mFilePath];
            [newMFileContent writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                printf("引用垃圾category文件 保存失败 %@",error.localizedDescription.UTF8String);
                abort();
            } else {
                NSLog(@"引用垃圾category文件 保存成功 ：%@",savePath);
            }
        }
    }
}

- (void)createSpamCategoryClassCodeWithClassName:(NSString *)className andSourceCodeDir:(NSString *)sourceCodeDir andOutputPath:(NSString *)outPath {
    NSString *categoryName = @"qwerJJC";
    
    [self addMFileCategoryImportWithMFilePath:[NSString stringWithFormat:@"%@/%@.m",sourceCodeDir,className]
                                 andClassName:className
                              andCategoryName:categoryName];
    
    // 创建.h文件
    NSMutableString *hFileContent = [NSMutableString stringWithFormat:@"\n#import \"%@.h\"\n\n@interface %@ (%@)\n%@\n%@\n@end",className,className,categoryName,_modelCategoryCode.propertyCode,_modelCategoryCode.hMethodCode];

    NSMutableString *mFileContent = [NSMutableString stringWithFormat:@"\n#import \"%@+%@.h\"\n\n@implementation %@ (%@)\n%@\n%@\n@end",className,categoryName,className,categoryName,_modelCategoryCode.mMethodCode,_modelCategoryCode.callMethodCode];


    if (hFileContent.length > 0) {
        NSError *error = nil;
        NSString *savePath = [NSString stringWithFormat:@"%@/%@+%@.h",outPath,className,categoryName];
        [hFileContent writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            printf("保存文件 %s 失败：%s\n", sourceCodeDir.UTF8String, error.localizedDescription.UTF8String);
            abort();
        } else {
            NSLog(@"保存成功 ：%@",savePath);
        }
    }

    if (mFileContent.length > 0) {
        NSError *error = nil;
        NSString *savePath = [NSString stringWithFormat:@"%@/%@+%@.m",outPath,className,categoryName];
        [mFileContent writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            printf("保存文件 %s 失败：%s\n", sourceCodeDir.UTF8String, error.localizedDescription.UTF8String);
            abort();
        } else {
            NSLog(@"保存成功 ：%@",savePath);
        }
    }
    
}

#pragma mark - 添加垃圾属性
- (void)makeSpamPropertyCodeWithCodeFilePath:(NSMutableString *)projectContent andCodeFilePath:(NSString *)sourceCodeDir {
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
                [self makeSpamPropertyCodeWithCodeFilePath:projectContent andCodeFilePath:path];
            } else {
                NSLog(@"忽略");
            }
            continue;
        }
        
        NSString *fileName = filePath.lastPathComponent.stringByDeletingPathExtension;
        NSString *fileExtension = filePath.pathExtension;
        
        // 如果当前存在.h.m文件且不是Category
        if ([fileExtension isEqualToString:@"h"] && [files containsObject:[fileName stringByAppendingPathExtension:@"m"]] && [FileMixedHelper isNeedChangedFileName:fileName]) {
            
            [self createSpamCodeWithClassName:fileName andSourceCodePath:sourceCodeDir];
        }
    }
}

- (void)createSpamCodeWithClassName:(NSString *)className andSourceCodePath:(NSString *)sourceCodeDir {
    
    NSString *newMFileContent;
    
    // .m文件中存在实现
    NSString *mFilePath = [[sourceCodeDir stringByAppendingPathComponent:className] stringByAppendingPathExtension:@"m"];
    NSError *mError = nil;
    NSMutableString *mFileContent = [NSMutableString stringWithContentsOfFile:mFilePath encoding:NSUTF8StringEncoding error:&mError];
    
    // 添加 interface 中的垃圾属性
    NSString *newInterfaceCode = [self addSpamPropertyCodeWithFileName:className andMFileContent:mFileContent];
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
    
    if (newMFileContent.length > 0) {
        NSError *error = nil;
        NSString *savePath = [NSString stringWithFormat:@"%@/%@.m",sourceCodeDir,className];
        [newMFileContent writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            printf("保存文件 %s 失败：%s\n", sourceCodeDir.UTF8String, error.localizedDescription.UTF8String);
            abort();
        } else {
            NSLog(@"保存成功 ：%@",savePath);
        }
    }

}

- (NSString *)addSpamPropertyCodeWithFileName:(NSString *)className andMFileContent:(NSMutableString *)mFileContent {
    // 添加 @interface中的属性
    NSString *mRegularExpression = [NSString stringWithFormat:@"@interface %@(.*\n*)*?@end",className];// (?<=[)])\\S+(?=.+[{])
    NSRegularExpression *mExpression = [NSRegularExpression regularExpressionWithPattern:mRegularExpression options:NSRegularExpressionAnchorsMatchLines|NSRegularExpressionUseUnixLineSeparators error:nil];
    NSArray<NSTextCheckingResult *> *mMatches = [mExpression matchesInString:mFileContent options:0 range:NSMakeRange(0, mFileContent.length)];
    
    if ([mMatches count] == 1) {
        NSRange range = mMatches[0].range;
        
        NSString *interfaceContent = [mFileContent substringWithRange:range];
        if ([interfaceContent hasSuffix:@"@end"] ) {
            
            NSMutableString *newPropertyCode = [[NSMutableString alloc] initWithString:@""];
            
            for (SpamPropertyModel *model in _arrSpamPropertyCode) {
                [newPropertyCode appendString:model.propertyCode];
            }
            [newPropertyCode appendString:@"\n@end"];
            
            NSString *newInterfaceContent = [NSString stringWithFormat:@"%@%@",[interfaceContent substringToIndex:interfaceContent.length-4],newPropertyCode];
            // = [interfaceContent stringByReplacingOccurrencesOfString:@"@end" withString:newPropertyCode];
            
            NSString *newMFileContent = [mFileContent stringByReplacingOccurrencesOfString:interfaceContent withString:newInterfaceContent];
            return newMFileContent;
        }
    }
    return @"";
}

- (NSString *)addSpamSetMethodWithFileName:(NSString *)className andMFileContent:(NSString *)mFileContent {
    // 添加 @interface中的属性
    NSString *mRegularExpression = [NSString stringWithFormat:@"@implementation.*%@(.*\n*)*?@end",className];// (?<=[)])\\S+(?=.+[{])
    NSRegularExpression *mExpression = [NSRegularExpression regularExpressionWithPattern:mRegularExpression options:NSRegularExpressionAnchorsMatchLines|NSRegularExpressionUseUnixLineSeparators error:nil];
    NSArray<NSTextCheckingResult *> *mMatches = [mExpression matchesInString:mFileContent options:0 range:NSMakeRange(0, mFileContent.length)];
    
    if ([mMatches count] == 1) {
        NSRange range = mMatches[0].range;
        
        NSString *implementationContent = [mFileContent substringWithRange:range];
        if ([implementationContent hasSuffix:@"@end"]) {
            
            NSMutableString *newSetMethodCode = [NSMutableString stringWithString:@""];
            for (SpamPropertyModel *model in _arrSpamPropertyCode) {
                [newSetMethodCode appendString:model.setMethodCode];
            }
            [newSetMethodCode appendString:@"\n@end"];
            
            NSString *newInterfaceContent = [implementationContent stringByReplacingOccurrencesOfString:@"@end" withString:newSetMethodCode];
            
            NSString *newMFileContent = [mFileContent stringByReplacingOccurrencesOfString:implementationContent withString:newInterfaceContent];
            return newMFileContent;
        }
    }
    return @"";
}

- (NSString *)addCallMethodWithFileName:(NSString *)className andMFileContent:(NSString *)mFileContent {
    // 添加 @interface中的属性
    NSString *mRegularExpression = [NSString stringWithFormat:@"@implementation.*%@(.*\n*)*?@end",className];// (?<=[)])\\S+(?=.+[{])
    NSRegularExpression *mExpression = [NSRegularExpression regularExpressionWithPattern:mRegularExpression options:NSRegularExpressionAnchorsMatchLines|NSRegularExpressionUseUnixLineSeparators error:nil];
    NSArray<NSTextCheckingResult *> *mMatches = [mExpression matchesInString:mFileContent options:0 range:NSMakeRange(0, mFileContent.length)];
    
    if ([mMatches count] == 1) {
        NSRange range = mMatches[0].range;
        
        NSString *implementationContent = [mFileContent substringWithRange:range];
        if ([implementationContent hasSuffix:@"@end"]) {
            
            NSMutableString *callMethods = [NSMutableString stringWithString:@""];
            for (SpamPropertyModel *model in _arrSpamPropertyCode) {
                [callMethods appendString:[NSString stringWithFormat:@"    %@",model.callMethodCode]];
            }
            
            // 如果当前没有 jjc_callAllAddProperty 方法，则代表第一次添加垃圾代码
            if (![implementationContent containsString:@"(void)jjc_callAllAddProperty"]) {
                NSString *newCallMethod = [NSString stringWithFormat:@"- (void)jjc_callAllAddProperty { \n%@\n}\n@end",callMethods];
                
                NSString *newImplementationContent = [implementationContent stringByReplacingOccurrencesOfString:@"@end" withString:newCallMethod];
                
                NSString *newMFileContent = [mFileContent stringByReplacingOccurrencesOfString:implementationContent withString:newImplementationContent];
                return newMFileContent;
            }

        }
    }
    return @"";
}


#pragma mark - Private

@end
