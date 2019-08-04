//
//  ModelLocator.h
//  CodeMixTool
//
//  Created by 贾辰 on 2019/8/2.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define model [ModelLocator sharedModelLocator]

NS_ASSUME_NONNULL_BEGIN
// 删除功能Model
@interface DeleteFunctionModel : NSObject
@property (assign, nonatomic) BOOL isDeleteLineBreak;   // 删除换行
@property (assign, nonatomic) BOOL isDeleteAnnotation;  // 删除注释
@property (assign, nonatomic) BOOL isDeleteNSLog;       // 删除NSlog
@end

// 添加垃圾代码 功能Model
@interface SpamCodeFunctionModel : NSObject
@property (strong, nonatomic) NSString *categoryName;               // category名字
@property (assign, nonatomic) NSRange numMFileProperty;             // .m文件中 垃圾属性 数量
@property (assign, nonatomic) NSRange lengthMFilePropertyName;      // .m文件中 垃圾属性 名称长度

@property (assign, nonatomic) NSRange numCategoryProperty;          // category文件中 垃圾属性 数量
@property (assign, nonatomic) NSRange lengthCategoryPropertyName;   // category文件中 垃圾属性 名称长度

@property (assign, nonatomic) NSRange numCategoryMethod;            // category文件中 垃圾方法 数量
@property (assign, nonatomic) NSRange lengthCategoryMethodName;     // category文件中 垃圾方法 名称长度

@end

// 添加类名混淆 功能Model
@interface MixedFunctionModel : NSObject
@property (assign, nonatomic) NSRange lengthRandomClassName;   // 随机类名长度

@property (assign, nonatomic) NSString *preName;        // 固定类前缀
@property (assign, nonatomic) NSString *infixName;      // 固定类中缀
@property (assign, nonatomic) NSString *suffixName;     // 固定类后缀

@property (assign, nonatomic) NSRange lengthPreName;    // 随机类前缀 长度
@property (assign, nonatomic) NSRange lengthInfixName;  // 随机类中缀 长度
@property (assign, nonatomic) NSRange lengthSuffixName; // 随机类后缀 长度

@property (assign, nonatomic) BOOL isDeleteNSLog;       // 删除NSlog
@end

// ModelLocator
@interface ModelLocator : NSObject
@property (strong, nonatomic) DeleteFunctionModel       *modelDelete;
@property (strong, nonatomic) SpamCodeFunctionModel     *modelSpamCode;
@property (strong, nonatomic) MixedFunctionModel        *modelMixed;

@property (copy, nonatomic, readonly) NSMutableSet *categoryFileSet; // category文件的集合（ 例如 UIbutton的Category，将包括UIbutton 和 UIbutton+JJC ）
@property (copy, nonatomic) NSSet *ignoreClassNamesSet; // 手动设置的忽略类名

@property (strong, nonatomic) NSString *projPath;                   // .xcodeProj 文件路径
@property (copy, nonatomic) NSArray<NSString *> *arrLibraryProjPath;  // .xcodeProj 文件路径

@property (copy, nonatomic) NSMutableArray<NSString *> *arrFilePath;     // 存放所有文件路径

@property (strong, nonatomic) NSString *sourceCodePath;               // 代码文件总路径
@property (copy, nonatomic) NSArray<NSString *> *arrSonPath;        // 子路径
@property (strong, nonatomic) NSString *spamCodePath;               // 垃圾代码输出路经
@property (strong, nonatomic) NSString *modifyFileSavePath;         // 修改后文件存储路径

@property (strong, nonatomic) NSString *ignorePath;                 // 设置 忽略路径

+(instancetype)sharedModelLocator;

- (void)setup;

- (void)log;
@end




NS_ASSUME_NONNULL_END
