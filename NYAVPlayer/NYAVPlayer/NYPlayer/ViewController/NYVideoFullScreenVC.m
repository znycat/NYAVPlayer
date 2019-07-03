//
//  NYVideoFullScreenVC.m
//  NYPlayerIJKPlayer
//
//  Created by 翟乃玉 on 2019/6/27.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import "NYVideoFullScreenVC.h"

@interface NYVideoFullScreenVC ()
@property(nonatomic, assign)BOOL isLeft;
@property(nonatomic, weak)NYPlayerControllerView *playerView;
@end

@implementation NYVideoFullScreenVC

- (instancetype)initWithPlayerView:(NYPlayerControllerView *)playerView isLeft:(BOOL)isLeft{
    self = [super init];
    if (self) {
        self.isLeft = isLeft;
        self.playerView = playerView;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        self.transition = [[NYFullTransition alloc] initWithPlayerView:playerView isLeft:isLeft];
        self.transitioningDelegate = self.transition;
    }
    return self;
}

//是否支持屏幕旋转
-(BOOL)shouldAutorotate{
    return NO;
}
//支持旋转的方向有哪些
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
//控制 vc present进来的横竖屏和进入方向 ，支持的旋转方向必须包含改返回值的方向 （详细的说明见下文）
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return  self.isLeft ? UIInterfaceOrientationLandscapeLeft : UIInterfaceOrientationLandscapeRight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
}

@end
