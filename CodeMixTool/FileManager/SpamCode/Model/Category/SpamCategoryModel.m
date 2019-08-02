//
//  SpamCategoryModel.m
//  CodeMixTool
//
//  Created by 贾辰 on 2019/6/27.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import "SpamCategoryModel.h"
#import "FileMixedHelper.h"
#import "SpamCodeTools.h"

@interface SpamCategoryModel()
@property (strong, nonatomic) NSArray *arrMethodType;
@end

@implementation SpamCategoryModel
- (instancetype)initWithPropertyNameLength:(NSRange)rangePropertyNameLength
                               PropertyNum:(NSRange)rangePropertyNum
                           andMethodLength:(NSRange)rangeMethodNameLength
                              andMethodNum:(NSRange)rangeMethodNum {
    self = [super init];
    if (self) {
        
        _arrMethodType = [NSArray arrayWithObjects:@"-",@"+", nil];
        
        // 全部垃圾属性 初始化方法
        NSMutableString *callAllPropertyCode = [[NSMutableString alloc] initWithString:@"- (void)jjc_category_callAllAddProperty {\n    UIView *viewSum = [[UIView alloc] init];\n\n"];
        
        // 重写 get方法
        NSMutableString *allSpamPropertyCallMethod = [[NSMutableString alloc] initWithCapacity:0];
        // 垃圾 属性 合集
        NSInteger propertyNum = rangePropertyNum.location + arc4random()%rangePropertyNum.length;
        NSMutableString *sumPropertyCode = [NSMutableString stringWithString:@""];
//        for (int i=0; i<propertyNum; i++) {
//            NSUInteger typeIndex = arc4random()%12;
//            NSString *propertyName = [FileMixedHelper randomWordPropertyName];
//            
//            NSInteger randomPropertyNameLength = rangePropertyNameLength.location + arc4random()%rangePropertyNameLength.length;
////            NSString *propertyName = [SpamCodeTools getRandomPropertyNameWithLength:randomPropertyNameLength];
//            
//            NSString *tempPropertyCode = [SpamCodeTools getPropertyCodeWithName:propertyName andPropertyType:typeIndex];
//            
//            [sumPropertyCode appendString:tempPropertyCode];
//            
//            // 添加调用方法
////            NSString *strCallCode = [NSString stringWithFormat:@"    self.%@ = %@;\n",
////                                     propertyName,
////                                     [SpamCodeTools getInitCodeWithClassIndex:typeIndex]];
//            if (typeIndex > 6) {
//                [callAllPropertyCode appendString:[SpamCodeTools addCallMethodWithTypeIndex:typeIndex andPropertyName:[NSString stringWithFormat:@"%@_%@",[FileMixedHelper sharedHelper].modelSpamCode.categoryName,propertyName]]];
//            } else {
//                [callAllPropertyCode appendString:[SpamCodeTools addCallMethodWithTypeIndex:typeIndex andPropertyName:propertyName]];
//            }
//            
//            
//            // 由于category的特殊性
//            if (typeIndex > 6) {
//                // 重写 Get方法
//                [allSpamPropertyCallMethod appendString:[self addOverWriteGetMethodWithTypeIndex:typeIndex
//                                                                                 andPropertyName:propertyName
//                                                                                 andCategoryName:[FileMixedHelper sharedHelper].modelSpamCode.categoryName]];
//            }
//            
//           
//        }
        [callAllPropertyCode appendString:@"}\n"];
        _propertyCode = [sumPropertyCode copy];
        _callMethodCode = [callAllPropertyCode copy];
        _getMethodCode = [allSpamPropertyCallMethod copy];
        
        // 垃圾 类/成员方法-声明 合集
        // 声明代码
        NSMutableString *methodDeclarationCode = [[NSMutableString alloc] init];
        // 方法 实现代码
        NSMutableString *methodRealizationCode = [[NSMutableString alloc] init];
        
        NSInteger methodNum = rangeMethodNum.location + arc4random()%rangeMethodNum.length;
        for (int i =0; i < methodNum; i++) {
            NSInteger methodNameLength = rangeMethodNameLength.location + arc4random()%rangeMethodNameLength.length;
//            NSString *methodName = [SpamCodeTools getRandomMethodNameWithLength:methodNameLength];
            NSString *methodName = [FileMixedHelper randomWordMethodName];
            // 返回值类型
            NSUInteger returnType = arc4random()%8;
            
            // 参数名（为nil时则没有参数）
            NSString *paramName;
            if (returnType > 0 && arc4random()%3 > 0) {
//                paramName = [SpamCodeTools getRandomPropertyNameWithLength:25];
                paramName = [FileMixedHelper randomWordPropertyName];
            }
            
            
            NSString *methodCode = [SpamCodeTools getSpamMethodCodeWithMethodName:methodName
                                                                    andReturnType:returnType
                                                                     andParamName:paramName];
            // 方法 声明代码
            [methodDeclarationCode appendString:[NSString stringWithFormat:@"%@;\n",methodCode]];
            
            NSString *spamRealizationCode = [SpamCodeTools getRealizationCodeWithReturnType:returnType andParamName:paramName];
            
            // 方法 实现代码
            [methodRealizationCode appendString:[NSString stringWithFormat:@"\n%@ {\n    %@\n}\n",methodCode,spamRealizationCode]];
            
            
        }
        
        
        _hMethodCode = [methodDeclarationCode copy];
        _mMethodCode = [methodRealizationCode copy];
        
        
    }
    return self;
}

#pragma mark - 重写
- (NSString *)addOverWriteGetMethodWithTypeIndex:(NSInteger)index andPropertyName:(NSString *)propertyName andCategoryName:(NSString *)categoryName {
    NSString *strOverWriteMethod = @"";
    
    NSString *newGetMethodName = @"";
    if (categoryName.length > 0) {
        newGetMethodName = [NSString stringWithFormat:@"%@_%@",categoryName,propertyName];
    } else {
        newGetMethodName = propertyName;
    }
    
    switch (index) {
        case EnumObjectType_NSInteger:
        case EnumObjectType_BOOL:
            break;
            
        case EnumObjectType_NSObject:
        case EnumObjectType_NSSet:
        case EnumObjectType_NSArray:
        case EnumObjectType_NSString:
        case EnumObjectType_NSDictionary:
            strOverWriteMethod = [NSString stringWithFormat:@"- (%@)%@ { \n    if (!self.%@) {\n        self.%@ = %@; \n    }\n    return _%@;\n}\n",
                                  [SpamCodeTools getObjectiveTypeWithIndex:index],
                                  newGetMethodName,
                                  propertyName,
                                  propertyName,
                                  [SpamCodeTools getInitCodeWithClassIndex:index],
                                  propertyName];
            break;
            
        case EnumObjectType_UIView:
            strOverWriteMethod = [NSString stringWithFormat:@"- (%@)%@ { \n    if (!self.%@) {\n%@\n    }\n    return self.%@;\n}\n",
                                  [SpamCodeTools getObjectiveTypeWithIndex:index],
                                  newGetMethodName,
                                  propertyName,
                                  [self getViewInitSpamCodeWithName:propertyName],
                                  propertyName];
            break;
        case EnumObjectType_UILabel:
            strOverWriteMethod = [NSString stringWithFormat:@"- (%@)%@ { \n    if (!self.%@) {\n%@\n    }\n    return self.%@;\n}\n",
                                  [SpamCodeTools getObjectiveTypeWithIndex:index],
                                  newGetMethodName,
                                  propertyName,
                                  [self getUILabelInitSpamCodeWithName:propertyName],
                                  propertyName];
            break;
        case EnumObjectType_UIImageView:
            strOverWriteMethod = [NSString stringWithFormat:@"- (%@)%@ { \n    if (!self.%@) {\n%@\n    }\n    return self.%@;\n}\n",
                                  [SpamCodeTools getObjectiveTypeWithIndex:index],
                                  newGetMethodName,
                                  propertyName,
                                  [self getUIImageViewInitSpamCodeWithName:propertyName],
                                  propertyName];
            break;
        case EnumObjectType_ScrollView:
            strOverWriteMethod = [NSString stringWithFormat:@"- (%@)%@ { \n    if (!self.%@) {\n%@\n    }\n    return self.%@;\n}\n",
                                  [SpamCodeTools getObjectiveTypeWithIndex:index],
                                  newGetMethodName,
                                  propertyName,
                                  [self getScrollViewInitSpamCodeWithName:propertyName],
                                  propertyName];
            break;
        case EnumObjectType_UITextField:
            strOverWriteMethod = [NSString stringWithFormat:@"- (%@)%@ { \n    if (!self.%@) {\n%@\n    }\n    return self.%@;\n}\n",
                                  [SpamCodeTools getObjectiveTypeWithIndex:index],
                                  newGetMethodName,
                                  propertyName,
                                  [self getUITextFieldInitSpamCodeWithName:propertyName],
                                  propertyName];
            break;
        case EnumObjectType_UITextView:
            strOverWriteMethod = [NSString stringWithFormat:@"- (%@)%@ { \n    if (!self.%@) {\n%@\n    }\n    return self.%@;\n}\n",
                                  [SpamCodeTools getObjectiveTypeWithIndex:index],
                                  newGetMethodName,
                                  propertyName,
                                  [self getUITextViewInitSpamCodeWithName:propertyName],
                                  propertyName];
            break;
    }
    return strOverWriteMethod;
}

- (NSString *)getUITextViewInitSpamCodeWithName:(NSString *)name {
    NSMutableString *initCode = [[NSMutableString alloc] initWithCapacity:0];
    
    NSUInteger initType = arc4random()%2;
    if (initType == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@ = [[UITextView alloc] init];\n",name]];
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.frame = CGRectMake(%d, %d, %d, %d);\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
    } else {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@ = [[UITextView alloc] initWithFrame:CGRectMake(%d, %d, %d, %d)];\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
    }
    
    if (arc4random()%5 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.bounds = CGRectMake(%d, %d, %d, %d);\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.backgroundColor = [UIColor colorWithRed:%d green:%d blue:%d alpha:1.0];\n",name,arc4random()%2,arc4random()%2,arc4random()%2]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.alpha = %.1f;\n",name,(arc4random()%9+1)*1.0/10]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [self.%@.layer setCornerRadius:10.0];\n        self.%@.layer.masksToBounds = YES;\n",name,name]];
    }
    
    if (arc4random()%4 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [self.%@ setFont:[UIFont systemFontOfSize:%d]];\n",name,arc4random()%9+8]];
    }
    
    if (arc4random()%4 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [self.%@ setTextColor:[UIColor colorWithRed:%d green:%d blue:%d alpha:1.0]];\n",name,arc4random()%2,arc4random()%2,arc4random()%2]];
    }
    
    if (arc4random()%4 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.layoutManager.allowsNonContiguousLayout = NO;\n",name]];
    }
    
    if (arc4random()%4 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.tintColor = [UIColor colorWithRed:%d green:%d blue:%d alpha:1.0];\n",name,arc4random()%2,arc4random()%2,arc4random()%2]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.textContainerInset = UIEdgeInsetsZero;\n",name]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.keyboardDismissMode           = UIScrollViewKeyboardDismissModeOnDrag;\n",name]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.alwaysBounceVertical          = NO;\n",name]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.showsVerticalScrollIndicator  = NO;\n",name]];
    }
    
    if (arc4random()%4 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [self.%@ setEditable:YES];\n",name]];
    }
    
    return [initCode copy];
}
- (NSString *)getUITextFieldInitSpamCodeWithName:(NSString *)name {
    NSMutableString *initCode = [[NSMutableString alloc] initWithCapacity:0];
    
    NSUInteger initType = arc4random()%2;
    if (initType == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@ = [[UITextField alloc] init];\n",name]];
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.frame = CGRectMake(%d, %d, %d, %d);\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
    } else {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@ = [[UITextField alloc] initWithFrame:CGRectMake(%d, %d, %d, %d)];\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
    }
    
    if (arc4random()%4 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.backgroundColor = [UIColor colorWithRed:%d green:%d blue:%d alpha:1.0];\n",name,arc4random()%2,arc4random()%2,arc4random()%2]];
    }
    
    if (arc4random()%4 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.alpha = %.1f;\n",name,(arc4random()%9+1)*1.0/10]];
    }
    
    if (arc4random()%3 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [self.%@ setPlaceholder:@\"%@\"];\n",name,[FileMixedHelper randomWordWithIndex:0]]];
    }
    
    if (arc4random()%3 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [self.%@ setBorderStyle:UITextBorderStyleNone];\n",name]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [self.%@ setFont:[UIFont systemFontOfSize:%d]];\n",name,arc4random()%9+8]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [self.%@ setTextColor:[UIColor colorWithRed:%d green:%d blue:%d alpha:1.0]];\n",name,arc4random()%2,arc4random()%2,arc4random()%2]];
    }
    
    if (arc4random()%4 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.center = CGPointMake(%d, %d);\n",name,arc4random()%100,arc4random()%100]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [self.%@ setReturnKeyType:UIReturnKeyDone];\n",name]];
    }
    
    if (arc4random()%4 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.leftViewMode = UITextFieldViewModeAlways;\n",name]];
    }
    
    if (arc4random()%4 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.leftView = [[UIView alloc] initWithFrame:CGRectMake(%d, %d, %d, %d)];\n",name,arc4random()%100,arc4random()%100,arc4random()%50,arc4random()%50]];
    }
    
    if (arc4random()%3 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;\n",name]];
    }
    
    if (arc4random()%3 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.clearButtonMode = UITextFieldViewModeWhileEditing;\n",name]];
    }
    
    if (arc4random()%3 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.returnKeyType = UIReturnKeySearch;\n",name]];
    }
    
    if (arc4random()%3 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.enablesReturnKeyAutomatically = YES;\n",name]];
    }
    
    if (arc4random()%3 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.autocorrectionType = UITextAutocorrectionTypeNo;\n",name]];
    }
    
    if (arc4random()%3 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.autocapitalizationType = UITextAutocapitalizationTypeNone;\n",name]];
    }
    
    return [initCode copy];
}
- (NSString *)getScrollViewInitSpamCodeWithName:(NSString *)name {
    // 初始化
    //    if (scrollView.contentOffset.x < 0) {
    //        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
    //    }
    
    NSMutableString *initCode = [[NSMutableString alloc] initWithCapacity:0];
    
    NSUInteger initType = arc4random()%2;
    if (initType == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@ = [[UIScrollView alloc] init];\n",name]];
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.frame = CGRectMake(%d, %d, %d, %d);\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
    } else {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@ = [[UIScrollView alloc] initWithFrame:CGRectMake(%d, %d, %d, %d)];\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
    }
    
    if (arc4random()%5 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.bounds = CGRectMake(%d, %d, %d, %d);\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.backgroundColor = [UIColor colorWithRed:%d green:%d blue:%d alpha:1.0];\n",name,arc4random()%2,arc4random()%2,arc4random()%2]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.alpha = %.1f;\n",name,(arc4random()%9+1)*1.0/10]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [self.%@.layer setCornerRadius:1.0];\n        self.%@.layer.masksToBounds = YES;\n",name,name]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [self.%@ setContentSize:CGSizeMake(CGRectGetWidth(self.%@.frame)*%d, CGRectGetWidth(self.%@.frame)*%d)];\n",name,name,arc4random()%5,name,arc4random()%5]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [self.%@ setPagingEnabled:YES];\n",name]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [self.%@ setBounces:NO];\n",name]];
    }
    return [initCode copy];
}
- (NSString *)getUIImageViewInitSpamCodeWithName:(NSString *)name {
    NSMutableString *initCode = [[NSMutableString alloc] initWithCapacity:0];
    
    NSMutableString *imgName = [[NSMutableString alloc] initWithCapacity:0];
    [imgName appendString:[FileMixedHelper randomWordWithIndex:1]];
    for (int i = 0; i<(arc4random()%4+2); i++) {
        [imgName appendString:[NSString stringWithFormat:@"self.%@",[FileMixedHelper randomWordWithIndex:0]]];
    }
    [imgName appendString:@".png"];
    
    NSMutableString *imgName2 = [[NSMutableString alloc] initWithCapacity:0];
    [imgName2 appendString:[FileMixedHelper randomWordWithIndex:1]];
    for (int i = 0; i<(arc4random()%4+2); i++) {
        [imgName2 appendString:[NSString stringWithFormat:@"self.%@",[FileMixedHelper randomWordWithIndex:0]]];
    }
    [imgName2 appendString:@".png"];
    
    NSUInteger initType = arc4random()%4;
    if (initType == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@ = [[UIImageView alloc] init];\n",name]];
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.frame = CGRectMake(%d, %d, %d, %d);\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.image = [UIImage imageNamed:@\"%@\"];\n",name,imgName]];
    } else if (initType == 1) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@ = [[UIImageView alloc] initWithFrame:CGRectMake(%d, %d, %d, %d)];\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.image = [UIImage imageNamed:@\"%@\"];\n",name,imgName]];
    } else if (initType == 2) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@\"%@\"]];\n",name,imgName]];
    } else {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@\"%@\"] highlightedImage:[UIImage imageNamed:@\"%@\"]];\n",name,imgName,imgName2]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.backgroundColor = [UIColor colorWithRed:%d green:%d blue:%d alpha:1.0];\n",name,arc4random()%2,arc4random()%2,arc4random()%2]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.alpha = %.1f;\n",name,(arc4random()%9+1)*1.0/10]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [self.%@.layer setCornerRadius:10.0];\n        self.%@.layer.masksToBounds = YES;\n",name,name]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.userInteractionEnabled = YES;\n",name]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.multipleTouchEnabled = YES;\n",name]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.animationRepeatCount = %d;\n",name,arc4random()%6]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.center = CGPointMake(%d, %d);\n",name,arc4random()%200,arc4random()%200]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.animationRepeatCount = %d;\n",name,arc4random()%6]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [self.%@ setContentMode:UIViewContentModeCenter];\n",name]];
    }
    
    return [initCode copy];
}

- (NSString *)getUILabelInitSpamCodeWithName:(NSString *)name {
    NSMutableString *initCode = [[NSMutableString alloc] initWithCapacity:0];
    
    NSUInteger initType = arc4random()%2;
    if (initType == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@ = [[UILabel alloc] init];\n",name]];
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.frame = CGRectMake(%d, %d, %d, %d);\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
    } else {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@ = [[UILabel alloc] initWithFrame:CGRectMake(%d, %d, %d, %d)];\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
    }
    
    if (arc4random()%3 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.bounds = CGRectMake(%d, %d, %d, %d);\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
    }
    
    if (arc4random()%3 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.backgroundColor = [UIColor colorWithRed:%d green:%d blue:%d alpha:1.0];\n",name,arc4random()%2,arc4random()%2,arc4random()%2]];
    }
    
    if (arc4random()%4 > 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.text = @\"%@\";\n",name,[FileMixedHelper randomWordWithIndex:0]]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.textColor = [UIColor colorWithRed:%d green:%d blue:%d alpha:1.0];\n",name,arc4random()%2,arc4random()%2,arc4random()%2]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.alpha = %.1f;\n",name,(arc4random()%9+1)*1.0/10]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.textAlignment = NSTextAlignmentCenter;\n",name]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [self.%@ sizeToFit];\n",name]];
    }
    
    return [initCode copy];
}

- (NSString *)getViewInitSpamCodeWithName:(NSString *)name {
    NSMutableString *initCode = [[NSMutableString alloc] initWithCapacity:0];
    
    NSUInteger initType = arc4random()%2;
    if (initType == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@ = [[UIView alloc] init];\n",name]];
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.frame = CGRectMake(%d, %d, %d, %d);\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
    } else {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@ = [[UIView alloc] initWithFrame:CGRectMake(%d, %d, %d, %d)];\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
    }
    
    if (arc4random()%3 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.bounds = CGRectMake(%d, %d, %d, %d);\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.backgroundColor = [UIColor colorWithRed:%d green:%d blue:%d alpha:1.0];\n",name,arc4random()%2,arc4random()%2,arc4random()%2]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        self.%@.alpha = %.1f;\n",name,(arc4random()%9+1)*1.0/10]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [self.%@.layer setCornerRadius:1.0];\n        self.%@.layer.masksToBounds = YES;\n",name,name]];
    }
    return [initCode copy];
}


@end
