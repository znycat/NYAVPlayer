//
//  NYVideoDetailVC.m
//  NYPlayerIJKPlayer
//
//  Created by 翟乃玉 on 2019/6/27.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import "NYVideoDetailVC.h"
#import "NYPlayerControllerView.h"
@interface NYVideoDetailVC ()
@property(nonatomic, weak)NYPlayerControllerView *playerView;
@end

@implementation NYVideoDetailVC
- (instancetype)initWithPlayerView:(NYPlayerControllerView *)playerView{
    self = [super init];
    if (self) {
        playerView.detailVC = self;
        self.playerView = playerView;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        self.transition = [[NYVideoDetailTransition alloc] initWithPlayerView:playerView];
        self.transitioningDelegate = self.transition;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.playerView.playerViewStyle = NYPlayererViewStyleDetail;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
@end
