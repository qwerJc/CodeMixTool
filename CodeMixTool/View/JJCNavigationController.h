//
//  JJCNavigationController.h
//  CodeMixTool
//
//  Created by 贾辰 on 2019/8/8.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

static const CGFloat kNavigationWidth = 90;
static const CGFloat kNavigationMarginLeft = 20;

NS_ASSUME_NONNULL_BEGIN
@protocol JJCNavigationControllerDelegate <NSObject>
@required
- (void)onClickItem:(NSUInteger)tag;
@end

@interface JJCNavigationController : NSView
@property (weak, nonatomic) id<JJCNavigationControllerDelegate> delegate;
- (void)addItemWithTitle:(NSString *)title andBackgroundImg:(NSImage *)img andTag:(NSInteger)tag;
@end

NS_ASSUME_NONNULL_END
