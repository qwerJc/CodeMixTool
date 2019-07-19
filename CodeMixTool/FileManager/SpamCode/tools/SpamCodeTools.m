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
+ (NSString *)getObjectiveTypeWithIndex:(NSUInteger)index {
    switch (index) {
        case EnumObjectType_Int:
            return @"char ";
        case EnumObjectType_Float:
            return @"int ";
        case EnumObjectType_Double:
            return @"float ";
        case EnumObjectType_Char:
            return @"char ";
        case EnumObjectType_NSInteger:
            return @"double ";
            
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
        default:
            return @"";
    }
}

+ (NSString *)getPropertyCodeWithIndex:(NSUInteger)index {
    switch (index) {
        case EnumObjectType_Int:
        case EnumObjectType_Float:
        case EnumObjectType_Double:
        case EnumObjectType_Char:
        case EnumObjectType_NSInteger:
            return @"(assign, nonatomic)";
            
        case EnumObjectType_NSObject:
        case EnumObjectType_NSSet:
        case EnumObjectType_NSArray:
        case EnumObjectType_NSString:
        case EnumObjectType_NSDictionary:
            return @"(strong, nonatomic)";
        default:
            return @"";
    }
}

+ (NSString *)getInitCodeWithClassIndex:(NSUInteger)index {
    switch (index) {
        case EnumObjectType_Int:
            return [NSString stringWithFormat:@"%@",[FileMixedHelper randomNum]];
        case EnumObjectType_Float:
            return [NSString stringWithFormat:@"%@",[FileMixedHelper randomNum]];
        case EnumObjectType_Double:
            return [NSString stringWithFormat:@"%@.%@",[FileMixedHelper randomNum],[FileMixedHelper randomNum]];
        case EnumObjectType_Char:
            return [NSString stringWithFormat:@"'%@'",[FileMixedHelper randomLetter]];
        case EnumObjectType_NSInteger:
            return [NSString stringWithFormat:@"%@%@%@%@",[FileMixedHelper randomNum],[FileMixedHelper randomNum],[FileMixedHelper randomNum],[FileMixedHelper randomNum]];
            
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
