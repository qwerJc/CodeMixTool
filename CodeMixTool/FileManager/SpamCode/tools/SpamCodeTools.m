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
            return [NSString stringWithFormat:@"@\"%@\"",[FileMixedHelper randomString:50]];
        case EnumObjectType_NSDictionary:
            return @"[[NSDictionary alloc] init]";
        default:
            return @"";
    }
    return @"";
}

@end
