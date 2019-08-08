//
//  MixedFunctionView.m
//  CodeMixTool
//
//  Created by 贾辰 on 2019/8/8.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import "MixedFunctionView.h"

@implementation MixedFunctionView

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    NSButton *btnRadioRandomClassName = [NSButton radioButtonWithTitle:@"随机类名" target:self action:@selector(onSelRandomClassName)];
    [self addSubview:btnRadioRandomClassName];
}
@end
