//
//  DeleteManager.m
//  CodeMixTool
//
//  Created by 贾辰 on 2019/7/1.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import "DeleteManager.h"
#import "FileMixedHelper.h"

@implementation DeleteManager

- (void)startDeleteWithFilePath:(NSString *)sourceCodeDirectory
                      ignoreArr:(NSArray<NSString *> *)ignoreDirNames {
    @autoreleasepool {
        NSFileManager *fm = [NSFileManager defaultManager];
        NSArray<NSString *> *files = [fm contentsOfDirectoryAtPath:sourceCodeDirectory error:nil];
        BOOL isDirectory;
        for (NSString *fileName in files) {
            if ([ignoreDirNames containsObject:fileName]) continue;
            NSString *filePath = [sourceCodeDirectory stringByAppendingPathComponent:fileName];
            if ([fm fileExistsAtPath:filePath isDirectory:&isDirectory] && isDirectory) {
                [self startDeleteWithFilePath:filePath
                                    ignoreArr:ignoreDirNames];
                continue;
            }
            if (![fileName hasSuffix:@".h"] && ![fileName hasSuffix:@".m"] && ![fileName hasSuffix:@".mm"] && ![fileName hasSuffix:@".swift"]) continue;
            NSMutableString *fileContent = [NSMutableString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
            
            // 删除 换行符
            if (_isDeleteLineBreak) {
                [[FileMixedHelper sharedHelper] regularReplacement:fileContent regularExpression:@"/\\*{1,2}[\\s\\S]*?\\*/" newString:@""];
                [[FileMixedHelper sharedHelper] regularReplacement:fileContent regularExpression:@"^\\s*\\n" newString:@""];
                
            }
            
            // 删除 注释
            if (_isDeleteAnnotation) {
                [[FileMixedHelper sharedHelper] regularReplacement:fileContent regularExpression:@"([^:/])//.*" newString:@"\\1"];
                [[FileMixedHelper sharedHelper] regularReplacement:fileContent regularExpression:@"^//.*" newString:@""]; // 删除 //
            }
            
            // 删除 NSLog
            if (_isDeleteNSLog) {
                // 删除NSLog
                [[FileMixedHelper sharedHelper] regularReplacement:fileContent regularExpression:@"NSLog[(]@.*;" newString:@""];
                
            }
            
            // 是否需要整合文件夹
            NSError *error;
            if (_codeFilePath) {
                NSString *newPath = [NSString stringWithFormat:@"%@/%@",_codeFilePath,fileName];
                [fileContent writeToFile:newPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
            } else {
                [fileContent writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
            }

            if (error) {
                [FileMixedHelper showAlert:@"删除错误" andDetailString:error.localizedDescription];
            }
        }
    }
}

@end
