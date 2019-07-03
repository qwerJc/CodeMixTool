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

- (void)startDelete {
    @autoreleasepool {
        [self deleteWithWithFilePath:[FileMixedHelper sharedHelper].sourceCodePath];
    }
}

- (void)deleteWithWithFilePath:(NSString *)sourceCodeDirectory {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray<NSString *> *files = [fm contentsOfDirectoryAtPath:sourceCodeDirectory error:nil];
    BOOL isDirectory;
    for (NSString *fileName in files) {
        NSString *filePath = [sourceCodeDirectory stringByAppendingPathComponent:fileName];
        if ([fm fileExistsAtPath:filePath isDirectory:&isDirectory] && isDirectory) {
            [self deleteWithWithFilePath:filePath];
            continue;
        }
        if (![fileName hasSuffix:@".h"] && ![fileName hasSuffix:@".m"] && ![fileName hasSuffix:@".mm"] && ![fileName hasSuffix:@".swift"]) continue;
        NSMutableString *fileContent = [NSMutableString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        
        // 删除 换行符
        if ([FileMixedHelper sharedHelper].modelDelete.isDeleteLineBreak) {
            [[FileMixedHelper sharedHelper] regularReplacement:fileContent regularExpression:@"/\\*{1,2}[\\s\\S]*?\\*/" newString:@""];
            [[FileMixedHelper sharedHelper] regularReplacement:fileContent regularExpression:@"^\\s*\\n" newString:@""];
        }
        
        // 删除 注释
        if ([FileMixedHelper sharedHelper].modelDelete.isDeleteAnnotation) {
            [[FileMixedHelper sharedHelper] regularReplacement:fileContent regularExpression:@"([^:/])//.*" newString:@"\\1"];
            [[FileMixedHelper sharedHelper] regularReplacement:fileContent regularExpression:@"^//.*" newString:@""]; // 删除 //
        }
        
        // 删除 NSLog
        if ([FileMixedHelper sharedHelper].modelDelete.isDeleteNSLog) {
            // 删除NSLog
            [[FileMixedHelper sharedHelper] regularReplacement:fileContent regularExpression:@"NSLog[(]@.*;" newString:@""];
            
        }
        
        // 是否需要整合文件夹
        NSError *error;
        if ([FileMixedHelper sharedHelper].modifyFileSavePath.length > 0) {
            NSString *newPath = [NSString stringWithFormat:@"%@/%@",[FileMixedHelper sharedHelper].modifyFileSavePath,fileName];
            [fileContent writeToFile:newPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        } else {
            [fileContent writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        }
        
        if (error) {
            [FileMixedHelper showAlert:@"删除错误" andDetailString:error.localizedDescription];
        }
    }
}


@end
