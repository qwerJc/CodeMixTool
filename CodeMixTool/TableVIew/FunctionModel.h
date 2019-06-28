//
//  Model.h
//  CodeMixTool
//
//  Created by 贾辰 on 2019/4/2.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, EnumTaskType) {
    EnumTaskTypeAddFixClassPreName = 1 << 0,
    EnumTaskTypeAddRandomClassPreName = 1 << 1,
    EnumTaskTypeReplaceClassPreName = 1 << 2,
    
    EnumTaskTypeDelLog = 1 << 3,
};

@interface FunctionModel : NSObject
@property (strong, nonatomic, readonly) NSString *title;
@property (assign, nonatomic, readonly) BOOL isNeedParameter;
@property (assign, nonatomic) EnumTaskType task;
- (instancetype)initWithTitle:(NSString *)title andTask:(EnumTaskType)task andIsNeedParameter:(BOOL)isNeedParameter;
@end

NS_ASSUME_NONNULL_END
