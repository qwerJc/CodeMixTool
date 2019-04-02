//
//  UserDetailDataModel.h
//  CodeMixTool
//
//  Created by 贾辰 on 2019/3/27.
//  Copyright © 2019年 JJC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserDetailDataModel : NSObject
@property (strong, nonatomic)NSString *userid;
@property (strong, nonatomic)NSString *username;
@property (strong, nonatomic)NSImage *useravatar;
@end

NS_ASSUME_NONNULL_END
