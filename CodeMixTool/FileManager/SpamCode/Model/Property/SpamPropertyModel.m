//
//  SpamPropertyModel.m
//  CodeMixTool
//
//  Created by 贾辰 on 2019/6/26.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import "SpamPropertyModel.h"
#import "FileMixedHelper.h"
#import "SpamCodeTools.h"

@interface SpamPropertyModel()
@property (strong, nonatomic) NSMutableString *allSpamPropertyCallMethod;// 重写的Get方法
@property (strong, nonatomic) NSMutableString *callAllPropertyCode;
@end

@implementation SpamPropertyModel
- (instancetype)initWithPropertyNameLength:(NSRange)rangePropertyNameLength
                               PropertyNum:(NSRange)rangePropertyNum {
    self = [super init];
    if (self) {
        // 全部垃圾属性 初始化方法
        _callAllPropertyCode = [[NSMutableString alloc] initWithString:@""];
        
        _allSpamPropertyCallMethod = [[NSMutableString alloc] initWithCapacity:0];
        
        // 垃圾 属性 合集
        NSInteger propertyNum = rangePropertyNum.location + arc4random()%rangePropertyNum.length;
        NSMutableString *sumPropertyCode = [NSMutableString stringWithString:@""];
        for (int i=0; i<propertyNum; i++) {
            NSUInteger typeIndex = arc4random()%12;
            NSInteger randomPropertyNameLength = rangePropertyNameLength.location + arc4random()%rangePropertyNameLength.length;
//            NSString *tempVarName = [FileMixedHelper randomString:arc4random()%20+15]; // set方法需要的临时变量
            
            
            NSString *propertyName = [SpamCodeTools getPropertyNameWithIndex:typeIndex];
            NSString *tempPropertyCode = [SpamCodeTools getPropertyCodeWithName:propertyName andPropertyType:typeIndex];
            
            [sumPropertyCode appendString:tempPropertyCode];
            
            [self addCallMethodWithTypeIndex:typeIndex andPropertyName:propertyName];
            
            [self addOverWriteGetMethodWithTypeIndex:typeIndex andPropertyName:propertyName];
        }
        
        

        _propertyCode = [sumPropertyCode copy];
        _callMethodCode = [_callAllPropertyCode copy];
        _setMethodCode = [_allSpamPropertyCallMethod copy];
    }
    return self;
}

- (void)addCallMethodWithTypeIndex:(NSInteger)index andPropertyName:(NSString *)propertyName {

    NSString *strCallCode;
    switch (index) {
        case EnumObjectType_NSInteger:
            strCallCode = [NSString stringWithFormat:@"    self.%@ = %@;\n",
                           propertyName,
                           [NSString stringWithFormat:@"%@%@%@%@",[FileMixedHelper randomNum],[FileMixedHelper randomNum],[FileMixedHelper randomNum],[FileMixedHelper randomNum]]];
            [_callAllPropertyCode appendString:strCallCode];
            break;
        case EnumObjectType_BOOL:
            strCallCode = [NSString stringWithFormat:@"    self.%@ = @\"YES\";\n",
                           propertyName];
            [_callAllPropertyCode appendString:strCallCode];
            break;
            
        case EnumObjectType_NSObject:
            strCallCode = [NSString stringWithFormat:@"    self.%@ = [[NSObject alloc] init];\n",
                           propertyName];
            [_callAllPropertyCode appendString:strCallCode];
            break;
        case EnumObjectType_NSSet:
            strCallCode = [NSString stringWithFormat:@"    self.%@ = [[NSSet alloc] init];\n",
                           propertyName];
            [_callAllPropertyCode appendString:strCallCode];
            break;
        case EnumObjectType_NSArray:
            strCallCode = [NSString stringWithFormat:@"    self.%@ = [NSArray array];\n",
                           propertyName];
            [_callAllPropertyCode appendString:strCallCode];
            break;
        case EnumObjectType_NSString:
            strCallCode = [NSString stringWithFormat:@"    self.%@ = @\"%@\";\n",
                           propertyName,[FileMixedHelper randomString:10]];
            [_callAllPropertyCode appendString:strCallCode];
            break;
        case EnumObjectType_NSDictionary:
            strCallCode = [NSString stringWithFormat:@"    self.%@ = [[NSDictionary alloc] init];\n",
                           propertyName];
            [_callAllPropertyCode appendString:strCallCode];
            break;
            
        case EnumObjectType_UIView:
        case EnumObjectType_UILabel:
        case EnumObjectType_UIImageView:
        case EnumObjectType_ScrollView:
        case EnumObjectType_UITextField:
        case EnumObjectType_UITextView:
            strCallCode = [NSString stringWithFormat:@"    [viewSum addSubview:self.%@];\n",
                           propertyName];
            [_callAllPropertyCode appendString:strCallCode];
            break;
    }
}

- (void)addOverWriteGetMethodWithTypeIndex:(NSInteger)index andPropertyName:(NSString *)propertyName {
    NSString *strOverWriteMethod;
    
    switch (index) {
        case EnumObjectType_NSInteger:
        case EnumObjectType_BOOL:
            break;
        
        case EnumObjectType_NSObject:
        case EnumObjectType_NSSet:
        case EnumObjectType_NSArray:
        case EnumObjectType_NSString:
        case EnumObjectType_NSDictionary:
            strOverWriteMethod = [NSString stringWithFormat:@"- (%@)%@ { \n    if (!_%@) {\n        _%@ = %@; \n    }\n    return _%@;\n}\n",
                                  [SpamCodeTools getObjectiveTypeWithIndex:index],
                                  propertyName,
                                  propertyName,
                                  propertyName,
                                  [SpamCodeTools getInitCodeWithClassIndex:index],
                                  propertyName];
            [_allSpamPropertyCallMethod appendString:strOverWriteMethod];
            break;
            
        case EnumObjectType_UIView:
            strOverWriteMethod = [NSString stringWithFormat:@"- (%@)%@ { \n    if (!_%@) {\n%@\n    }\n    return _%@;\n}\n",
                                  [SpamCodeTools getObjectiveTypeWithIndex:index],
                                  propertyName,
                                  propertyName,
                                  [self getViewInitSpamCodeWithName:propertyName],
                                  propertyName];
            [_allSpamPropertyCallMethod appendString:strOverWriteMethod];
            break;
        case EnumObjectType_UILabel:
            strOverWriteMethod = [NSString stringWithFormat:@"- (%@)%@ { \n    if (!_%@) {\n%@\n    }\n    return _%@;\n}\n",
                                  [SpamCodeTools getObjectiveTypeWithIndex:index],
                                  propertyName,
                                  propertyName,
                                  [self getUILabelInitSpamCodeWithName:propertyName],
                                  propertyName];
            [_allSpamPropertyCallMethod appendString:strOverWriteMethod];
            break;
        case EnumObjectType_UIImageView:
            strOverWriteMethod = [NSString stringWithFormat:@"- (%@)%@ { \n    if (!_%@) {\n%@\n    }\n    return _%@;\n}\n",
                                  [SpamCodeTools getObjectiveTypeWithIndex:index],
                                  propertyName,
                                  propertyName,
                                  [self getUIImageViewInitSpamCodeWithName:propertyName],
                                  propertyName];
            [_allSpamPropertyCallMethod appendString:strOverWriteMethod];
            break;
        case EnumObjectType_ScrollView:
            strOverWriteMethod = [NSString stringWithFormat:@"- (%@)%@ { \n    if (!_%@) {\n%@\n    }\n    return _%@;\n}\n",
                                  [SpamCodeTools getObjectiveTypeWithIndex:index],
                                  propertyName,
                                  propertyName,
                                  [self getScrollViewInitSpamCodeWithName:propertyName],
                                  propertyName];
            [_allSpamPropertyCallMethod appendString:strOverWriteMethod];
            break;
        case EnumObjectType_UITextField:
            strOverWriteMethod = [NSString stringWithFormat:@"- (%@)%@ { \n    if (!_%@) {\n%@\n    }\n    return _%@;\n}\n",
                                  [SpamCodeTools getObjectiveTypeWithIndex:index],
                                  propertyName,
                                  propertyName,
                                  [self getUITextFieldInitSpamCodeWithName:propertyName],
                                  propertyName];
            [_allSpamPropertyCallMethod appendString:strOverWriteMethod];
            break;
        case EnumObjectType_UITextView:
            strOverWriteMethod = [NSString stringWithFormat:@"- (%@)%@ { \n    if (!_%@) {\n%@\n    }\n    return _%@;\n}\n",
                                  [SpamCodeTools getObjectiveTypeWithIndex:index],
                                  propertyName,
                                  propertyName,
                                  [self getUITextViewInitSpamCodeWithName:propertyName],
                                  propertyName];
            [_allSpamPropertyCallMethod appendString:strOverWriteMethod];
            break;
    }
}

- (NSString *)getUITextViewInitSpamCodeWithName:(NSString *)name {
    NSMutableString *initCode = [[NSMutableString alloc] initWithCapacity:0];
    
    NSUInteger initType = arc4random()%2;
    if (initType == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@ = [[UITextView alloc] init];\n",name]];
        [initCode appendString:[NSString stringWithFormat:@"        _%@.frame = CGRectMake(%d, %d, %d, %d);\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
    } else {
        [initCode appendString:[NSString stringWithFormat:@"        _%@ = [[UITextView alloc] initWithFrame:CGRectMake(%d, %d, %d, %d)];\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
    }
    
    if (arc4random()%5 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.bounds = CGRectMake(%d, %d, %d, %d);\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.backgroundColor = [UIColor colorWithRed:%d green:%d blue:%d alpha:1.0];\n",name,arc4random()%2,arc4random()%2,arc4random()%2]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.alpha = %.1f;\n",name,(arc4random()%9+1)*1.0/10]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [_%@.layer setCornerRadius:10.0];\n        _%@.layer.masksToBounds = YES;\n",name,name]];
    }
    
    if (arc4random()%4 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [_%@ setFont:[UIFont systemFontOfSize:%d]];\n",name,arc4random()%9+8]];
    }
    
    if (arc4random()%4 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [_%@ setTextColor:[UIColor colorWithRed:%d green:%d blue:%d alpha:1.0]];\n",name,arc4random()%2,arc4random()%2,arc4random()%2]];
    }
    
    if (arc4random()%4 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.layoutManager.allowsNonContiguousLayout = NO;\n",name]];
    }

    if (arc4random()%4 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.tintColor = [UIColor colorWithRed:%d green:%d blue:%d alpha:1.0];\n",name,arc4random()%2,arc4random()%2,arc4random()%2]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.textContainerInset = UIEdgeInsetsZero;\n",name]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.keyboardDismissMode           = UIScrollViewKeyboardDismissModeOnDrag;\n",name]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.alwaysBounceVertical          = NO;\n",name]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.showsVerticalScrollIndicator  = NO;\n",name]];
    }
    
    if (arc4random()%4 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [_%@ setEditable:YES];\n",name]];
    }

    return [initCode copy];
}
- (NSString *)getUITextFieldInitSpamCodeWithName:(NSString *)name {
    NSMutableString *initCode = [[NSMutableString alloc] initWithCapacity:0];
    
    NSUInteger initType = arc4random()%2;
    if (initType == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@ = [[UITextField alloc] init];\n",name]];
        [initCode appendString:[NSString stringWithFormat:@"        _%@.frame = CGRectMake(%d, %d, %d, %d);\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
    } else {
        [initCode appendString:[NSString stringWithFormat:@"        _%@ = [[UITextField alloc] initWithFrame:CGRectMake(%d, %d, %d, %d)];\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
    }
    
    if (arc4random()%4 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.backgroundColor = [UIColor colorWithRed:%d green:%d blue:%d alpha:1.0];\n",name,arc4random()%2,arc4random()%2,arc4random()%2]];
    }
    
    if (arc4random()%4 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.alpha = %.1f;\n",name,(arc4random()%9+1)*1.0/10]];
    }
    
    if (arc4random()%3 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [_%@ setPlaceholder:@\"%@\"];\n",name,[FileMixedHelper randomWordWithIndex:0]]];
    }
    
    if (arc4random()%3 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [_%@ setBorderStyle:UITextBorderStyleNone];\n",name]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [_%@ setFont:[UIFont systemFontOfSize:%d]];\n",name,arc4random()%9+8]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [_%@ setTextColor:[UIColor colorWithRed:%d green:%d blue:%d alpha:1.0]];\n",name,arc4random()%2,arc4random()%2,arc4random()%2]];
    }

    if (arc4random()%4 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.center = CGPointMake(%d, %d);\n",name,arc4random()%100,arc4random()%100]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [_%@ setReturnKeyType:UIReturnKeyDone];\n",name]];
    }
    
    if (arc4random()%4 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.leftViewMode = UITextFieldViewModeAlways;\n",name]];
    }

    if (arc4random()%4 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.leftView = [[UIView alloc] initWithFrame:CGRectMake(%d, %d, %d, %d)];\n",name,arc4random()%100,arc4random()%100,arc4random()%50,arc4random()%50]];
    }
    
    if (arc4random()%3 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;\n",name]];
    }
    
    if (arc4random()%3 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.clearButtonMode = UITextFieldViewModeWhileEditing;\n",name]];
    }
    
    if (arc4random()%3 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.returnKeyType = UIReturnKeySearch;\n",name]];
    }
    
    if (arc4random()%3 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.enablesReturnKeyAutomatically = YES;\n",name]];
    }
    
    if (arc4random()%3 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.autocorrectionType = UITextAutocorrectionTypeNo;\n",name]];
    }
    
    if (arc4random()%3 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.autocapitalizationType = UITextAutocapitalizationTypeNone;\n",name]];
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
        [initCode appendString:[NSString stringWithFormat:@"        _%@ = [[UIScrollView alloc] init];\n",name]];
        [initCode appendString:[NSString stringWithFormat:@"        _%@.frame = CGRectMake(%d, %d, %d, %d);\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
    } else {
        [initCode appendString:[NSString stringWithFormat:@"        _%@ = [[UIScrollView alloc] initWithFrame:CGRectMake(%d, %d, %d, %d)];\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
    }
    
    if (arc4random()%5 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.bounds = CGRectMake(%d, %d, %d, %d);\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.backgroundColor = [UIColor colorWithRed:%d green:%d blue:%d alpha:1.0];\n",name,arc4random()%2,arc4random()%2,arc4random()%2]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.alpha = %.1f;\n",name,(arc4random()%9+1)*1.0/10]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [_%@.layer setCornerRadius:1.0];\n        _%@.layer.masksToBounds = YES;\n",name,name]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [_%@ setContentSize:CGSizeMake(CGRectGetWidth(_%@.frame)*%d, CGRectGetWidth(_%@.frame)*%d)];\n",name,name,arc4random()%5,name,arc4random()%5]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [_%@ setPagingEnabled:YES];\n",name]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [_%@ setBounces:NO];\n",name]];
    }
    return [initCode copy];
}
- (NSString *)getUIImageViewInitSpamCodeWithName:(NSString *)name {
    NSMutableString *initCode = [[NSMutableString alloc] initWithCapacity:0];
    
    NSMutableString *imgName = [[NSMutableString alloc] initWithCapacity:0];
    [imgName appendString:[FileMixedHelper randomWordWithIndex:1]];
    for (int i = 0; i<(arc4random()%4+2); i++) {
        [imgName appendString:[NSString stringWithFormat:@"_%@",[FileMixedHelper randomWordWithIndex:0]]];
    }
    [imgName appendString:@".png"];
    
    NSMutableString *imgName2 = [[NSMutableString alloc] initWithCapacity:0];
    [imgName2 appendString:[FileMixedHelper randomWordWithIndex:1]];
    for (int i = 0; i<(arc4random()%4+2); i++) {
        [imgName2 appendString:[NSString stringWithFormat:@"_%@",[FileMixedHelper randomWordWithIndex:0]]];
    }
    [imgName2 appendString:@".png"];
    
    NSUInteger initType = arc4random()%4;
    if (initType == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@ = [[UIImageView alloc] init];\n",name]];
        [initCode appendString:[NSString stringWithFormat:@"        _%@.frame = CGRectMake(%d, %d, %d, %d);\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
        [initCode appendString:[NSString stringWithFormat:@"        _%@.image = [UIImage imageNamed:@\"%@\"];\n",name,imgName]];
    } else if (initType == 1) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@ = [[UIImageView alloc] initWithFrame:CGRectMake(%d, %d, %d, %d)];\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
        [initCode appendString:[NSString stringWithFormat:@"        _%@.image = [UIImage imageNamed:@\"%@\"];\n",name,imgName]];
    } else if (initType == 2) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@\"%@\"]];\n",name,imgName]];
    } else {
        [initCode appendString:[NSString stringWithFormat:@"        _%@ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@\"%@\"] highlightedImage:[UIImage imageNamed:@\"%@\"]];\n",name,imgName,imgName2]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.backgroundColor = [UIColor colorWithRed:%d green:%d blue:%d alpha:1.0];\n",name,arc4random()%2,arc4random()%2,arc4random()%2]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.alpha = %.1f;\n",name,(arc4random()%9+1)*1.0/10]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [_%@.layer setCornerRadius:10.0];\n        _%@.layer.masksToBounds = YES;\n",name,name]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.userInteractionEnabled = YES;\n",name]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.multipleTouchEnabled = YES;\n",name]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.animationRepeatCount = %d;\n",name,arc4random()%6]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.center = CGPointMake(%d, %d);\n",name,arc4random()%200,arc4random()%200]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.animationRepeatCount = %d;\n",name,arc4random()%6]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [_%@ setContentMode:UIViewContentModeCenter];\n",name]];
    }
    
    return [initCode copy];
}

- (NSString *)getUILabelInitSpamCodeWithName:(NSString *)name {
    NSMutableString *initCode = [[NSMutableString alloc] initWithCapacity:0];
    
    NSUInteger initType = arc4random()%2;
    if (initType == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@ = [[UILabel alloc] init];\n",name]];
        [initCode appendString:[NSString stringWithFormat:@"        _%@.frame = CGRectMake(%d, %d, %d, %d);\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
    } else {
        [initCode appendString:[NSString stringWithFormat:@"        _%@ = [[UILabel alloc] initWithFrame:CGRectMake(%d, %d, %d, %d)];\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
    }
    
    if (arc4random()%3 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.bounds = CGRectMake(%d, %d, %d, %d);\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
    }
    
    if (arc4random()%3 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.backgroundColor = [UIColor colorWithRed:%d green:%d blue:%d alpha:1.0];\n",name,arc4random()%2,arc4random()%2,arc4random()%2]];
    }
    
    if (arc4random()%4 > 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.text = @\"%@\";\n",name,[FileMixedHelper randomWordWithIndex:0]]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.textColor = [UIColor colorWithRed:%d green:%d blue:%d alpha:1.0];\n",name,arc4random()%2,arc4random()%2,arc4random()%2]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.alpha = %.1f;\n",name,(arc4random()%9+1)*1.0/10]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.textAlignment = NSTextAlignmentCenter;\n",name]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [_%@ sizeToFit];\n",name]];
    }
    
    return [initCode copy];
}

- (NSString *)getViewInitSpamCodeWithName:(NSString *)name {
    NSMutableString *initCode = [[NSMutableString alloc] initWithCapacity:0];
    
    NSUInteger initType = arc4random()%2;
    if (initType == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@ = [[UIView alloc] init];\n",name]];
        [initCode appendString:[NSString stringWithFormat:@"        _%@.frame = CGRectMake(%d, %d, %d, %d);\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
    } else {
        [initCode appendString:[NSString stringWithFormat:@"        _%@ = [[UIView alloc] initWithFrame:CGRectMake(%d, %d, %d, %d)];\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
    }
    
    if (arc4random()%3 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.bounds = CGRectMake(%d, %d, %d, %d);\n",name,arc4random()%100,arc4random()%100,arc4random()%50+100,arc4random()%50+100]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.backgroundColor = [UIColor colorWithRed:%d green:%d blue:%d alpha:1.0];\n",name,arc4random()%2,arc4random()%2,arc4random()%2]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        _%@.alpha = %.1f;\n",name,(arc4random()%9+1)*1.0/10]];
    }
    
    if (arc4random()%2 == 0) {
        [initCode appendString:[NSString stringWithFormat:@"        [_%@.layer setCornerRadius:1.0];\n        _%@.layer.masksToBounds = YES;\n",name,name]];
    }
    return [initCode copy];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"%@",@{@"property":_propertyCode,@"setMethodCode":_setMethodCode,@"callMethodCode":_callMethodCode}];
}
@end
