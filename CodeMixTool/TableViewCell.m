//
//  TableViewCell.m
//  CodeMixTool
//
//  Created by 贾辰 on 2019/4/2.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import "TableViewCell.h"
@interface TableViewCell()
@property (strong, nonatomic) NSButton *btn;
@end

@implementation TableViewCell
- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self createUIWithTitle:@""
             andIsNeedParameter:NO];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect
                     andTitle:(NSString *)title
           andIsNeedParameter:(BOOL)isNeedParameter {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self createUIWithTitle:title
             andIsNeedParameter:isNeedParameter];
    }
    return self;
}

- (void)createUIWithTitle:(NSString *)title
       andIsNeedParameter:(BOOL)isNeedParameter {
    self.wantsLayer = true;///设置背景颜色
    self.layer.backgroundColor = [NSColor orangeColor].CGColor;
    [self setNeedsDisplay:YES];
    
    _btn = [NSButton checkboxWithTitle:title target:self action:nil];
    _btn.allowsMixedState = NO;
    [self addSubview:_btn];
    
//    NSButton *btnRadio2 = [NSButton radioButtonWithTitle:@"zzz" target:self action:@selector(changeChoseState:)];
//    NSLog(@"%ld",(long)btnRadio2.state);
//    [self addSubview:btnRadio2];
    
    if (isNeedParameter) {
        _txfInfo = [[NSTextField alloc] initWithFrame:CGRectMake(CGRectGetWidth(_btn.frame) + 20,0,300, 20)];
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
