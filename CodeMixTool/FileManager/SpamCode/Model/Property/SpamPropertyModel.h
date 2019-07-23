//
//  SpamPropertyModel.h
//  CodeMixTool
//
//  Created by 贾辰 on 2019/6/26.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpamPropertyModel : NSObject
@property (strong, nonatomic, readonly) NSString *propertyCode; // 属性代码
@property (strong, nonatomic, readonly) NSString *setMethodCode; // 重写的get方法的代码
@property (strong, nonatomic, readonly) NSString *callMethodCode; // 调用重写的get方法的代码

//- (instancetype)initWithPropertyNameLength:(NSUInteger)length;
- (instancetype)initWithPropertyNameLength:(NSRange)rangePropertyNameLength
                               PropertyNum:(NSRange)rangePropertyNum;
@end

NS_ASSUME_NONNULL_END
