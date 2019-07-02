//
//  DeleteManager.h
//  CodeMixTool
//
//  Created by 贾辰 on 2019/7/1.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeleteManager : NSObject
@property (assign, nonatomic) BOOL isDeleteLineBreak;   // 删除换行
@property (assign, nonatomic) BOOL isDeleteAnnotation;  // 删除注释
@property (assign, nonatomic) BOOL isDeleteNSLog;       // 删除NSlog

@property (strong, nonatomic) NSString *codeFilePath; // 新的代码文件存放路径

- (void)startDeleteWithFilePath:(NSString *)sourceCodeDirectory
                      ignoreArr:(NSArray<NSString *> *)ignoreDirNames;
@end

NS_ASSUME_NONNULL_END
