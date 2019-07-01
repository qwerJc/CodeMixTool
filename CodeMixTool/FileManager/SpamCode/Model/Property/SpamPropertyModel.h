//
//  SpamPropertyModel.h
//  CodeMixTool
//
//  Created by 贾辰 on 2019/6/26.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//objectiveType_void = 0,
//objectiveType_int,
//objectiveType_float,
//objectiveType_double,
//objectiveType_NSInteger,

typedef NS_ENUM(NSUInteger, objectiveType) {
    objectiveType_void = 0,
    objectiveType_int,
    objectiveType_float,
    objectiveType_double,
    objectiveType_char,
    objectiveType_NSInteger,
    
    objectiveType_NSObject,
    objectiveType_NSSet,
    objectiveType_NSArray,
    objectiveType_NSString,
    objectiveType_NSDictionary,
};

@interface SpamPropertyModel : NSObject
@property (strong, nonatomic, readonly) NSString *propertyCode; // 属性代码
@property (strong, nonatomic, readonly) NSString *getMethodCode; // 重写的get方法的代码
@property (strong, nonatomic, readonly) NSString *setMethodCode; // 重写的get方法的代码
@property (strong, nonatomic, readonly) NSString *callMethodCode; // 调用重写的get方法的代码

//- (instancetype)initWithPropertyNameLength:(NSUInteger)length;
- (instancetype)initWithPropertyNameLength:(NSRange)rangePropertyNameLength
                               PropertyNum:(NSRange)rangePropertyNum;
@end

NS_ASSUME_NONNULL_END
