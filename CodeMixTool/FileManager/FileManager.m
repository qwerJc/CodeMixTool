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
#import "ModelLocator.h"

@interface FileManager()

@property (strong, nonatomic) DeleteManager *managerDelete;             // 删除Manager

@property (strong, nonatomic) MixClassNameManager *managerMixClassName; // 类名修改Manager

@property (strong, nonatomic) SpamCodeCreateManager *managerSpamCode;   // 添加垃圾代码Manager
@end

@implementation FileManager


#pragma mark - 删除无用代码
- (void)deleteUselessCode {
    
    model.modelDelete.isDeleteLineBreak = YES;
    model.modelDelete.isDeleteAnnotation = YES;
    model.modelDelete.isDeleteNSLog = YES;
    
    [self.managerDelete startDelete];
    NSLog(@"删除完成");
}

#pragma mark - 混淆类名
- (void)randomClassName {
//    [FileMixedHelper sharedHelper].modelMixed.lengthRandomClassName = NSMakeRange(10, 10);
    model.modelMixed.preName = @"JJC_";
    
    self.managerMixClassName = [[MixClassNameManager alloc] init];
    
    [self.managerMixClassName startMixed];
}

#pragma mark - 添加垃圾代码
- (void)addSpamCodeWithOutPath:(NSString *)outPath {
    model.modelSpamCode.categoryName = @"LLiveRoom";
    model.modelSpamCode.numMFileProperty = NSMakeRange(30, 30);
    model.modelSpamCode.lengthMFilePropertyName = NSMakeRange(10, 20);
    
    model.modelSpamCode.numCategoryProperty = NSMakeRange(30, 25);
    model.modelSpamCode.lengthCategoryPropertyName = NSMakeRange(10, 20);
    
    model.modelSpamCode.numCategoryProperty = NSMakeRange(30, 25);
    model.modelSpamCode.lengthCategoryPropertyName = NSMakeRange(10, 20);
    
    model.modelSpamCode.numCategoryMethod = NSMakeRange(30, 20);
    model.modelSpamCode.lengthCategoryMethodName = NSMakeRange(15, 25);
    
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
