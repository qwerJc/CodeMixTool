//
//  SpamCodeTools.h
//  CodeMixTool
//
//  Created by 贾辰 on 2019/6/27.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


// 返回值类型
typedef NS_ENUM(NSUInteger, EnumCategoryReturnType) {
    EnumCategoryReturnType_Void = 0,
    EnumCategoryReturnType_BOOL,
    EnumCategoryReturnType_NSInteger,
    
    EnumCategoryReturnType_NSObject,
    EnumCategoryReturnType_NSSet,
    EnumCategoryReturnType_NSArray,
    EnumCategoryReturnType_NSString,
    EnumCategoryReturnType_NSDictionary,
};

typedef NS_ENUM(NSUInteger, EnumObjectType) {
    EnumObjectType_Int = 0,
    EnumObjectType_Float,
    EnumObjectType_Double,
    EnumObjectType_Char,
    EnumObjectType_NSInteger,
    
    EnumObjectType_NSObject,
    EnumObjectType_NSSet,
    EnumObjectType_NSArray,
    EnumObjectType_NSString,
    EnumObjectType_NSDictionary,
};

@interface SpamCodeTools : NSObject

+ (NSString *)getObjectiveTypeWithIndex:(NSUInteger)index;
+ (NSString *)getPropertyCodeWithIndex:(NSUInteger)index;
+ (NSString *)getInitCodeWithClassIndex:(NSUInteger)index;
+ (NSString *)getReturnTypeWithIndex:(NSInteger)index;

/**
 获取 垃圾属性代码

 @param propertyName 属性名
 @param index 属性类型
 */
+ (NSString *)getPropertyCodeWithName:(NSString *)propertyName andPropertyType:(NSUInteger)index;

/**
 获取 垃圾方法代码

 @param methodName 方法名
 @param index 返回值类型
 @param paramName 参数名（为nil时则没有参数）
 */
+ (NSString *)getSpamMethodCodeWithMethodName:(NSString *)methodName andReturnType:(NSUInteger)index andParamName:(NSString *)paramName;

+ (NSString *)getRealizationCodeWithReturnType:(NSUInteger)returnType andParamName:(NSString *)paramName;
/** 返回随机属性名（为了重写set方法方便，重写的属性基本都为大写字母开头）*/
+ (NSString *)getRandomPropertyNameWithLength:(NSUInteger)length;
+ (NSString *)getRandomMethodNameWithLength:(NSUInteger)length;
@end

NS_ASSUME_NONNULL_END
