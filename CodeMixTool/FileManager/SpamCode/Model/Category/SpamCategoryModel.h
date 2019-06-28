//
//  SpamCategoryModel.h
//  CodeMixTool
//
//  Created by 贾辰 on 2019/6/27.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface SpamCategoryModel : NSObject
@property (strong, nonatomic, readonly) NSString *propertyCode; // 属性代码(.h)
@property (strong, nonatomic, readonly) NSString *hMethodCode; // .h文件中方法声明
@property (strong, nonatomic, readonly) NSString *mMethodCode; // .m文件中方法实现
@property (strong, nonatomic, readonly) NSString *callMethodCode; // 方法调用
@end

NS_ASSUME_NONNULL_END
