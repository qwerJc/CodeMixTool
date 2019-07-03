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

///** 设置 代码中添加的垃圾 property数量 */
//- (void)setSpamPropertyNum:(NSRange)rangePropertyNum;
//
///** 设置 添加的垃圾Category中的property数量范围 和 Method数量范围 */
//- (void)setSpamCategoryOutPath:(NSString *)outPath andCategoryName:(NSString *)categoryName andPropertyNum:(NSRange)rangePropertyNum andMethodNum:(NSRange)rangeMethodNum;
//
///* 开始添加垃圾代码*/
//- (void)startMakeSpamCodeWithCodeFilePath:(NSString *)codeFilePath andProjPath:(NSString *)projPath;

- (void)startAddSpamCode;
@end

NS_ASSUME_NONNULL_END
