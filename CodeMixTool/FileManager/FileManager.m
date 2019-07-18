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

@property (strong, nonatomic) DeleteManager *managerDelete;             // 删除Manager

@property (strong, nonatomic) MixClassNameManager *managerMixClassName; // 类名修改Manager

@property (strong, nonatomic) SpamCodeCreateManager *managerSpamCode;   // 添加垃圾代码Manager
@end

@implementation FileManager


#pragma mark - 删除无用代码
- (void)deleteUselessCode {
    
    [FileMixedHelper sharedHelper].modelDelete.isDeleteLineBreak = YES;
    [FileMixedHelper sharedHelper].modelDelete.isDeleteAnnotation = YES;
    [FileMixedHelper sharedHelper].modelDelete.isDeleteNSLog = YES;
    
    [self.managerDelete startDelete];
    NSLog(@"删除完成");
}

#pragma mark - 混淆类名
- (void)randomClassName {
//    [FileMixedHelper sharedHelper].modelMixed.lengthRandomClassName = NSMakeRange(10, 10);
    [FileMixedHelper sharedHelper].modelMixed.preName = @"JJC_";
    
    self.managerMixClassName = [[MixClassNameManager alloc] init];
    
    [self.managerMixClassName startMixed];
}

#pragma mark - 添加垃圾代码
- (void)addSpamCodeWithOutPath:(NSString *)outPath {
    [FileMixedHelper sharedHelper].modelSpamCode.categoryName = @"LLiveRoom";
    [FileMixedHelper sharedHelper].modelSpamCode.numMFileProperty = NSMakeRange(30, 30);
    [FileMixedHelper sharedHelper].modelSpamCode.lengthMFilePropertyName = NSMakeRange(10, 20);
    
    [FileMixedHelper sharedHelper].modelSpamCode.numCategoryProperty = NSMakeRange(30, 25);
    [FileMixedHelper sharedHelper].modelSpamCode.lengthCategoryPropertyName = NSMakeRange(10, 20);
    
    [FileMixedHelper sharedHelper].modelSpamCode.numCategoryProperty = NSMakeRange(30, 25);
    [FileMixedHelper sharedHelper].modelSpamCode.lengthCategoryPropertyName = NSMakeRange(10, 20);
    
    [FileMixedHelper sharedHelper].modelSpamCode.numCategoryMethod = NSMakeRange(30, 20);
    [FileMixedHelper sharedHelper].modelSpamCode.lengthCategoryMethodName = NSMakeRange(15, 25);
    
    self.managerSpamCode = [[SpamCodeCreateManager alloc] init];
    [self.managerSpamCode startAddSpamCode];
}


#pragma mark - Lazy Load
- (DeleteManager *)managerDelete {
    if (!_managerDelete) {
        _managerDelete = [[DeleteManager alloc] init];
    }
    return _managerDelete;
}
@end
