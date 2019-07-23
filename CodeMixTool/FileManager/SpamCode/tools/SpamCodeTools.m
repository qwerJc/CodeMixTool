//
//  SpamCodeTools.m
//  CodeMixTool
//
//  Created by 贾辰 on 2019/6/27.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import "SpamCodeTools.h"
#import "FileMixedHelper.h"

@implementation SpamCodeTools
// set方法,proper声明 初始化时需要
+ (NSString *)getObjectiveTypeWithIndex:(NSUInteger)index {
    switch (index) {
        case EnumObjectType_NSInteger:
            return @"NSInteger ";
        case EnumObjectType_BOOL:
            return @"BOOL ";
            
        case EnumObjectType_NSObject:
            return @"NSObject *";
        case EnumObjectType_NSSet:
            return @"NSSet *";
        case EnumObjectType_NSArray:
            return @"NSArray *";
        case EnumObjectType_NSString:
            return @"NSString *";
        case EnumObjectType_NSDictionary:
            return @"NSDictionary *";
            
        case EnumObjectType_UIView:
            return @"UIView *";
        case EnumObjectType_UILabel:
            return @"UILabel *";
        case EnumObjectType_UIImageView:
            return @"UIImageView *";
        case EnumObjectType_ScrollView:
            return @"UIScrollView *";
        case EnumObjectType_UITextField:
            return @"UITextField *";
        case EnumObjectType_UITextView:
            return @"UITextView *";
        default:
            return @"";
    }
}

+ (NSString *)getPropertyNameWithIndex:(NSUInteger)index {
    NSString *propertyName = [FileMixedHelper randomWordPropertyName];
    switch (index) {
        case EnumObjectType_NSInteger:
            return [NSString stringWithFormat:@"integer%@",propertyName];
        case EnumObjectType_BOOL:
            return [NSString stringWithFormat:@"is%@",propertyName];
            
        case EnumObjectType_NSObject:
            return [NSString stringWithFormat:@"obj%@",propertyName];
        case EnumObjectType_NSSet:
            return [NSString stringWithFormat:@"nset%@",propertyName];
        case EnumObjectType_NSArray:
            return [NSString stringWithFormat:@"arr%@",propertyName];
        case EnumObjectType_NSString:
            return [NSString stringWithFormat:@"str%@",propertyName];
        case EnumObjectType_NSDictionary:
            return [NSString stringWithFormat:@"dic%@",propertyName];
            
        case EnumObjectType_UIView:
            return [NSString stringWithFormat:@"view%@",propertyName];
        case EnumObjectType_UILabel:
            return [NSString stringWithFormat:@"lbl%@",propertyName];
        case EnumObjectType_UIImageView:
            return [NSString stringWithFormat:@"imgv%@",propertyName];
        case EnumObjectType_ScrollView:
            return [NSString stringWithFormat:@"scrollView%@",propertyName];
        case EnumObjectType_UITextField:
            return [NSString stringWithFormat:@"txf%@",propertyName];
        case EnumObjectType_UITextView:
            return [NSString stringWithFormat:@"txv%@",propertyName];
    }
    return @"";
}

+ (NSString *)getPropertyCodeWithIndex:(NSUInteger)index {
    switch (index) {
        case EnumObjectType_NSInteger:
        case EnumObjectType_BOOL:
            return @"(assign, nonatomic)";
            
        case EnumObjectType_NSObject:
        case EnumObjectType_NSSet:
        case EnumObjectType_NSArray:
        case EnumObjectType_NSString:
        case EnumObjectType_NSDictionary:
        case EnumObjectType_UIView:
        case EnumObjectType_UILabel:
        case EnumObjectType_UIImageView:
        case EnumObjectType_ScrollView:
        case EnumObjectType_UITextField:
        case EnumObjectType_UITextView:
            return @"(strong, nonatomic)";
        default:
            return @"";
    }
}

+ (NSString *)getInitCodeWithClassIndex:(NSUInteger)index {
    switch (index) {
        case EnumObjectType_NSInteger:
            return [NSString stringWithFormat:@"%@%@%@%@",[FileMixedHelper randomNum],[FileMixedHelper randomNum],[FileMixedHelper randomNum],[FileMixedHelper randomNum]];
        case EnumObjectType_BOOL:
            return @"YES";
            
        case EnumObjectType_NSObject:
            return @"[[NSObject alloc] init]";
        case EnumObjectType_NSSet:
            return @"[[NSSet alloc] init]";
        case EnumObjectType_NSArray:
            return @"[NSArray array]";
        case EnumObjectType_NSString:
            return [NSString stringWithFormat:@"@\"%@\"",[FileMixedHelper randomString:10]];
        case EnumObjectType_NSDictionary:
            return @"[[NSDictionary alloc] init]";
            
        case EnumObjectType_UIView:
            return @"[[UIView alloc] init]";
        case EnumObjectType_UILabel:
            return @"[[UILabel alloc] init]";
        case EnumObjectType_UIImageView:
            return @"[[UIImageView alloc] init]";
        case EnumObjectType_ScrollView:
            return @"[[UIScrollView alloc] init]";
        case EnumObjectType_UITextField:
            return @"[[UITextField alloc] init]";
        case EnumObjectType_UITextView:
            return @"[[UITextView alloc] init]";
        default:
            return @"";
    }
    return @"";
}

+ (NSString *)getReturnTypeWithIndex:(NSInteger)index {
    switch (index) {
        case EnumCategoryReturnType_Void:
            return @"void";
        case EnumCategoryReturnType_BOOL:
            return @"BOOL";
        case EnumCategoryReturnType_NSInteger:
            return @"NSInteger";
            
        case EnumCategoryReturnType_NSObject:
            return @"NSObject *";
        case EnumCategoryReturnType_NSSet:
            return @"NSSet *";
            
        case EnumCategoryReturnType_NSArray:
            return @"NSArray *";
        case EnumCategoryReturnType_NSString:
            return @"NSString *";
        case EnumCategoryReturnType_NSDictionary:
            return @"NSDictionary *";
        default:
            return @"";
    }
}

+ (NSString *)getPropertyCodeWithName:(NSString *)propertyName andPropertyType:(NSUInteger)index {
    return [NSString stringWithFormat:@"@property %@ %@%@;\n",[SpamCodeTools getPropertyCodeWithIndex:index],[SpamCodeTools getObjectiveTypeWithIndex:index],propertyName];
}

+ (NSString *)getSpamMethodCodeWithMethodName:(NSString *)methodName andReturnType:(NSUInteger)index andParamName:(NSString *)paramName{
//    NSString *methodType = arc4random()%2 ? @"-" : @"+";
    NSString *returnType = [SpamCodeTools getReturnTypeWithIndex:index];
    
    if (paramName) {
        NSString *paramCode = [NSString stringWithFormat:@"(%@)%@",returnType,paramName];
        return [NSString stringWithFormat:@"+ (%@)%@:%@",returnType,methodName,paramCode];
    } else {
        return [NSString stringWithFormat:@"- (%@)%@",returnType,methodName];
    }
}

+ (NSString *)getRealizationCodeWithReturnType:(NSUInteger)returnType andParamName:(NSString *)paramName {
    if (returnType == 0) {
        // 返回值为void
        return [NSString stringWithFormat:@"[self jjc_category_callAllAddProperty];\n"];
    } else {
        return [self son_getRealizationCodeWithReturnType:returnType ParamName:paramName];
    }
}

+ (NSString *)son_getRealizationCodeWithReturnType:(NSInteger)returnType ParamName:(NSString *)paramName {
    NSString *temVarName1 = [FileMixedHelper randomString:15];
    NSString *temVarName2;
    
    if (paramName) {
        // 如果当前 实现方法有参数
        temVarName2 = paramName;
    } else {
        temVarName2 = [FileMixedHelper randomString:22];
    }
    
    NSString *code;
    switch (returnType) {
        case EnumCategoryReturnType_BOOL:
            if (paramName) {
                code = [NSString stringWithFormat:@"    BOOL %@ = NO;\n    if (%@ && %@) {\n        return !%@;\n    } else {\n        return %@ || %@;\n    }\n       ",temVarName1,temVarName1,temVarName2,temVarName2,temVarName1,temVarName2];
            } else {
                code = [NSString stringWithFormat:@"    return YES;"];
            }
            
            return code;
        case EnumCategoryReturnType_NSInteger:
            if (paramName) {
                code = [NSString stringWithFormat:@"    NSInteger %@ = %@;\n    return %@+ %@;",temVarName1,[FileMixedHelper randomNum],temVarName1,temVarName2];
            } else {
                code = [NSString stringWithFormat:@"    return %@%@;",[FileMixedHelper randomNum],[FileMixedHelper randomNum]];
            }
            return code;
            
        case EnumCategoryReturnType_NSObject:
            if (paramName) {
                code = [NSString stringWithFormat:@"    %@ = [[NSObject alloc] init];\n    return %@;",paramName,paramName];
            } else {
                code = [NSString stringWithFormat:@"    NSObject *%@ = [[NSObject alloc] init];\n    return %@;",temVarName1,temVarName1];
            }
            
            return code;
        case EnumCategoryReturnType_NSSet:
            if (paramName) {
                code = [NSString stringWithFormat:@"    return %@;\n",paramName];
            } else {
                code = [NSString stringWithFormat:@"    NSSet *%@ = [NSSet setWithObject:@\"\"];\n    return %@;",temVarName1,temVarName1];
            }
            return code;
            
        case EnumCategoryReturnType_NSArray:
            code = [NSString stringWithFormat:@"    return [NSArray arrayWithObjects:@\"\", nil];"];
            return code;
        case EnumCategoryReturnType_NSString:
            code = [NSString stringWithFormat:@"    return @\"wqrds\";"];
            return code;
        case EnumCategoryReturnType_NSDictionary:
            code = [NSString stringWithFormat:@"    return [NSDictionary dictionary];"];
            return code;
        default:
            return @"";
    }
}

+ (NSString *)getRandomPropertyNameWithLength:(NSUInteger)length {
    return [[FileMixedHelper randomCapital] stringByAppendingString:[FileMixedHelper randomString:length-1]];
}

+ (NSString *)getRandomMethodNameWithLength:(NSUInteger)length {
    return [FileMixedHelper randomString:length];
}
@end
