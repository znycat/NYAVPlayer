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
    [self.view addSubview:playerView];
    self.playerView = playerView;
    playerView.frame = self.view.bounds;
    playerView.detailVC = self;
    playerView.urlStr = @"";

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}



@end
