//
//  SpamPropertyModel.m
//  CodeMixTool
//
//  Created by 贾辰 on 2019/6/26.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import "SpamPropertyModel.h"
#import "FileMixedHelper.h"
#import "SpamCodeTools.h"

@implementation SpamPropertyModel
- (instancetype)initWithPropertyNameLength:(NSRange)rangePropertyNameLength
                               PropertyNum:(NSRange)rangePropertyNum {
    self = [super init];
    if (self) {
        // 全部垃圾属性 初始化方法
        NSMutableString *callAllPropertyCode = [[NSMutableString alloc] initWithString:@""];
        
        NSMutableString *allSpamPropertySetMethod = [[NSMutableString alloc] initWithCapacity:0];
        
        // 垃圾 属性 合集
        NSInteger propertyNum = rangePropertyNum.location + arc4random()%rangePropertyNum.length;
        NSMutableString *sumPropertyCode = [NSMutableString stringWithString:@""];
        for (int i=0; i<propertyNum; i++) {
            NSUInteger typeIndex = arc4random()%10;
            NSInteger randomPropertyNameLength = rangePropertyNameLength.location + arc4random()%rangePropertyNameLength.length;
//            NSString *tempVarName = [FileMixedHelper randomString:arc4random()%20+15]; // set方法需要的临时变量
            NSString *tempVarName = [FileMixedHelper randomWordPropertyName];
            
//            NSString *propertyName = [SpamCodeTools getRandomPropertyNameWithLength:randomPropertyNameLength];
            NSString *propertyName = [FileMixedHelper randomWordPropertyName];
            NSString *tempPropertyCode = [SpamCodeTools getPropertyCodeWithName:propertyName andPropertyType:typeIndex];
            
            [sumPropertyCode appendString:tempPropertyCode];
            
            // 添加至 初始化方法
            NSString *strCallCode = [NSString stringWithFormat:@"    self.%@ = %@;\n",
                                     propertyName,
                                     [SpamCodeTools getInitCodeWithClassIndex:typeIndex]];
            [callAllPropertyCode appendString:strCallCode];
            
            // 添加 所有的set方法
            NSString *strSetMethod = [NSString stringWithFormat:@"- (void)set%@:(%@)%@ { \n    _%@ = %@; \n}\n",
                                      [propertyName capitalizedString],
                                      [SpamCodeTools getObjectiveTypeWithIndex:typeIndex],
                                      tempVarName,
                                      propertyName,
                                      tempVarName];
            
            [allSpamPropertySetMethod appendString:strSetMethod];
        }

        _propertyCode = [sumPropertyCode copy];
        _callMethodCode = [callAllPropertyCode copy];
        _setMethodCode = [allSpamPropertySetMethod copy];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@",@{@"property":_propertyCode,@"getMethodCode":_getMethodCode,@"setMethodCode":_setMethodCode,@"callMethodCode":_callMethodCode}];
}
@end
