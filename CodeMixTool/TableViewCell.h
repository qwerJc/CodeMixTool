//
//  TableViewCell.h
//  CodeMixTool
//
//  Created by 贾辰 on 2019/4/2.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableViewCell : NSView
@property (strong, nonatomic) NSTextField *txfInfo;
- (instancetype)initWithFrame:(NSRect)frameRect andTitle:(NSString *)title andIsNeedParameter:(BOOL)isNeedParameter;
@end

NS_ASSUME_NONNULL_END
