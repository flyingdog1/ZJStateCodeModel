//
//  SNInteractionStateModel.h
//  SinaNews
//
//  Created by zhenjin on 2018/4/17.
//  Copyright © 2018年 sina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJStateCodeModel : NSObject

/**
  注册自定义状态码,最好写在一个地方

 @return 状态码
 */
- (NSUInteger)registerCustomState;

/**
 添加状态码到状态池

 @param state 状态码
 */
- (void)addState:(NSUInteger)state;

/**
 从状态池移除状态码

 @param state 状态码
 */
- (void)removeState:(NSUInteger)state;


/**
 状态池中包含此状态码
 
 @param state 状态码
 @return 是否包含包含
 */
- (BOOL)containState:(NSUInteger)state;

/**
 状态池中有且只有此状态码
 
 @param state 状态码
 @return 是否有且只有此状态码
 */
- (BOOL)onlyContainState:(NSUInteger)state;

/**
 状态池中有状态码

 @return 是否有状态码
 */
- (BOOL)haveState;

@end
