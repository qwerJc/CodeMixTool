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
- (instancetype)initWithPropertyNameLength:(NSUInteger)length {
    self = [super init];
    if (self) {
        
        NSUInteger typeIndex = arc4random()%10;
        
        NSString *propertyName = [[FileMixedHelper randomCapital] stringByAppendingString:[FileMixedHelper randomString:length-1]];
        
        // 带*的类型
        NSString *objectiveType = [SpamCodeTools getObjectiveTypeWithIndex:typeIndex];
        NSString *initCode = [SpamCodeTools getInitCodeWithClassIndex:typeIndex];
        
        NSString *tempVarName = [FileMixedHelper randomString:arc4random()%20+15];
        
        // Property Code
        NSString *strProperty = [NSString stringWithFormat:@"@property %@ %@%@;\n",[SpamCodeTools getPropertyCodeWithIndex:typeIndex],objectiveType,propertyName];
        _propertyCode = strProperty;
        
        // GetMethod Code
        NSString *strGetMethod = [NSString stringWithFormat:@"- (%@)%@ { \n    %@%@ = %@; \n    return %@;\n}\n",
                                  objectiveType,
                                  propertyName,
                                  objectiveType,
                                  tempVarName,
                                  initCode,
                                  tempVarName];
        _getMethodCode = strGetMethod;
        
        // SetMethod Code
        NSString *strSetMethod = [NSString stringWithFormat:@"- (void)set%@:(%@)%@ { \n    _%@ = %@; \n}\n",
                                  propertyName,
                                  objectiveType,
                                  tempVarName,
                                  propertyName,
                                  tempVarName];
        _setMethodCode = strSetMethod;
        
        // Call SpamCode]
        NSString *strCallCode = [NSString stringWithFormat:@"self.%@ = %@;\n",
                                 propertyName,
                                 [SpamCodeTools getInitCodeWithClassIndex:typeIndex]];
        _callMethodCode = strCallCode;

    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@",@{@"property":_propertyCode,@"getMethodCode":_getMethodCode,@"setMethodCode":_setMethodCode,@"callMethodCode":_callMethodCode}];
}
@end
