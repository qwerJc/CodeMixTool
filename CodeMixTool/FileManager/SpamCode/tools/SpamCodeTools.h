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
@end

NS_ASSUME_NONNULL_END
