//
//  NYFullTransition.m
//  NYAVPlayer
//
//  Created by 翟乃玉 on 2019/7/3.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import "NYFullTransition.h"
#import "NYPlayerControllerView.h"
@interface NYFullTransition()
@property(nonatomic, assign) BOOL isPresent;
@property(nonatomic, assign)BOOL isLeft;

@property(nonatomic, assign) CGPoint initialCenter;
@property(nonatomic, assign) CGRect initialBounds;
@property(nonatomic, weak)UIView *initialPlayerViewParentView;

@property(nonatomic, weak)NYPlayerControllerView *playerView;
@end
@implementation NYFullTransition
- (instancetype)initWithPlayerView:(NYPlayerControllerView *)playerView isLeft:(BOOL)isLeft;
{
    self = [super init];
    if (self) {
        self.playerView = playerView;
        self.isLeft = isLeft;
    }
    return self;
}

#pragma mark - UIViewControllerTransitioningDelegate
//自定义弹出的动画
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    // 返回一个遵守 UIViewControllerAnimatedTransitioning 协议的对象
    self.isPresent = YES;
    return self;
}
//自定义消失的动画
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    self.isPresent = NO;
    return self;
}
#pragma mark - UIViewControllerAnimatedTransitioning
// 动画转场时间
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 2;
}

// 获取转场的上下文, 可以通过上下文获取d弹出的view和消失的view
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView* toView = nil;
    UIView* fromView = nil;
    
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        fromView = fromViewController.view;
        toView = toViewController.view;
    }
    if (self.isPresent) {
        // 计算toView的初始中心位置
        
        self.initialCenter = [transitionContext.containerView convertPoint:self.playerView.center toView:nil];
        self.initialBounds = [transitionContext.containerView convertRect:self.playerView.bounds fromView:nil];
        self.initialPlayerViewParentView = self.playerView.superview;
        
        //屏幕变化 需要反转一下x y的值
        CGPoint initialCenter = CGPointMake(self.initialCenter.y, self.initialCenter.x);
        [transitionContext.containerView addSubview:toView];
        
        // 将toView的 位置变为初始位置，准备动画
        [toView addSubview:self.playerView];
        toView.bounds = self.playerView.bounds;
        toView.center = initialCenter;
        self.playerView.frame = toView.bounds;
        
        // 根据屏幕方向的不同选择不同的角度
        if (self.isLeft) {
            toView.transform = CGAffineTransformMakeRotation(M_PI_2);
        }else{
            toView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        }

        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            // 将 toView 从设置的初始位置回复到正常位置
            toView.transform = CGAffineTransformIdentity;
            toView.bounds = transitionContext.containerView.bounds;
            toView.center = transitionContext.containerView.center;
            self.playerView.frame = toView.bounds;
        } completion:^(BOOL finished) {
            // 动画完成后再次设置终点状态，防止动画被打断造成BUG
            toView.transform = CGAffineTransformIdentity;
            toView.bounds = transitionContext.containerView.bounds;
            toView.center = transitionContext.containerView.center;
            self.playerView.frame = toView.bounds;
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
        
    }else{
        // 将 toView 插入fromView的下面，否则动画过程中不会显示toView
        [transitionContext.containerView insertSubview:toView belowSubview:fromView];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            // 将 toView 从设置的初始位置回复到正常位置
            // 让 fromView 返回playView的初始值
            fromView.transform = CGAffineTransformIdentity;
            fromView.center = self.initialCenter;
            fromView.bounds = self.initialBounds;
            self.playerView.frame = fromView.bounds;
            
        } completion:^(BOOL finished) {
            // 动画完成后再次设置终点状态，防止动画被打断造成BUG
            fromView.transform = CGAffineTransformIdentity;
            fromView.center = self.initialCenter;
            fromView.bounds = self.initialBounds;
            self.playerView.frame = fromView.bounds;
            
            // 动画完成后，将playView添加到竖屏界面上
            [self.initialPlayerViewParentView addSubview:self.playerView];
            self.playerView.frame = self.initialBounds;
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    }
}
@end
