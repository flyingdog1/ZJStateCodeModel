//
//  ViewController.m
//  ZJStateCodeModel
//
//  Created by zhenjin on 2018/4/17.
//  Copyright © 2018年 zhenjin. All rights reserved.
//

#import "ViewController.h"
#import "ZJStateCodeModel.h"

typedef NS_ENUM(NSUInteger, ZJInteractionControl) {
    ZJInteractionControl_None = 0,       //无控制
    ZJInteractionControl_Nomal = 1,      //加属性控制
    ZJInteractionControl_StateModel = 2  //用model控制
};

@interface ViewController ()
@property (nonatomic, assign)ZJInteractionControl interactionControl;

//实现方式1
@property (nonatomic, strong) ZJStateCodeModel *stateModel;

//实现方式2
@property (nonatomic, assign) BOOL redPan;
@property (nonatomic, assign) BOOL yellowPan;

@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIView *yellowView;

@property (nonatomic, assign) NSUInteger redMoving;
@property (nonatomic, assign) NSUInteger yellowMoving;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactionControl = ZJInteractionControl_None;
    
    // 初始化状态码模型
    self.stateModel = [[ZJStateCodeModel alloc] init];
    // 注册状态码
    [self registerStateCodes];
    
    // 添加视图和手势
    [self addViewsAndGesture];
}

// 添加视图和手势
- (void)addViewsAndGesture{
    self.redView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    self.redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.redView];
    
    self.yellowView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    self.yellowView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.yellowView];
    
    UIPanGestureRecognizer *pan = nil;
    if (self.interactionControl == ZJInteractionControl_Nomal) {
        pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panActionWithProperty:)];
    }else if (self.interactionControl == ZJInteractionControl_StateModel) {
        pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panActionWithStateModel:)];
    }else{
        pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panActionWithNoControl:)];
    }
    
    [self.view addGestureRecognizer:pan];
}

// 注册状态码
- (void)registerStateCodes{
    self.redMoving    = [self.stateModel registerCustomState];
    self.yellowMoving = [self.stateModel registerCustomState];
}

//手势控制view移动
- (void)panActionWithStateModel:(UIPanGestureRecognizer *)recognizer{
    CGPoint translation = [recognizer translationInView:self.view];
    CGPoint velocity = [recognizer velocityInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //手势开始
        if ((fabs(translation.x)/MAX(fabs(translation.y), 0.0001) <= 0.5) && (fabs(velocity.y) > fabs(velocity.x))){
            //竖直方向滑动
            [self.stateModel addState:self.redMoving];
        }else if ((fabs(translation.y)/MAX(fabs(translation.x), 0.0001) <= 0.5) && (fabs(velocity.x) > fabs(velocity.y))){
            //水平方向滑动
            [self.stateModel addState:self.yellowMoving];
        }
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        //手势改变
        if ([self.stateModel containState:self.redMoving]) {
            CGRect rect = self.redView.frame;
            rect.origin.y+=translation.y;
            self.redView.frame = rect;
        }else if ([self.stateModel containState:self.yellowMoving]){
            CGRect rect = self.yellowView.frame;
            rect.origin.x+=translation.x;
            self.yellowView.frame = rect;
        }
    }else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled){
        //手势结束
        if ([self.stateModel containState:self.redMoving]) {
            [self.stateModel removeState:self.redMoving];
        }
        if ([self.stateModel containState:self.yellowMoving]) {
            [self.stateModel removeState:self.yellowMoving];
        }
    }
    [recognizer setTranslation:CGPointZero inView:self.view];
}

//手势控制view移动
- (void)panActionWithProperty:(UIPanGestureRecognizer *)recognizer{
    CGPoint translation = [recognizer translationInView:self.view];
    CGPoint velocity = [recognizer velocityInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //手势开始
        if ((fabs(translation.x)/MAX(fabs(translation.y), 0.0001) <= 0.5) && (fabs(velocity.y) > fabs(velocity.x))){
            //竖直方向滑动
            self.redPan = YES;
        }else if ((fabs(translation.y)/MAX(fabs(translation.x), 0.0001) <= 0.5) && (fabs(velocity.x) > fabs(velocity.y))){
            //水平方向滑动
            self.yellowPan = YES;
        }
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        //手势改变
        if (self.redPan) {
            CGRect rect = self.redView.frame;
            rect.origin.y+=translation.y;
            self.redView.frame = rect;
        }else if (self.yellowPan){
            CGRect yellowRect = self.yellowView.frame;
            yellowRect.origin.x+=translation.x;
            self.yellowView.frame = yellowRect;
        }
    }else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled){
        self.redPan = NO;
        self.yellowPan = NO;
    }
    [recognizer setTranslation:CGPointZero inView:self.view];
}

//手势控制view移动
- (void)panActionWithNoControl:(UIPanGestureRecognizer *)recognizer{
    CGPoint translation = [recognizer translationInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {

    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        //手势改变
        CGRect rect = self.redView.frame;
        rect.origin.y+=translation.y;
        self.redView.frame = rect;
        
        CGRect yellowRect = self.yellowView.frame;
        yellowRect.origin.x+=translation.x;
        self.yellowView.frame = yellowRect;
        
    }else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled){
        
    }
    [recognizer setTranslation:CGPointZero inView:self.view];
}



@end
