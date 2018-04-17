//
//  SNInteractionStateModel.m
//  SinaNews
//
//  Created by zhenjin on 2018/4/17.
//  Copyright © 2018年 sina. All rights reserved.
//

#import "ZJStateCodeModel.h"

@interface ZJStateCodeModel()
/**
 当前状态池所有状态码
 */
@property (nonatomic, assign) NSUInteger currentState;
@property (nonatomic, assign) NSUInteger tag;

@end

@implementation ZJStateCodeModel

- (instancetype)init{
    self = [super init];
    if (self) {
        _tag = 0;
        _currentState = _tag;
    }
    return self;
}

/**
 注册自定义状态码
 
 @return 状态码
 */
- (NSUInteger)registerCustomState{
    _tag++;
    return 1<<_tag;
}

/**
 添加状态码到状态池
 
 @param state 状态码
 */
- (void)addState:(NSUInteger)state{
    self.currentState |= state;
}

/**
 从状态池移除状态码
 
 @param state 状态码
 */
- (void)removeState:(NSUInteger)state{
    self.currentState &= ~state;
}

/**
 状态池中包含此状态码
 
 @param state 状态码
 @return 是否包含包含
 */
- (BOOL)containState:(NSUInteger)state{
    return self.currentState & state;
}


/**
 状态池中有且只有此状态码

 @param state 状态码
 @return 是否有且只有此状态码
 */
- (BOOL)onlyContainState:(NSUInteger)state{
    return self.currentState == state;
}

/**
 状态池中有状态码
 
 @return 是否有状态码
 */
- (BOOL)haveState{
    return self.currentState;
}


/**
 重写系统description方法

 @return 状态池中的状态
 */
- (NSString *)description{
    NSString *string = @"按照注册状态码的顺序从1开始编号，当前状态池中有:\n";
    for (int i = 1; i <= _tag; i++) {
        if (self.currentState & (1<<i)) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%d、 \n", i]];
        }
    }
    return string;
}

@end
