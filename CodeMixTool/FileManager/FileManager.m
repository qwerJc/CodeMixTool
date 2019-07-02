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
#import "DeleteManager.h"

@interface FileManager()
@property (strong, nonatomic) NSString *codeFilePath;               // 代码文件的总路径
@property (strong, nonatomic) NSString *projPath;                   // 工程路径(.xcodeproj路径)
@property (strong, nonatomic) NSString *sonPath;                    // 子文件夹的路径

@property (strong, nonatomic) NSArray<NSString *> *arrIgnoreDirNames;   // 忽略文件夹名 数组

@property (strong, nonatomic) NSMutableSet *categoryFileNameSet;        // category所拓展的类名

@property (strong, nonatomic) DeleteManager *managerDelete;             // 删除Manager

@property (strong, nonatomic) MixClassNameManager *managerMixClassName; // 类名修改Manager

@property (strong, nonatomic) SpamCodeCreateManager *managerSpamCode;   // 添加垃圾代码Manager
@end

@implementation FileManager

- (void)setupWithXcodeProjPath:(NSString *)projPath andCodeFilePath:(NSString *)codePath andTask:(EnumTaskType)task{
    if (!projPath ||  projPath.length <= 1) {
        [FileMixedHelper showAlert:@"请设置工程路径" andDetailString:@""];
        return ;
    } else {
        _projPath = [NSString stringWithFormat:@"%@/project.pbxproj",projPath];
    }

    if (!codePath ||  codePath.length <= 1) {
        [FileMixedHelper showAlert:@"请设置源码文件路径" andDetailString:@""];
        return ;
    } else {
        _codeFilePath = codePath;
    }

    if (task < 1) {
        [FileMixedHelper showAlert:@"请选择任务" andDetailString:@""];;
        return ;
    }
}

- (void)setSumFileCodePath:(NSString *)path {
    [self.managerDelete setCodeFilePath:path];
}
#pragma mark - 删除无用代码
- (void)deleteUselessCode {
    
//    self.managerDelete.isDeleteLineBreak = YES;
//    self.managerDelete.isDeleteAnnotation = YES;
//    self.managerDelete.isDeleteNSLog = YES;
    
    [self.managerDelete startDeleteWithFilePath:_codeFilePath ignoreArr:_arrIgnoreDirNames];
    NSLog(@"删除完成");
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

    [self.managerSpamCode setSpamPropertyNum:NSMakeRange(20, 20)];
    
    [self.managerSpamCode setSpamCategoryPropertyNum:NSMakeRange(10, 10) andMethodNum:NSMakeRange(10, 10)];
    [self.managerSpamCode startMakeSpamCodeWithCodeFilePath:_codeFilePath andProjPath:_projPath];
}


#pragma mark - Lazy Load
- (DeleteManager *)managerDelete {
    if (!_managerDelete) {
        _managerDelete = [[DeleteManager alloc] init];
    }
    return _managerDelete;
}
@end
