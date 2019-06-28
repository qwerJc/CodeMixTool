//
//  SpamCategoryModel.m
//  CodeMixTool
//
//  Created by 贾辰 on 2019/6/27.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import "SpamCategoryModel.h"
#import "FileMixedHelper.h"
#import "SpamCodeTools.h"

@interface SpamCategoryModel()
@property (strong, nonatomic) NSArray *arrMethodType;
@end

@implementation SpamCategoryModel
- (instancetype)initWithReturnType:(NSUInteger)typeIndex andPropertyNameLength:(NSUInteger)length {
    self = [super init];
    if (self) {
        
        _arrMethodType = [NSArray arrayWithObjects:@"-",@"+", nil];
        
        NSInteger type = arc4random()%8;
        
        
        NSString *propertyName = [[FileMixedHelper randomCapital] stringByAppendingString:[FileMixedHelper randomString:length-1]];
        
        NSString *methodString = [self getMethodString];
        // 带*的类型
//        NSString *objectiveType = [self getObjectiveTypeWithIndex:typeIndex];
//        NSString *initCode = [self getInitCodeWithClassIndex:typeIndex];
//
//        NSString *tempVarName = [FileMixedHelper randomString:arc4random()%20+15];
//
//        // Property Code
//        NSString *strProperty = [NSString stringWithFormat:@"@property %@ %@%@;\n",[self getPropertyCodeWithIndex:typeIndex],objectiveType,propertyName];
//        _propertyCode = strProperty;
//
//        // GetMethod Code
//        NSString *strGetMethod = [NSString stringWithFormat:@"- (%@)%@ { \n    %@%@ = %@; \n    return %@;\n}\n",
//                                  objectiveType,
//                                  propertyName,
//                                  objectiveType,
//                                  tempVarName,
//                                  initCode,
//                                  tempVarName];
//        _getMethodCode = strGetMethod;
//
//        // SetMethod Code
//        NSString *strSetMethod = [NSString stringWithFormat:@"- (void)set%@:(%@)%@ { \n    _%@ = %@; \n}\n",
//                                  propertyName,
//                                  objectiveType,
//                                  tempVarName,
//                                  propertyName,
//                                  tempVarName];
//        _setMethodCode = strSetMethod;
//
//        // Call SpamCode]
//        NSString *strCallCode = [NSString stringWithFormat:@"self.%@ = %@;\n",
//                                 propertyName,
//                                 [self getInitCodeWithClassIndex:typeIndex]];
//        _callMethodCode = strCallCode;
    }
    return self;
}

- (NSString *)getMethodString {
    // 方法类型
    NSString *strMethodType = _arrMethodType[arc4random()%2];
    
    // 方法名
    NSUInteger methodNameLength = arc4random()%20+15;
    NSString *strMethodName = [FileMixedHelper randomString:methodNameLength];
    
    // 参数
    NSString *strParam;
    NSUInteger paramNum = arc4random()%2;
    if (paramNum == 1) {
        NSUInteger typeParam = arc4random()%10;
//        newMethodString = [NSString stringWithFormat:@"%@ ()"]
    }
    return @"";
}

- (NSString *)getReturnTypeWithIndex:(NSInteger)index {
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

@end
