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
- (instancetype)initWithPropertyNameLength:(NSRange)rangePropertyNameLength
                               PropertyNum:(NSRange)rangePropertyNum
                           andMethodLength:(NSRange)rangeMethodNameLength
                              andMethodNum:(NSRange)rangeMethodNum {
    self = [super init];
    if (self) {
        
        _arrMethodType = [NSArray arrayWithObjects:@"-",@"+", nil];
        
        // 全部垃圾属性 初始化方法
        NSMutableString *callAllPropertyCode = [[NSMutableString alloc] initWithString:@"- (void)jjc_category_callAllAddProperty {\n"];
        
        // 垃圾 属性 合集
        NSInteger propertyNum = rangePropertyNum.location + arc4random()%rangePropertyNum.length;
        NSMutableString *sumPropertyCode = [NSMutableString stringWithString:@""];
        for (int i=0; i<propertyNum; i++) {
            NSUInteger typeIndex = arc4random()%10;
            NSInteger randomPropertyNameLength = rangePropertyNameLength.location + arc4random()%rangePropertyNameLength.length;
//            NSString *propertyName = [SpamCodeTools getRandomPropertyNameWithLength:randomPropertyNameLength];
            NSString *propertyName = [FileMixedHelper randomWordPropertyName];;
            NSString *tempPropertyCode = [SpamCodeTools getPropertyCodeWithName:propertyName andPropertyType:typeIndex];
            
            [sumPropertyCode appendString:tempPropertyCode];
            
            // 添加至 初始化方法
            NSString *strCallCode = [NSString stringWithFormat:@"    self.%@ = %@;\n",
                                     propertyName,
                                     [SpamCodeTools getInitCodeWithClassIndex:typeIndex]];
            [callAllPropertyCode appendString:strCallCode];
           
        }
        [callAllPropertyCode appendString:@"}\n"];
        _propertyCode = [sumPropertyCode copy];
        _callMethodCode = [callAllPropertyCode copy];
        
        // 垃圾 类/成员方法-声明 合集
        // 声明代码
        NSMutableString *methodDeclarationCode = [[NSMutableString alloc] init];
        // 方法 实现代码
        NSMutableString *methodRealizationCode = [[NSMutableString alloc] init];
        
        NSInteger methodNum = rangeMethodNum.location + arc4random()%rangeMethodNum.length;
        for (int i =0; i < methodNum; i++) {
            NSInteger methodNameLength = rangeMethodNameLength.location + arc4random()%rangeMethodNameLength.length;
//            NSString *methodName = [SpamCodeTools getRandomMethodNameWithLength:methodNameLength];
            NSString *methodName = [FileMixedHelper randomWordMethodName];
            // 返回值类型
            NSUInteger returnType = arc4random()%8;
            
            // 参数名（为nil时则没有参数）
            NSString *paramName;
            if (returnType > 0 && arc4random()%3 > 0) {
//                paramName = [SpamCodeTools getRandomPropertyNameWithLength:25];
                paramName = [FileMixedHelper randomWordPropertyName];
            }
            
            
            NSString *methodCode = [SpamCodeTools getSpamMethodCodeWithMethodName:methodName
                                                                    andReturnType:returnType
                                                                     andParamName:paramName];
            // 方法 声明代码
            [methodDeclarationCode appendString:[NSString stringWithFormat:@"%@;\n",methodCode]];
            
            NSString *spamRealizationCode = [SpamCodeTools getRealizationCodeWithReturnType:returnType andParamName:paramName];
            // 方法 实现代码
            [methodRealizationCode appendString:[NSString stringWithFormat:@"\n%@ {\n    %@\n}\n",methodCode,spamRealizationCode]];
        }
        
        
        _hMethodCode = [methodDeclarationCode copy];
        _mMethodCode = [methodRealizationCode copy];
        
        
    }
    return self;
}

@end
