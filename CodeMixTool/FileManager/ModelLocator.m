//
//  ModelLocator.m
//  CodeMixTool
//
//  Created by 贾辰 on 2019/8/2.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import "ModelLocator.h"
@interface ModelLocator()
@property (copy, nonatomic) NSMutableSet *allFilePath; //存放所有代码源文件的路径
@end

@implementation ModelLocator

+(instancetype)sharedModelLocator {
    static ModelLocator *m;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [[self alloc] init];
        
    });
    
    return m;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createData];
    }
    return self;
}

- (void)createData {
    self.modelDelete = [[DeleteFunctionModel alloc] init];
    self.modelSpamCode = [[SpamCodeFunctionModel alloc] init];
    self.modelMixed = [[MixedFunctionModel alloc] init];
    
    
    _ignorePath = @"/Users/jiachen/xiuchang_iPhone/greenhouse-iPhone/ThirdParty_Components/";
}

#pragma mark - setup
- (void)setup {
//    [self setupWithCategory:_sourceCodePath];
//    NSLog(@"%@",_categoryFileSet);
    
    [self setupAllFilePath];
    
    [self getALlCategory];
}

- (void)setupAllFilePath {
    _arrFilePath = [NSMutableArray arrayWithCapacity:0];
    [self findFileWithPath:_sourceCodePath];
}

- (void)findFileWithPath:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    
    // 遍历源代码文件 h 与 m 配对，swift
    NSArray<NSString *> *files = [fm contentsOfDirectoryAtPath:path error:nil];
    BOOL isDirectory;
    
    for (NSString *file in files) { // filePath
        NSString *filePath = [path stringByAppendingPathComponent:file];
        // 如果当前path对应的是文件夹
        if ([fm fileExistsAtPath:filePath isDirectory:&isDirectory] && isDirectory) {
            [self findFileWithPath:filePath];
            continue;
        }
        [_arrFilePath addObject:filePath];
    }
}

- (void)getALlCategory {
    NSLog(@"11");
    _categoryFileSet = [[NSMutableSet alloc] initWithCapacity:0];
    
    int i = 0;
    
    for (NSString *path in _arrFilePath) {
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//        });
        NSString *fileName = path.lastPathComponent.stringByDeletingPathExtension; //类名：JJCView
        NSString *fileExtension = path.pathExtension; // h/m 文件

        // 获取文件名带+且后缀为.h或.m的
        if ([fileName containsString:@"+"] && ([fileExtension isEqualToString:@"h"] || [fileExtension isEqualToString:@"m"])) {
            // category 所拓展的类名q
            NSUInteger index = [fileName rangeOfString:@"+"].location;
            NSString *className = [fileName substringToIndex:index];

            if (![_categoryFileSet containsObject:fileName]) {
                [_categoryFileSet addObject:fileName];
                NSLog(@"%i : %@",i++,fileName);
            }
            
            if (![_categoryFileSet containsObject:className]) {
                [_categoryFileSet addObject:className];
                NSLog(@"%i : %@",i++,className);
            }
        }
    }
    NSLog(@"%@",_categoryFileSet);
}

- (void)log {
    NSLog(@"==");
    NSLog(@"%@",_categoryFileSet);
    NSLog(@"==");
    NSLog(@"%@",model.categoryFileSet);
    NSLog(@"==");
}
- (void)setupWithCategory:(NSString *)sourceCodeFilePath {
    NSFileManager *fm = [NSFileManager defaultManager];
    
    // 遍历源代码文件 h 与 m 配对，swift
    NSArray<NSString *> *files = [fm contentsOfDirectoryAtPath:sourceCodeFilePath error:nil];
    BOOL isDirectory;
    
    for (NSString *file in files) { // filePath
        NSString *filePath = [sourceCodeFilePath stringByAppendingPathComponent:file];
        if ([fm fileExistsAtPath:filePath isDirectory:&isDirectory] && isDirectory) {
            [self setupWithCategory:filePath];
            continue;
        }
        
        NSString *fileName = file.lastPathComponent.stringByDeletingPathExtension; //类名：JJCView
        NSString *fileExtension = file.pathExtension; // h/m 文件
        
        if ([fileExtension isEqualToString:@"h"] || [fileExtension isEqualToString:@"m"]) {
            // 获取文件名带+的
            if ([fileName containsString:@"+"]) {
                // 带+（category的方法）
                [_categoryFileSet addObject:fileName];
                
                // category 所拓展的类名q
                NSUInteger index = [fileName rangeOfString:@"+"].location;
                NSString *className = [fileName substringToIndex:index];
                
                if (![_categoryFileSet containsObject:className]) {
                    [_categoryFileSet addObject:className];
                }
            }
        }
    }
}
@end

// 删除功能Model
@implementation DeleteFunctionModel
- (NSString *)description {
    return [NSString stringWithFormat:@"\nisDeleteLineBreak: %d \nisDeleteAnnotation: %d \nisDeleteNSLog: %d",self.isDeleteLineBreak,self.isDeleteAnnotation,self.isDeleteNSLog];
}
@end

@implementation SpamCodeFunctionModel
@end

@implementation MixedFunctionModel
@end
