//
//  Model.h
//  CodeMixTool
//
//  Created by 贾辰 on 2019/4/2.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FunctionModel : NSObject
@property (strong, nonatomic, readonly) NSString *title;
@property (assign, nonatomic, readonly) BOOL isNeedParameter;
- (instancetype)initWithTitle:(NSString *)title andIsNeedParameter:(BOOL)isNeedParameter;
@end

NS_ASSUME_NONNULL_END
