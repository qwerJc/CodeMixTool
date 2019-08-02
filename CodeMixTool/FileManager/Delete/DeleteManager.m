//
//  DeleteManager.m
//  CodeMixTool
//
//  Created by 贾辰 on 2019/7/1.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import "DeleteManager.h"
#import "FileMixedHelper.h"
#import "ModelLocator.h"

@implementation DeleteManager

- (void)startDelete {
    @autoreleasepool {
        if (model.arrSonPath.count > 0){
            for (NSString *path in model.arrSonPath) {
                [self deleteWithWithFilePath:path];
            }
        } else {
            [self deleteWithWithFilePath:model.sourceCodePath];
        }

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
        
        // 删除 注释
        if (model.modelDelete.isDeleteAnnotation) {
            [[FileMixedHelper sharedHelper] regularReplacement:fileContent regularExpression:@"([^:/*\"])//.*" newString:@"\\1"];
            //忽略1http://asdfff 2/// 3/*adddf*//*adaf*/ 4"//asdfasdf
            
            [[FileMixedHelper sharedHelper] regularReplacement:fileContent regularExpression:@"^//.*" newString:@""]; // 删除 //
        }
        
        // 删除 换行符
        if (model.modelDelete.isDeleteLineBreak) {
            [[FileMixedHelper sharedHelper] regularReplacement:fileContent regularExpression:@"/\\*{1,2}[\\s\\S]*?\\*/" newString:@""];
            [[FileMixedHelper sharedHelper] regularReplacement:fileContent regularExpression:@"^\\s*\\n" newString:@""];
        }
        
        // 删除 NSLog
        if (model.modelDelete.isDeleteNSLog) {
            // 删除NSLog
            // NSLog[(]@[\S,\s]*?[)];  NSLog[(]@.*;
            [[FileMixedHelper sharedHelper] regularReplacement:fileContent regularExpression:@"NSLog[(]@[\\S,\\s]*?[)];" newString:@""];
            
        }
        
        // 是否需要整合文件夹
        NSError *error;
        if (model.modifyFileSavePath.length > 0) {
            NSString *newPath = [NSString stringWithFormat:@"%@/%@",model.modifyFileSavePath,fileName];
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
