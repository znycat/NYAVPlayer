//
//  NYPlayerControllerView.m
//  NYAVPlayer
//
//  Created by 翟乃玉 on 2019/7/1.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import "NYPlayerControllerView.h"
#import "NYAVPlayerManager.h"
#import "NYSpeedLoadingView.h"

@interface NYPlayerControllerView()

/// 顶部View
@property(nonatomic, weak)NYPlayerTopView *topView;
/// 底部View
@property(nonatomic, weak)NYPlayerBottomControllerView *bottomControllerView;
/// 加载loading
@property (nonatomic, weak) NYSpeedLoadingView *loadingView;
/// 封面图
@property (nonatomic, strong) UIImageView *coverImageView;
/// 中间播放或暂停按钮
@property (nonatomic, strong) UIButton *playOrPauseBtn;

@property (nonatomic, strong) id <NYPlayerMediaPlayback> currentManager;
@end
@implementation NYPlayerControllerView
#pragma mark - cycle
-(void)dealloc{
    NYLog(@"delloc");
    [self.currentManager stop];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.playerViewStyle = NYPlayererViewStyleNone;
        [self setupUI];
        [self setupClick];
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    CGFloat maxW = frame.size.width;
    CGFloat maxH = frame.size.height;
    
    self.currentManager.view.frame = CGRectMake(0, 0, maxW, maxH);
    //顶部
    self.topView.frame = CGRectMake(0, 30, maxW, 40);
    //底部
    self.bottomControllerView.frame = CGRectMake(0, maxH - 40 - 20, maxW, 40);
    //loading
    CGFloat loadingW = 80;
    CGFloat loadingH = loadingW;
    CGFloat loadingX = (maxW - loadingW) * 0.5;
    CGFloat loadingY = (maxH - loadingH) * 0.5 + 10;
    self.loadingView.frame = CGRectMake(loadingX, loadingY, loadingW, loadingH);
    //playOrPauseBtn
    CGFloat playOrPauseBtnW = 44;
    CGFloat playOrPauseBtnH = playOrPauseBtnW;
    CGFloat playOrPauseBtnX = (maxW - playOrPauseBtnW) * 0.5;
    CGFloat playOrPauseBtnY = (maxH - playOrPauseBtnH) * 0.5;
    self.playOrPauseBtn.frame = CGRectMake(playOrPauseBtnX, playOrPauseBtnY, playOrPauseBtnW, playOrPauseBtnH);
    [super setFrame:frame];
}

/// 设置回调
-(void)setupClick{
    @weakify(self)
    /** 顶部回调*/
    [self.topView setBackBtnClickBlock:^(NYPlayerTopView * _Nonnull topView) {
        @strongify(self)
        if (self.fullScreenVC) {
            [self quitFullScreen];
        }else{
            [self.detailVC dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    [self.topView setSmallBtnClickBlock:^(NYPlayerTopView * _Nonnull topView) {
        @strongify(self)
        if(self.topSmallBtnClickBlock)self.topSmallBtnClickBlock(self, topView);
    }];
    [self.topView setDownloadBtnClickBlock:^(NYPlayerTopView * _Nonnull topView) {
        @strongify(self)
        if(self.topDownloadBtnClickBlock)self.topDownloadBtnClickBlock(self, topView);
    }];
    /// 底部回掉
    [self.bottomControllerView setPlayBtnClickBlock:^(NYPlayerBottomControllerView * _Nonnull bottomView, UIButton * _Nonnull playOrPauseBtn) {
        @strongify(self)
        [self playOrPause];
    }];
    
    [self.bottomControllerView setFullScreenBtnBlock:^(NYPlayerBottomControllerView * _Nonnull bottomView) {
        @strongify(self)
        [self toFullScreenWithisLeft:NO];
    }];
}

/// UI
-(void)setupUI{
    /**顶部*/
    [self topView];
    self.topView.backgroundColor = [UIColor redColor];
    /**底部*/
    [self bottomControllerView];
    /**loading*/
    [self loadingView];
    /** 底部控制view*/
    self.bottomControllerView.backgroundColor = [UIColor greenColor];
}
#pragma mark - property
-(NYPlayerTopView *)topView{
    if (!_topView) {
        NYPlayerTopView *view = [[NYPlayerTopView alloc] init];
        [self addSubview:view];
        _topView = view;
    }
    return _topView;
}

-(NYPlayerBottomControllerView *)bottomControllerView{
    if (!_bottomControllerView) {
        NYPlayerBottomControllerView *view = [[NYPlayerBottomControllerView alloc] init];
        [self addSubview:view];
        _bottomControllerView = view;
    }
    return _bottomControllerView;
}

-(NYSpeedLoadingView *)loadingView{
    if (!_loadingView) {
        NYSpeedLoadingView *loadingView = [[NYSpeedLoadingView alloc] init];
        [self addSubview:loadingView];
        _loadingView = loadingView;
    }
    return _loadingView;
}
- (UIButton *)playOrPauseBtn {
    if (!_playOrPauseBtn) {
        UIButton *playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:playOrPauseBtn];
        [playOrPauseBtn addTarget:self action:@selector(playOrPauseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _playOrPauseBtn = playOrPauseBtn;
        [_playOrPauseBtn setImage:NYPlayer_Image(@"new_allPlay_44x44_") forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:NYPlayer_Image(@"new_allPause_44x44_") forState:UIControlStateSelected];
    }
    return _playOrPauseBtn;
}

-(void)setUrlStr:(NSString *)urlStr{
    self.currentManager = [[NYAVPlayerManager alloc] init];
    urlStr = @"https://www.apple.com/105/media/us/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/grimes/mac-grimes-tpl-cc-us-2018_1280x720h.mp4";
    self.currentManager.assetURL = [NSURL URLWithString:urlStr];
    //    self.currentManager.muted = NO;
    //    self.currentManager.volume = 1;
    [self insertSubview:self.currentManager.view atIndex:0];
    self.currentManager.view.frame = self.bounds;
    self.bottomControllerView.currentManager = self.currentManager;
    
    @weakify(self)
    //播放结束回调
    [self.currentManager setPlayerDidToEnd:^(id<NYPlayerMediaPlayback>  _Nonnull asset) {
//        @strongify(self)
        NYLog(@"--- end");
    }];
    //加载状态改变
    [self.currentManager setPlayerLoadStateChanged:^(id<NYPlayerMediaPlayback>  _Nonnull asset, NYPlayerLoadState loadState) {
        @strongify(self)
        if (loadState == NYPlayerLoadStatePrepare) {
            self.coverImageView.hidden = NO;
        } else if (loadState == NYPlayerLoadStatePlaythroughOK || loadState == NYPlayerLoadStatePlayable) {
            self.coverImageView.hidden = YES;
            asset.view.backgroundColor = [UIColor blackColor];
        }
        if (loadState == NYPlayerLoadStateStalled && asset.isPlaying) {
            [self.loadingView startAnimating];
        } else if ((loadState == NYPlayerLoadStateStalled || loadState == NYPlayerLoadStatePrepare) && asset.isPlaying) {
            [self.loadingView startAnimating];
        } else {
            [self.loadingView stopAnimating];
        }
    }];
    //播放状态改变
    [self.currentManager setPlayerPlayStateChanged:^(id<NYPlayerMediaPlayback>  _Nonnull asset, NYPlayerPlaybackState playState) {
        @strongify(self)
        if (playState == NYPlayerPlayStatePlaying) {
            [self playBtnSelectedState:YES];
            /// 开始播放时候判断是否显示loading
            if (asset.loadState == NYPlayerLoadStateStalled) {
                [self.loadingView startAnimating];
            } else if ((asset.loadState == NYPlayerLoadStateStalled || asset.loadState == NYPlayerLoadStatePrepare)) {
                [self.loadingView startAnimating];
            }
        } else if (playState == NYPlayerPlayStatePaused) {
            [self playBtnSelectedState:NO];
            /// 暂停的时候隐藏loading
            [self.loadingView stopAnimating];
        } else if (playState == NYPlayerPlayStatePlayFailed) {
            [self.loadingView stopAnimating];
        }
    }];
    //播放进度改变回调
    [self.currentManager setPlayerPlayTimeChanged:^(id<NYPlayerMediaPlayback>  _Nonnull asset, NSTimeInterval currentTime, NSTimeInterval duration) {
        @strongify(self)
        float progress = 0;
        if (duration == 0) {
            progress = 0;
        }
        progress = currentTime / duration;
        if (!self.bottomControllerView.slider.isdragging) {
            NSString *currentTimeString = [NYUtilities convertTimeSecond:currentTime];
            NSString *totalTimeString = [NYUtilities convertTimeSecond:duration];
            self.bottomControllerView.slider.value = progress;
            self.bottomControllerView.timeProgressLabel.text = [NSString stringWithFormat:@"%@/%@",currentTimeString,totalTimeString];
            self.bottomControllerView.slider.value = progress;
        }
        self.bottomControllerView.bottomPgrogress.value = progress;
    }];
    /// 缓冲改变回调
    [self.currentManager setPlayerBufferTimeChanged:^(id<NYPlayerMediaPlayback>  _Nonnull asset, NSTimeInterval bufferTime) {
        @strongify(self)
        float bufferProgress = 0;
        if (asset.totalTime == 0) {
            bufferProgress = 0;
        }
        bufferProgress = asset.bufferTime / asset.totalTime;
        self.bottomControllerView.slider.bufferValue = bufferProgress;
        self.bottomControllerView.bottomPgrogress.bufferValue = bufferProgress;
    }];
    
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    
    
    // 准备好了将要播放
    [self.currentManager setPlayerReadyToPlay:^(id<NYPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {

    }];
    
    [self addNotification];
    
    
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}
-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - click
-(void)playOrPauseBtnClick:(UIButton *)sender{
    [self playOrPause];
}
#pragma mark - other
/// 根据当前播放状态取反
- (void)playOrPause {
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.isSelected;
    self.playOrPauseBtn.isSelected ? [self.currentManager play]: [self.currentManager pause];
    
    self.bottomControllerView.playOrPauseBtn.selected = !self.bottomControllerView.playOrPauseBtn.isSelected;
    self.bottomControllerView.playOrPauseBtn.isSelected ? [self.currentManager play]: [self.currentManager pause];
}

- (void)playBtnSelectedState:(BOOL)selected {
    self.playOrPauseBtn.selected = selected;
}

#pragma mark - UIDeviceOrientationDidChangeNotification
-(void)deviceOrientationDidChange:(NSNotification *)notification{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
        NSLog(@"左边");
        [self toFullScreenWithisLeft:NO];
    }else if(deviceOrientation == UIDeviceOrientationPortrait){
        NSLog(@"竖着");
        [self quitFullScreen];
    }else if(deviceOrientation == UIDeviceOrientationLandscapeRight){
        NSLog(@"右边");
        [self toFullScreenWithisLeft:YES];
    }else{
        NSLog(@"其他");
    }
}

//进入全屏模式
-(void)toFullScreenWithisLeft:(BOOL)isLeft{
    NYVideoFullScreenVC *vc = [[NYVideoFullScreenVC alloc] initWithPlayerView:self isLeft:isLeft];
    [self.detailVC presentViewController:vc animated:YES completion:nil];
    self.fullScreenVC = vc;
}
//退出全屏模式
-(void)quitFullScreen{
    if (self.fullScreenVC) {
        [self.fullScreenVC dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
