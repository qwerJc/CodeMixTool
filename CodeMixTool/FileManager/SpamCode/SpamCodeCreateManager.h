//
//  SpamCodeCreateManager.h
//  CodeMixTool
//
//  Created by 贾辰 on 2019/6/25.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpamCodeCreateManager : NSObject

/** 设置 代码中添加的垃圾 property数量 */
- (void)setSpamPropertyNum:(NSUInteger)num;

/** 设置 添加的垃圾Category中的property数量范围 和 Method数量范围 */
- (void)setSpamCategoryPropertyNum:(NSRange)rangePropertyNum andMethodNum:(NSRange)rangeMethodNum;

- (void)startMakeSpamCodeWithCodeFilePath:(NSString *)codeFilePath andProjPath:(NSString *)projPath;
@end

NS_ASSUME_NONNULL_END
