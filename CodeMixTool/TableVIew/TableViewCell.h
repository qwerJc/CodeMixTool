//
//  TableViewCell.h
//  CodeMixTool
//
//  Created by 贾辰 on 2019/4/2.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FunctionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TableViewCell : NSView
@property (strong, nonatomic) NSTextField *txfInfo;
@property (strong, nonatomic) NSButton *btncheckBox;
- (instancetype)initWithFrame:(NSRect)frameRect andTag:(EnumTaskType)tag andTitle:(NSString *)title andIsNeedParameter:(BOOL)isNeedParameter;
@end

NS_ASSUME_NONNULL_END
