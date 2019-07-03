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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    
    NYPlayerControllerView *playerView = [[NYPlayerControllerView alloc] init];
    playerView.playerViewStyle = NYPlayererViewStyleDetail;
    [self.view addSubview:playerView];
    self.playerView = playerView;
    playerView.frame = self.view.bounds;
    playerView.detailVC = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        playerView.urlStr = @"";
    });
//    playerView.urlStr = @"";

}

@end
