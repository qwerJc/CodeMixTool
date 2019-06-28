//
//  TableViewCell.m
//  CodeMixTool
//
//  Created by 贾辰 on 2019/4/2.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import "TableViewCell.h"


@interface TableViewCell()

@end

@implementation TableViewCell
- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self createUIWithTitle:@""
                         andTag:0
             andIsNeedParameter:NO];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect
                       andTag:(EnumTaskType)tag
                     andTitle:(NSString *)title
           andIsNeedParameter:(BOOL)isNeedParameter {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self createUIWithTitle:title
                         andTag:tag
             andIsNeedParameter:isNeedParameter];
    }
    return self;
}

- (void)createUIWithTitle:(NSString *)title
                   andTag:(EnumTaskType)tag
       andIsNeedParameter:(BOOL)isNeedParameter {
    self.wantsLayer = true;///设置背景颜色
    self.layer.backgroundColor = [NSColor orangeColor].CGColor;
    [self setNeedsDisplay:YES];
    
    _btncheckBox = [NSButton checkboxWithTitle:title target:self action:nil];
    _btncheckBox.allowsMixedState = NO;
    _btncheckBox.tag = tag;
    [self addSubview:_btncheckBox];
        
    if (isNeedParameter) {
        _txfInfo = [[NSTextField alloc] initWithFrame:CGRectMake(CGRectGetWidth(_btncheckBox.frame) + 20,0,300, 20)];
        [_txfInfo setStringValue:@"选择子文件夹的绝对路径"];
        [_txfInfo setBezeled:NO];
        [_txfInfo setDrawsBackground:NO];
        [_txfInfo setEditable:YES];
        [_txfInfo setSelectable:NO];
        [self addSubview:_txfInfo];
    }
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
