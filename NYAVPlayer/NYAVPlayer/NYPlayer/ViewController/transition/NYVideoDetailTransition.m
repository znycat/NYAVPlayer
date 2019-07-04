//
//  NYVideoDetailTransition.m
//  NYAVPlayer
//
//  Created by 翟乃玉 on 2019/7/3.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import "NYVideoDetailTransition.h"
#import "NYPlayerControllerView.h"
@interface NYVideoDetailTransition()
@property(nonatomic, assign) BOOL isPresent;

@property(nonatomic, assign) CGPoint initialCenter;
@property(nonatomic, assign) CGRect initialBounds;
@property(nonatomic, weak)UIView *initialPlayerViewParentView;
@end
@implementation NYVideoDetailTransition
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
    return 0.5;
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
        self.initialPlayerViewParentView = NYSharePlayer.superview;
        self.initialCenter = [self.initialPlayerViewParentView convertPoint:NYSharePlayer.center toView:nil];
        self.initialBounds = [self.initialPlayerViewParentView convertRect:NYSharePlayer.bounds fromView:nil];
        
        
        [transitionContext.containerView addSubview:toView];
        
        // 将toView的 位置变为初始位置，准备动画
        [toView addSubview:NYSharePlayer];
        toView.bounds = NYSharePlayer.bounds;
        toView.center = self.initialCenter;
        NYSharePlayer.frame = toView.bounds;

        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            toView.bounds = transitionContext.containerView.bounds;
            toView.center = transitionContext.containerView.center;
            NYSharePlayer.frame = toView.bounds;
        } completion:^(BOOL finished) {
            toView.bounds = transitionContext.containerView.bounds;
            toView.center = transitionContext.containerView.center;
            NYSharePlayer.frame = toView.bounds;
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
        
    }else{
        // 将 toView 插入fromView的下面，否则动画过程中不会显示toView
        [transitionContext.containerView insertSubview:toView belowSubview:fromView];
        [fromView addSubview:NYSharePlayer];

        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            fromView.center = self.initialCenter;
            fromView.bounds = self.initialBounds;
            NYSharePlayer.frame = fromView.bounds;
        } completion:^(BOOL finished) {
            // 动画完成后再次设置终点状态，防止动画被打断造成BUG
            fromView.center = self.initialCenter;
            fromView.bounds = self.initialBounds;
            NYSharePlayer.frame = fromView.bounds;
            
            // 动画完成后，将playView添加到竖屏界面上
            [self.initialPlayerViewParentView addSubview:NYSharePlayer];
            NYSharePlayer.frame = NYSharePlayer.superview.bounds;
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    }
}
@end
