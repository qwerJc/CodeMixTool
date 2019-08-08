//
//  JJCNavigationController.m
//  CodeMixTool
//
//  Created by 贾辰 on 2019/8/8.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import "JJCNavigationController.h"
#import "ModelLocator.h"

@interface JJCNavigationController()
@property (strong, nonatomic) NSMutableArray<NSButton *> *marr;
@end

@implementation JJCNavigationController

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self createUI];
        [self createData];
    }
    return self;
}

- (void)createUI {
    
}

- (void)createData {
    _marr = [NSMutableArray arrayWithCapacity:0];
}

#pragma mark - Public
- (void)addItemWithTitle:(NSString *)title
        andBackgroundImg:(NSImage *)img
                  andTag:(NSInteger)tag {
    NSButton *btn = [[NSButton alloc] init];
//    [btn setWantsLayer:YES];
//    btn.layer.backgroundColor = [NSColor greenColor].CGColor;
    btn.target = self;
    [btn setAction:@selector(onBtnAction:)];
    [self addSubview:btn];
    [_marr addObject:btn];
    
    btn.title = title;
    btn.tag = tag;
    
    [self resizeFrame];
}
#pragma mark - Btn
- (void)onBtnAction:(NSButton *)btn {
    if ([self.delegate respondsToSelector:@selector(onClickItem:)]) {
        [self.delegate onClickItem:btn.tag];
    }
}
#pragma mark - Private
- (void)resizeFrame {
    if ([_marr count] > 0) {
        self.hidden = NO;
        CGFloat btnHeight = NSHeight(self.frame) / [_marr count];
        CGFloat btnOriginY = NSHeight(self.frame) - btnHeight;
        for (int i = 0; i < [_marr count]; i++) {
            [_marr[i] setFrame:NSMakeRect(0, btnOriginY - i*btnHeight, NSWidth(self.frame), btnHeight)];
        }
    } else {
        self.hidden = YES;
    }
    
}
@end
