//
//  FileMixedHelper.h
//  CodeMixTool
//
//  Created by 贾辰 on 2019/6/24.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import <Foundation/Foundation.h>

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

// File Mixed Helper
@interface FileMixedHelper : NSObject
@property (copy, nonatomic, readonly) NSMutableSet *categoryFileSet; // category文件的集合（ 例如 UIbutton的Category，将包括UIbutton 和 UIbutton+JJC ）
@property (copy, nonatomic) NSSet *ignoreClassNamesSet; // 手动设置的忽略类名

@property (strong, nonatomic) NSString *projPath;                   // .xcodeProj 文件路径
@property (copy, nonatomic) NSArray<NSString *> *arrLibraryProjPath;  // .xcodeProj 文件路径
@property (strong, nonatomic) NSString *sourceCodePath;               // 代码文件总路径
@property (copy, nonatomic) NSArray<NSString *> *arrSonPath;        // 子路径
@property (strong, nonatomic) NSString *spamCodePath;               // 垃圾代码输出路经
@property (strong, nonatomic) NSString *modifyFileSavePath;         // 修改后文件存储路径

@property (strong, nonatomic) NSString *ignorePath;                 // 设置 忽略路径

@property (strong, nonatomic) NSArray *arrayNWordLibrary;
@property (strong, nonatomic) NSArray *arrayAdvWordLibrary;
@property (strong, nonatomic) NSArray *arrayAdjWordLibrary;
@property (strong, nonatomic) NSArray *arrayVtWordLibrary;

@property (strong, nonatomic) DeleteFunctionModel       *modelDelete;
@property (strong, nonatomic) SpamCodeFunctionModel     *modelSpamCode;
@property (strong, nonatomic) MixedFunctionModel        *modelMixed;

+(instancetype)sharedHelper;

#pragma mark - 替换
/**
 正则替换（修改 project.pbxproj 中的引用名）
 
 @param originalString 源代码
 @param regularExpression 正则替换规则（iOS下的正则 和 普通的正则有细微差别，如：xcode下\\为对\的转义）
 @param newString 新的字符串
 */
- (BOOL)regularReplacement:(NSMutableString *)originalString regularExpression:(NSString *)regularExpression newString:(NSString *)newString;

/**
 遍历全部code文件 替换类名

 @param sourceCodeDir code文件总路径
 @param oldClassName 旧类名
 @param newClassName 新类名
 */
- (void)modifyFilesClassNameWithSourceCodeDir:(NSString *)sourceCodeDir andOldClassName:(NSString *)oldClassName andNewClassName:(NSString *)newClassName;

/**
 重新保存文件（替换）

 @param oldPath 旧的文件路径
 @param newPath 新保存的文件路径
 */
- (void)resaveFileWithOldFilePath:(NSString *)oldPath andNewFilePath:(NSString *)newPath;
#pragma mark - 返回随机字符串
+ (NSString *)randomWord;

+ (NSString *)randomWordPropertyName;
+ (NSString *)randomWordClassName;
+ (NSString *)randomWordMethodName;
/**
 返回随机字符串
 @param length 字符串长度
 */
+ (NSString *)randomString:(NSInteger )length;

/** 返回随机单个字符 */
+ (NSString *)randomLetter;

/** 返回随机单个 大写 字符 */
+ (NSString *)randomCapital;

/** 返回随机单个数字 */
+ (NSString *)randomNum;
#pragma mark - 忽略文件
/* 当前类名是否需要替换 */
- (BOOL)isNeedChangedFileName:(NSString *)name;

/* 获取忽略的文件名（category文件和<import文件>） */
- (void)getIgnoreFileWithSourceCodeDir:(NSString *)sourceCodeDir;

// 获取category所拓展的文件合集
- (void)getAllCategoryFileClassNameWithSourceCodeDir:(NSString *)sourceCodeDir;


#pragma mark - Other

/** 显示提示框 */
+ (void)showAlert:(NSString *)string andDetailString:(NSString *)detailString;

+ (BOOL)isFolderEmpryWithPath:(NSString *)path;
@end

NS_ASSUME_NONNULL_END
