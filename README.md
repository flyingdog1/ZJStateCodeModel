# ZJStateCodeModel
A lightweight model managing your states when  performing multiple functions.

交互示例：

一个只允许竖直方向滑动的红色视图
一个只允许水平方向滑动的黄色试图

ViewController中设置interactionControl的值跑代码可以看到：


1) ZJInteractionControl_None - 未加控制时，黄色、红色视图一起移动，不能达到目的


2) ZJInteractionControl_Nomal - 加属性控制时，可以达到目的。但是，如果有其他视图需要独立移动，或者跟以上视图之一同时移动，则需要判断黄色、红色视图是否在移动。如果是一个视图多、交互复杂的界面，要加很多属性，并且在交互中穿插对其他视图移动状态的判断，因为每添加一个视图手势就要处理跟之前手势的冲突。

3) ZJInteractionControl_StateModel - 引入ZJStateCodeModel管理每一种交互状态。


步骤：

1. 将ZJStateCodeModel设为属性并初始化，将每种状态码设为属性。


2. 注册每种状态码：（model中会按注册顺序，分配一个经过偏移计算的数值给状态码属性）
- (NSUInteger) registerCustomState{
    _tag++;
    return 1<<_tag;
}


3. 在每种状态开始的时候addState，结束的时候removeState.


4. 如果某种状态开始的时候，不希望有其他状态正在发生。那么可以判断ZJStateCodeModel属性中是否haveState，若为NO，则可以addState。


5. 如果某种状态开始的时候，不希望有除了某状态以外的其他状态正在发生（例如，添加黑色视图，只可以跟红色视图一起移动）那么它开始的时候，判断if(onlyContainState：红色 || !haveState)


6. 如果某状态开始的时候，希望某状态正在进行，但不排斥其他状态（例如，添加蓝色视图，必须红色视图动起来，才能移动）那么，开始的时候，判断if(containState：红色 )


7. 不仅仅是交互状态，其他状态也可以利用此model。因为都是简单数据类型的赋值、偏移计算，所以比数组存储耗费性能少很多，性能消耗基本可以忽略。多线程情况下不加锁基本也是安全的。


