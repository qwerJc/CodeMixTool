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
- (void)setSpamPropertyNum:(NSUInteger)num;
- (void)startMakeSpamCodeWithCodeFilePath:(NSString *)codeFilePath andProjPath:(NSString *)projPath;
@end

NS_ASSUME_NONNULL_END
