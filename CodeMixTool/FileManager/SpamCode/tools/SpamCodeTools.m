//
//  SpamCodeTools.m
//  CodeMixTool
//
//  Created by 贾辰 on 2019/6/27.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import "SpamCodeTools.h"
#import "FileMixedHelper.h"

@implementation SpamCodeTools
// set方法,proper声明 初始化时需要
+ (NSString *)getObjectiveTypeWithIndex:(NSUInteger)index {
    switch (index) {
        case EnumObjectType_NSInteger:
            return @"NSInteger ";
        case EnumObjectType_BOOL:
            return @"BOOL ";
            
        case EnumObjectType_NSObject:
            return @"NSObject *";
        case EnumObjectType_NSSet:
            return @"NSSet *";
        case EnumObjectType_NSArray:
            return @"NSArray *";
        case EnumObjectType_NSString:
            return @"NSString *";
        case EnumObjectType_NSDictionary:
            return @"NSDictionary *";
            
        case EnumObjectType_UIView:
            return @"UIView *";
        case EnumObjectType_UILabel:
            return @"UILabel *";
        case EnumObjectType_UIImageView:
            return @"UIImageView *";
        case EnumObjectType_ScrollView:
            return @"UIScrollView *";
        case EnumObjectType_UITextField:
            return @"UITextField *";
        case EnumObjectType_UITextView:
            return @"UITextView *";
        default:
            return @"";
    }
}

+ (NSString *)getPropertyNameWithIndex:(NSUInteger)index {
    NSString *propertyName = [FileMixedHelper randomWordPropertyName];
    switch (index) {
        case EnumObjectType_NSInteger:
            return [NSString stringWithFormat:@"integer%@",propertyName];
        case EnumObjectType_BOOL:
            return [NSString stringWithFormat:@"is%@",propertyName];
            
        case EnumObjectType_NSObject:
            return [NSString stringWithFormat:@"obj%@",propertyName];
        case EnumObjectType_NSSet:
            return [NSString stringWithFormat:@"nset%@",propertyName];
        case EnumObjectType_NSArray:
            return [NSString stringWithFormat:@"arr%@",propertyName];
        case EnumObjectType_NSString:
            return [NSString stringWithFormat:@"str%@",propertyName];
        case EnumObjectType_NSDictionary:
            return [NSString stringWithFormat:@"dic%@",propertyName];
            
        case EnumObjectType_UIView:
            return [NSString stringWithFormat:@"view%@",propertyName];
        case EnumObjectType_UILabel:
            return [NSString stringWithFormat:@"lbl%@",propertyName];
        case EnumObjectType_UIImageView:
            return [NSString stringWithFormat:@"imgv%@",propertyName];
        case EnumObjectType_ScrollView:
            return [NSString stringWithFormat:@"scrollView%@",propertyName];
        case EnumObjectType_UITextField:
            return [NSString stringWithFormat:@"txf%@",propertyName];
        case EnumObjectType_UITextView:
            return [NSString stringWithFormat:@"txv%@",propertyName];
    }
    return @"";
}

+ (NSString *)getPropertyCodeWithIndex:(NSUInteger)index {
    switch (index) {
        case EnumObjectType_NSInteger:
        case EnumObjectType_BOOL:
            return @"(assign, nonatomic)";
            
        case EnumObjectType_NSObject:
        case EnumObjectType_NSSet:
        case EnumObjectType_NSArray:
        case EnumObjectType_NSString:
        case EnumObjectType_NSDictionary:
        case EnumObjectType_UIView:
        case EnumObjectType_UILabel:
        case EnumObjectType_UIImageView:
        case EnumObjectType_ScrollView:
        case EnumObjectType_UITextField:
        case EnumObjectType_UITextView:
            return @"(strong, nonatomic)";
        default:
            return @"";
    }
}

+ (NSString *)getInitCodeWithClassIndex:(NSUInteger)index {
    switch (index) {
        case EnumObjectType_NSInteger:
            return [NSString stringWithFormat:@"%@%@%@%@",[FileMixedHelper randomNum],[FileMixedHelper randomNum],[FileMixedHelper randomNum],[FileMixedHelper randomNum]];
        case EnumObjectType_BOOL:
            return @"YES";
            
        case EnumObjectType_NSObject:
            return @"[[NSObject alloc] init]";
        case EnumObjectType_NSSet:
            return @"[[NSSet alloc] init]";
        case EnumObjectType_NSArray:
            return @"[NSArray array]";
        case EnumObjectType_NSString:
            return [NSString stringWithFormat:@"@\"%@\"",[FileMixedHelper randomString:10]];
        case EnumObjectType_NSDictionary:
            return @"[[NSDictionary alloc] init]";
            
        case EnumObjectType_UIView:
            return @"[[UIView alloc] init]";
        case EnumObjectType_UILabel:
            return @"[[UILabel alloc] init]";
        case EnumObjectType_UIImageView:
            return @"[[UIImageView alloc] init]";
        case EnumObjectType_ScrollView:
            return @"[[UIScrollView alloc] init]";
        case EnumObjectType_UITextField:
            return @"[[UITextField alloc] init]";
        case EnumObjectType_UITextView:
            return @"[[UITextView alloc] init]";
        default:
            return @"";
    }
    return @"";
}

+ (NSString *)getReturnTypeWithIndex:(NSInteger)index {
    switch (index) {
        case EnumCategoryReturnType_Void:
            return @"void";
        case EnumCategoryReturnType_BOOL:
            return @"BOOL";
        case EnumCategoryReturnType_NSInteger:
            return @"NSInteger";
            
        case EnumCategoryReturnType_NSObject:
            return @"NSObject *";
        case EnumCategoryReturnType_NSSet:
            return @"NSSet *";
            
        case EnumCategoryReturnType_NSArray:
            return @"NSArray *";
        case EnumCategoryReturnType_NSString:
            return @"NSString *";
        case EnumCategoryReturnType_NSDictionary:
            return @"NSDictionary *";
        default:
            return @"";
    }
}

#pragma mark - 重写 Get方法
+ (NSString *)addCallMethodWithTypeIndex:(NSInteger)index andPropertyName:(NSString *)propertyName {
    
    NSString *strCallCode = @"";
    switch (index) {
        case EnumObjectType_NSInteger:
            strCallCode = [NSString stringWithFormat:@"    self.%@ = %@;\n",
                           propertyName,
                           [NSString stringWithFormat:@"%@%@%@%@",[FileMixedHelper randomNum],[FileMixedHelper randomNum],[FileMixedHelper randomNum],[FileMixedHelper randomNum]]];
            break;
        case EnumObjectType_BOOL:
            strCallCode = [NSString stringWithFormat:@"    self.%@ = @\"YES\";\n",
                           propertyName];
            break;
            
        case EnumObjectType_NSObject:
            strCallCode = [NSString stringWithFormat:@"    self.%@ = [[NSObject alloc] init];\n",
                           propertyName];
            
            break;
        case EnumObjectType_NSSet:
            strCallCode = [NSString stringWithFormat:@"    self.%@ = [[NSSet alloc] init];\n",
                           propertyName];
            break;
        case EnumObjectType_NSArray:
            strCallCode = [NSString stringWithFormat:@"    self.%@ = [NSArray array];\n",
                           propertyName];
            break;
        case EnumObjectType_NSString:
            strCallCode = [NSString stringWithFormat:@"    self.%@ = @\"%@\";\n",
                           propertyName,[FileMixedHelper randomString:10]];
            break;
        case EnumObjectType_NSDictionary:
            strCallCode = [NSString stringWithFormat:@"    self.%@ = [[NSDictionary alloc] init];\n",
                           propertyName];
            break;
            
        case EnumObjectType_UIView:
        case EnumObjectType_UILabel:
        case EnumObjectType_UIImageView:
        case EnumObjectType_ScrollView:
        case EnumObjectType_UITextField:
        case EnumObjectType_UITextView:
            strCallCode = [NSString stringWithFormat:@"    [viewSum addSubview:self.%@];\n",
                           propertyName];
            break;
    }
    return strCallCode;
}

+ (NSString *)addOverWriteGetMethodWithTypeIndex:(NSInteger)index andPropertyName:(NSString *)propertyName andCategoryName:(NSString *)categoryName {
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
            strOverWriteMethod = [NSString stringWithFormat:@"- (%@)%@ { \n    if (!_%@) {\n        _%@ = %@; \n    }\n    return _%@;\n}\n",
                                  [SpamCodeTools getObjectiveTypeWithIndex:index],
                                  newGetMethodName,
                                  propertyName,
                                  propertyName,
                                  [SpamCodeTools getInitCodeWithClassIndex:index],
                                  propertyName];
            break;
            
        case EnumObjectType_UIView:
            strOverWriteMethod = [NSString stringWithFormat:@"- (%@)%@ { \n    if (!_%@) {\n%@\n    }\n    return _%@;\n}\n",
                                  [SpamCodeTools getObjectiveTypeWithIndex:index],
                                  newGetMethodName,
                                  propertyName,
                                  [self getViewInitSpamCodeWithName:propertyName],
                                  propertyName];
            break;
        case EnumObjectType_UILabel:
            strOverWriteMethod = [NSString stringWithFormat:@"- (%@)%@ { \n    if (!_%@) {\n%@\n    }\n    return _%@;\n}\n",
                                  [SpamCodeTools getObjectiveTypeWithIndex:index],
                                  newGetMethodName,
                                  propertyName,
                                  [self getUILabelInitSpamCodeWithName:propertyName],
                                  propertyName];
            break;
        case EnumObjectType_UIImageView:
            strOverWriteMethod = [NSString stringWithFormat:@"- (%@)%@ { \n    if (!_%@) {\n%@\n    }\n    return _%@;\n}\n",
                                  [SpamCodeTools getObjectiveTypeWithIndex:index],
                                  newGetMethodName,
                                  propertyName,
                                  [self getUIImageViewInitSpamCodeWithName:propertyName],
                                  propertyName];
            break;
        case EnumObjectType_ScrollView:
            strOverWriteMethod = [NSString stringWithFormat:@"- (%@)%@ { \n    if (!_%@) {\n%@\n    }\n    return _%@;\n}\n",
                                  [SpamCodeTools getObjectiveTypeWithIndex:index],
                                  newGetMethodName,
                                  propertyName,
                                  [self getScrollViewInitSpamCodeWithName:propertyName],
                                  propertyName];
            break;
        case EnumObjectType_UITextField:
            strOverWriteMethod = [NSString stringWithFormat:@"- (%@)%@ { \n    if (!_%@) {\n%@\n    }\n    return _%@;\n}\n",
                                  [SpamCodeTools getObjectiveTypeWithIndex:index],
                                  newGetMethodName,
                                  propertyName,
                                  [self getUITextFieldInitSpamCodeWithName:propertyName],
                                  propertyName];
            break;
        case EnumObjectType_UITextView:
            strOverWriteMethod = [NSString stringWithFormat:@"- (%@)%@ { \n    if (!_%@) {\n%@\n    }\n    return _%@;\n}\n",
                                  [SpamCodeTools getObjectiveTypeWithIndex:index],
                                  newGetMethodName,
                                  propertyName,
                                  [self getUITextViewInitSpamCodeWithName:propertyName],
                                  propertyName];
            break;
    }
    return strOverWriteMethod;
}

+ (NSString *)getUITextViewInitSpamCodeWithName:(NSString *)name {
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
+ (NSString *)getUITextFieldInitSpamCodeWithName:(NSString *)name {
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
+ (NSString *)getScrollViewInitSpamCodeWithName:(NSString *)name {
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
+ (NSString *)getUIImageViewInitSpamCodeWithName:(NSString *)name {
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

+ (NSString *)getUILabelInitSpamCodeWithName:(NSString *)name {
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

+ (NSString *)getViewInitSpamCodeWithName:(NSString *)name {
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


#pragma mark - Other

+ (NSString *)getPropertyCodeWithName:(NSString *)propertyName andPropertyType:(NSUInteger)index {
    return [NSString stringWithFormat:@"@property %@ %@%@;\n",[SpamCodeTools getPropertyCodeWithIndex:index],[SpamCodeTools getObjectiveTypeWithIndex:index],propertyName];
}

+ (NSString *)getSpamMethodCodeWithMethodName:(NSString *)methodName andReturnType:(NSUInteger)index andParamName:(NSString *)paramName{
//    NSString *methodType = arc4random()%2 ? @"-" : @"+";
    NSString *returnType = [SpamCodeTools getReturnTypeWithIndex:index];
    
    if (paramName) {
        NSString *paramCode = [NSString stringWithFormat:@"(%@)%@",returnType,paramName];
        return [NSString stringWithFormat:@"+ (%@)%@:%@",returnType,methodName,paramCode];
    } else {
        return [NSString stringWithFormat:@"- (%@)%@",returnType,methodName];
    }
}

+ (NSString *)getRealizationCodeWithReturnType:(NSUInteger)returnType andParamName:(NSString *)paramName {
    if (returnType == 0) {
        // 返回值为void
        return [NSString stringWithFormat:@"[self jjc_category_callAllAddProperty];\n"];
    } else {
        return [self son_getRealizationCodeWithReturnType:returnType ParamName:paramName];
    }
}

+ (NSString *)son_getRealizationCodeWithReturnType:(NSInteger)returnType ParamName:(NSString *)paramName {
    NSString *temVarName1 = [FileMixedHelper randomString:15];
    NSString *temVarName2;
    
    if (paramName) {
        // 如果当前 实现方法有参数
        temVarName2 = paramName;
    } else {
        temVarName2 = [FileMixedHelper randomString:22];
    }
    
    NSString *code;
    switch (returnType) {
        case EnumCategoryReturnType_BOOL:
            if (paramName) {
                code = [NSString stringWithFormat:@"    BOOL %@ = NO;\n    if (%@ && %@) {\n        return !%@;\n    } else {\n        return %@ || %@;\n    }\n       ",temVarName1,temVarName1,temVarName2,temVarName2,temVarName1,temVarName2];
            } else {
                code = [NSString stringWithFormat:@"    return YES;"];
            }
            
            return code;
        case EnumCategoryReturnType_NSInteger:
            if (paramName) {
                code = [NSString stringWithFormat:@"    NSInteger %@ = %@;\n    return %@+ %@;",temVarName1,[FileMixedHelper randomNum],temVarName1,temVarName2];
            } else {
                code = [NSString stringWithFormat:@"    return %@%@;",[FileMixedHelper randomNum],[FileMixedHelper randomNum]];
            }
            return code;
            
        case EnumCategoryReturnType_NSObject:
            if (paramName) {
                code = [NSString stringWithFormat:@"    %@ = [[NSObject alloc] init];\n    return %@;",paramName,paramName];
            } else {
                code = [NSString stringWithFormat:@"    NSObject *%@ = [[NSObject alloc] init];\n    return %@;",temVarName1,temVarName1];
            }
            
            return code;
        case EnumCategoryReturnType_NSSet:
            if (paramName) {
                code = [NSString stringWithFormat:@"    return %@;\n",paramName];
            } else {
                code = [NSString stringWithFormat:@"    NSSet *%@ = [NSSet setWithObject:@\"\"];\n    return %@;",temVarName1,temVarName1];
            }
            return code;
            
        case EnumCategoryReturnType_NSArray:
            code = [NSString stringWithFormat:@"    return [NSArray arrayWithObjects:@\"\", nil];"];
            return code;
        case EnumCategoryReturnType_NSString:
            code = [NSString stringWithFormat:@"    return @\"wqrds\";"];
            return code;
        case EnumCategoryReturnType_NSDictionary:
            code = [NSString stringWithFormat:@"    return [NSDictionary dictionary];"];
            return code;
        default:
            return @"";
    }
}

+ (NSString *)getRandomPropertyNameWithLength:(NSUInteger)length {
    return [[FileMixedHelper randomCapital] stringByAppendingString:[FileMixedHelper randomString:length-1]];
}

+ (NSString *)getRandomMethodNameWithLength:(NSUInteger)length {
    return [FileMixedHelper randomString:length];
}
@end
