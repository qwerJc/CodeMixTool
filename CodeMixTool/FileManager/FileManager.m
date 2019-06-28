//
//  FileManager.m
//  CodeMixTool
//
//  Created by 贾辰 on 2019/4/2.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import "FileManager.h"
#import "FileMixedHelper.h"
#import "MixClassNameManager.h"
#import "SpamCodeCreateManager.h"

@interface FileManager()
@property (strong, nonatomic) NSString *codeFilePath;               // 代码文件的总路径
@property (strong, nonatomic) NSString *projPath;                   // 工程路径(.xcodeproj路径)
@property (strong, nonatomic) NSString *sonPath;                    // 子文件夹的路径

@property (strong, nonatomic) NSArray<NSString *> *arrIgnoreDirNames;   // 忽略文件夹名 数组

@property (strong, nonatomic) NSMutableSet *categoryFileNameSet;        // category所拓展的类名

@property (strong, nonatomic) MixClassNameManager *managerMixClassName;

@property (strong, nonatomic) SpamCodeCreateManager *managerSpamCode;
@end

@implementation FileManager

- (void)showAlert:(NSString *)string andDetailString:(NSString *)detailString {
    NSLog(@"%@ \n %@",string, detailString);
}

- (void)setupWithXcodeProjPath:(NSString *)projPath andCodeFilePath:(NSString *)codePath andTask:(EnumTaskType)task{
    if (!projPath ||  projPath.length <= 1) {
        [self showAlert:@"请设置工程路径" andDetailString:nil];
        return ;
    } else {
        _projPath = [NSString stringWithFormat:@"%@/project.pbxproj",projPath];
    }

    if (!codePath ||  codePath.length <= 1) {
        [self showAlert:@"请设置源码文件路径" andDetailString:nil];
        return ;
    } else {
        _codeFilePath = codePath;
    }

    if (task < 1) {
        [self showAlert:@"请选择任务" andDetailString:nil];;
        return ;
    }
}

#pragma mark - 删除无用代码
- (void)deleteUselessCodeWithLineBreak:(BOOL)isDelLineBreak andAnnotation:(BOOL)isDelAnnotation andNSLog:(BOOL)isDelNSLog {
    @autoreleasepool {
        [self deleteCodeWithFilePath:_codeFilePath
                           ignoreArr:_arrIgnoreDirNames
                     deleteLineBreak:isDelLineBreak
                    deleteAnnotation:isDelAnnotation
                         deleteNSLog:isDelNSLog];
    }
    NSLog(@"删除完成");
}

/**
 删除无用代码
 
 @param sourceCodeDirectory 文件夹路径
 @param ignoreDirNames 忽略文件名集合
 
 @param isDelLineBreak 是否删除换行符
 @param isDelAnnotation 是否删除注释
 @param isDelNSLog 是否删除NSLog
 */
- (void)deleteCodeWithFilePath:(NSString *)sourceCodeDirectory
                     ignoreArr:(NSArray<NSString *> *)ignoreDirNames
               deleteLineBreak:(BOOL)isDelLineBreak
              deleteAnnotation:(BOOL)isDelAnnotation
                   deleteNSLog:(BOOL)isDelNSLog {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray<NSString *> *files = [fm contentsOfDirectoryAtPath:sourceCodeDirectory error:nil];
    BOOL isDirectory;
    for (NSString *fileName in files) {
        if ([ignoreDirNames containsObject:fileName]) continue;
        NSString *filePath = [sourceCodeDirectory stringByAppendingPathComponent:fileName];
        if ([fm fileExistsAtPath:filePath isDirectory:&isDirectory] && isDirectory) {
            [self deleteCodeWithFilePath:filePath
                               ignoreArr:ignoreDirNames
                         deleteLineBreak:isDelLineBreak
                        deleteAnnotation:isDelAnnotation
                             deleteNSLog:isDelNSLog];
            continue;
        }
        if (![fileName hasSuffix:@".h"] && ![fileName hasSuffix:@".m"] && ![fileName hasSuffix:@".mm"] && ![fileName hasSuffix:@".swift"]) continue;
        NSMutableString *fileContent = [NSMutableString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        
        if (isDelLineBreak) {
            [[FileMixedHelper sharedHelper] regularReplacement:fileContent regularExpression:@"/\\*{1,2}[\\s\\S]*?\\*/" newString:@""];
            [[FileMixedHelper sharedHelper] regularReplacement:fileContent regularExpression:@"^\\s*\\n" newString:@""];
            
        }
        
        if (isDelAnnotation) {
            [[FileMixedHelper sharedHelper] regularReplacement:fileContent regularExpression:@"([^:/])//.*" newString:@"\\1"];
            [[FileMixedHelper sharedHelper] regularReplacement:fileContent regularExpression:@"^//.*" newString:@""]; // 删除 //
        }
        
        if (isDelNSLog) {
            // 删除NSLog
            [[FileMixedHelper sharedHelper] regularReplacement:fileContent regularExpression:@"NSLog[(]@.*;" newString:@""];

        }
        
        NSError *error;
        [fileContent writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            [self showAlert:@"删除错误" andDetailString:error.localizedDescription];
        }
    }
}

#pragma mark - 混淆类名
- (void)randomClassName {
    self.managerMixClassName = [[MixClassNameManager alloc] init];
    
    [self.managerMixClassName setRandomClassNameWithLengthRange:NSMakeRange(8, 15)];
    [self.managerMixClassName startMixedWithCodeFilePath:_codeFilePath andProjPath:_projPath];
}

#pragma mark - 添加垃圾代码
- (void)addSpamCode {
    self.managerSpamCode = [[SpamCodeCreateManager alloc] init];

    [self.managerSpamCode setSpamPropertyNum:20];
    [self.managerSpamCode startMakeSpamCodeWithCodeFilePath:_codeFilePath andProjPath:_projPath];
}
@end
