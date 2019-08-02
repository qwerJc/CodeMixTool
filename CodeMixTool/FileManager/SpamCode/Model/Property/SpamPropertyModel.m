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

@interface SpamPropertyModel()
@property (strong, nonatomic) NSMutableString *allSpamPropertyCallMethod;// 重写的Get方法
@property (strong, nonatomic) NSMutableString *callAllPropertyCode;
@end

@implementation SpamPropertyModel
- (instancetype)initWithPropertyNameLength:(NSRange)rangePropertyNameLength
                               PropertyNum:(NSRange)rangePropertyNum {
    self = [super init];
    if (self) {
        // 全部垃圾属性 初始化方法
        _callAllPropertyCode = [[NSMutableString alloc] initWithString:@""];
        
        _allSpamPropertyCallMethod = [[NSMutableString alloc] initWithCapacity:0];
        
        // 垃圾 属性 合集
        NSInteger propertyNum = rangePropertyNum.location + arc4random()%rangePropertyNum.length;
        NSMutableString *sumPropertyCode = [NSMutableString stringWithString:@""];
        for (int i=0; i<propertyNum; i++) {
            NSUInteger typeIndex = arc4random()%12;
            NSInteger randomPropertyNameLength = rangePropertyNameLength.location + arc4random()%rangePropertyNameLength.length;
//            NSString *tempVarName = [FileMixedHelper randomString:arc4random()%20+15]; // set方法需要的临时变量
            
            
            NSString *propertyName = [SpamCodeTools getPropertyNameWithIndex:typeIndex];
            NSString *tempPropertyCode = [SpamCodeTools getPropertyCodeWithName:propertyName andPropertyType:typeIndex];
            
            [sumPropertyCode appendString:tempPropertyCode];
            
            [_callAllPropertyCode appendString:[SpamCodeTools addCallMethodWithTypeIndex:typeIndex andPropertyName:propertyName]];
            
            [_allSpamPropertyCallMethod appendString:[SpamCodeTools addOverWriteGetMethodWithTypeIndex:typeIndex andPropertyName:propertyName andCategoryName:@""]];
        }
        
        

        _propertyCode = [sumPropertyCode copy];
        _callMethodCode = [_callAllPropertyCode copy];
        _setMethodCode = [_allSpamPropertyCallMethod copy];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@",@{@"property":_propertyCode,@"setMethodCode":_setMethodCode,@"callMethodCode":_callMethodCode}];
}
@end
