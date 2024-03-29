//
//  Model.m
//  CodeMixTool
//
//  Created by 贾辰 on 2019/4/2.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import "FunctionModel.h"

@implementation FunctionModel
- (instancetype)initWithTitle:(NSString *)title andTask:(EnumTaskType)task andIsNeedParameter:(BOOL)isNeedParameter {
    self = [super init];
    if (self) {
        _title = title;
        _task = task;
        _isNeedParameter = isNeedParameter;
    }
    return self;
}
@end
