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
#import "NYSmallView.h"
#import "NYPlayerGestureControl.h"
/** NYPlayerControllerView 的tag*/
NSInteger const NYPlayerControllerViewTag = 2019741006666;

static NSString *const NYSmallViewCenterStringKey                   = @"NYSmallViewCenterStringKey";
@interface NYPlayerControllerView()<NYSliderViewDelegate>
@property(nonatomic,assign)NYPlayererViewStyle playerViewStyle;
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
/// 中间重播按钮
@property (nonatomic, strong) UIButton *replayBtn;

@property (nonatomic, strong) id <NYPlayerMediaPlayback> currentManager;

/// 小窗容器View
@property (nonatomic, weak)NYSmallView *smallView;

@property (nonatomic, strong)NYPlayerGestureControl *gestureControl;

@property(nonatomic,copy)NSString *urlStr;

@property (nonatomic, assign) BOOL controlViewAppeared;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) dispatch_block_t afterBlock;
@property (nonatomic, assign) NSTimeInterval sumTime;
@end
@implementation NYPlayerControllerView
#pragma mark - cycle
-(void)dealloc{
    NYLog(@"delloc");
    [self.currentManager stop];
}

static NYPlayerControllerView *_shareInstance;
+ (instancetype)sharePlayer {
    if (!_shareInstance) {
        _shareInstance = [[NYPlayerControllerView alloc] init];
        [self install];
    }
    return _shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    if (!_shareInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareInstance = [super allocWithZone:zone];
        });
    }
    return _shareInstance;
}
+(void)install{
    _shareInstance.tag = NYPlayerControllerViewTag;
    [_shareInstance setupUI];
    [_shareInstance setupClick];
    _shareInstance.playerViewStyle = NYPlayererViewStyleNone;
    _shareInstance.autoFadeTimeInterval = 0.2;
    _shareInstance.autoHiddenTimeInterval = 2.5;
}

-(void)setFrame:(CGRect)frame{
    CGFloat maxW = frame.size.width;
    CGFloat maxH = frame.size.height;
    
    self.currentManager.view.frame = CGRectMake(0, 0, maxW, maxH);
    //顶部
    self.topView.frame = CGRectMake(0, 0, maxW, 50);
    //底部
    self.bottomControllerView.frame = CGRectMake(0, maxH - 88, maxW, 88);
    
    if (!self.isShow) {
        self.topView.ny_y = -self.topView.ny_height;
        self.bottomControllerView.ny_y = self.ny_height;
        self.playOrPauseBtn.alpha = 0;
    } else {
        self.topView.ny_y = 0;
        self.bottomControllerView.ny_y = self.ny_height - self.bottomControllerView.ny_height;
        self.playOrPauseBtn.alpha = 1;
    }
    

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
    self.replayBtn.frame = self.playOrPauseBtn.frame;
    [super setFrame:frame];
}

/// 设置回调
-(void)setupClick{
    @weakify(self)
    /** 顶部回调*/
    [self.topView setBackBtnClickBlock:^(NYPlayerTopView * _Nonnull topView) {
        @strongify(self)
        if (self.fullScreenVC) {
            [self quitFullScreenAnimated:YES];
        }else{
            self.playerViewStyle = NYPlayererViewStyleAnimating;
            [self.detailVC dismissViewControllerAnimated:YES completion:^{
                @strongify(self)
                self.playerViewStyle = NYPlayererViewStyleNone;
                self.detailVC = nil;
            }];
        }
    }];
    [self.topView setSmallBtnClickBlock:^(NYPlayerTopView * _Nonnull topView) {
        @strongify(self)
        [self goSmallViewAnimated:YES];
    }];
    [self.topView setDownloadBtnClickBlock:^(NYPlayerTopView * _Nonnull topView) {
        @strongify(self)
        if(self.topDownloadBtnClickBlock)self.topDownloadBtnClickBlock(self, topView);
    }];
    /// 底部回掉
    [self.bottomControllerView setPlayBtnClickBlock:^(NYPlayerBottomControllerView * _Nonnull bottomView, UIButton * _Nonnull playOrPauseBtn) {
        @strongify(self)
        [self playOrPauseBtnClick];
    }];
    
    [self.bottomControllerView setFullScreenBtnBlock:^(NYPlayerBottomControllerView * _Nonnull bottomView) {
        @strongify(self)
        [self goFullScreenWithisLeft:NO animated:YES];
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
    [self coverImageView];
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
        [playOrPauseBtn addTarget:self action:@selector(playOrPauseBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        _playOrPauseBtn = playOrPauseBtn;
        [_playOrPauseBtn setImage:NYPlayer_Image(@"icVideoPlay") forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:NYPlayer_Image(@"icVideoPause") forState:UIControlStateSelected];
    }
    return _playOrPauseBtn;
}
- (UIButton *)replayBtn {
    if (!_replayBtn) {
        UIButton *replayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:replayBtn];
        [replayBtn addTarget:self action:@selector(replayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _replayBtn = replayBtn;
        [_replayBtn setImage:NYPlayer_Image(@"icVideoPlay") forState:UIControlStateNormal];
    }
    return _playOrPauseBtn;
}
-(id<NYPlayerMediaPlayback>)currentManager{
    if (!_currentManager) {
        NYAVPlayerManager *currentManager = [[NYAVPlayerManager alloc] init];
        _currentManager = currentManager;
        _currentManager.shouldAutoPlay = NO;
    }
    return _currentManager;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        UIImageView *coverImageView = [[UIImageView alloc] init];
        [self addSubview:coverImageView];
        coverImageView.image = [UIImage imageNamed:@"IMG_7838"];
        _coverImageView = coverImageView;
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImageView;
}
-(NYPlayerGestureControl *)gestureControl{
    if (!_gestureControl) {
        NYPlayerGestureControl *gestureControl = [[NYPlayerGestureControl alloc] init];
        _gestureControl = gestureControl;
        @weakify(self)
        gestureControl.triggerCondition = ^BOOL(NYPlayerGestureControl * _Nonnull control, NYPlayerGestureType type, UIGestureRecognizer * _Nonnull gesture, UITouch *touch) {
            //@strongify(self)
            return YES;
        };
        
        gestureControl.singleTapped = ^(NYPlayerGestureControl * _Nonnull control) {
            @strongify(self)
            [self gestureSingleTapped:control];
            //            if ([self.controlView respondsToSelector:@selector(gestureSingleTapped:)]) {
            //                [self.controlView gestureSingleTapped:control];
            //            }
        };
        
        gestureControl.doubleTapped = ^(NYPlayerGestureControl * _Nonnull control) {
            @strongify(self)
            [self gestureDoubleTapped:control];
            //            if ([self.controlView respondsToSelector:@selector(gestureDoubleTapped:)]) {
            //                [self.controlView gestureDoubleTapped:control];
            //            }
        };
        
        gestureControl.beganPan = ^(NYPlayerGestureControl * _Nonnull control, NYPanDirection direction, NYPanLocation location) {
            @strongify(self)
            [self gestureBeganPan:control panDirection:direction panLocation:location];
            //            if ([self.controlView respondsToSelector:@selector(gestureBeganPan:panDirection:panLocation:)]) {
            //                [self.controlView gestureBeganPan:control panDirection:direction panLocation:location];
            //            }
        };
        
        gestureControl.changedPan = ^(NYPlayerGestureControl * _Nonnull control, NYPanDirection direction, NYPanLocation location, CGPoint velocity) {
            @strongify(self)
            [self gestureChangedPan:control panDirection:direction panLocation:location withVelocity:velocity];
            //            if ([self.controlView respondsToSelector:@selector(gestureChangedPan:panDirection:panLocation:withVelocity:)]) {
            //                [self.controlView gestureChangedPan:control panDirection:direction panLocation:location withVelocity:velocity];
            //            }
        };
        
        gestureControl.endedPan = ^(NYPlayerGestureControl * _Nonnull control, NYPanDirection direction, NYPanLocation location) {
            @strongify(self)
            [self gestureEndedPan:control panDirection:direction panLocation:location];
            //            if ([self.controlView respondsToSelector:@selector(gestureEndedPan:panDirection:panLocation:)]) {
            //                [self.controlView gestureEndedPan:control panDirection:direction panLocation:location];
            //            }
        };
        
        gestureControl.pinched = ^(NYPlayerGestureControl * _Nonnull control, float scale) {
            @strongify(self)
            [self gesturePinched:control scale:scale];
            //            if ([self.controlView respondsToSelector:@selector(gesturePinched:scale:)]) {
            //                [self.controlView gesturePinched:control scale:scale];
            //            }
        };
    }
    return _gestureControl;
}



// 设置播放控制器的各种回掉
-(void)setupCurrentManager{
    //    self.currentManager.muted = NO;
    //    self.currentManager.volume = 1;
    [self insertSubview:self.currentManager.view atIndex:0];
    self.currentManager.view.frame = self.bounds;
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
            [self playBtnSelectedState:NO];
            /// 开始播放时候判断是否显示loading
            if (asset.loadState == NYPlayerLoadStateStalled) {
                [self.loadingView startAnimating];
            } else if ((asset.loadState == NYPlayerLoadStateStalled || asset.loadState == NYPlayerLoadStatePrepare)) {
                [self.loadingView startAnimating];
            }
        } else if (playState == NYPlayerPlayStatePaused) {
            [self playBtnSelectedState:YES];
            /// 暂停的时候隐藏loading
            [self.loadingView stopAnimating];
        } else if (playState == NYPlayerPlayStatePlayFailed) {
            [self.loadingView stopAnimating];
        }
        if (playState == NYPlayerPlayStatePlayStopped){
            self.replayBtn.hidden = NO;
            self.playOrPauseBtn.hidden = YES;
        }else{
            self.replayBtn.hidden = YES;
            self.playOrPauseBtn.hidden = NO;
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
            self.bottomControllerView.currentTimeLabel.text = currentTimeString;
            self.bottomControllerView.totalTimeLabel.text = totalTimeString;
            self.bottomControllerView.slider.value = progress;
            self.bottomControllerView.frame = self.bottomControllerView.frame;
        }
        self.bottomControllerView.bottomProgres.value = progress;
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
        self.bottomControllerView.bottomProgres.bufferValue = bufferProgress;
    }];
    
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    
    
    // 准备好了将要播放
    [self.currentManager setPlayerReadyToPlay:^(id<NYPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
        
    }];
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}
-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - click
-(void)playOrPauseBtnClick{
    if (self.playOrPauseBtn.isSelected) {
        [self.currentManager play];
    }else{
        [self.currentManager pause];
    }
}
-(void)replayBtnClick:(UIButton *)sender{
    [self.currentManager replay];
}

#pragma mark - other
- (void)playBtnSelectedState:(BOOL)selected {
    self.playOrPauseBtn.selected = selected;
    self.bottomControllerView.playOrPauseBtn.selected = selected;
}

#pragma mark - UIDeviceOrientationDidChangeNotification
-(void)deviceOrientationDidChange:(NSNotification *)notification{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
        NYLog(@"左边");
        [self goFullScreenWithisLeft:NO animated:YES];
    }else if(deviceOrientation == UIDeviceOrientationPortrait){
        NYLog(@"竖着");
        [self quitFullScreenAnimated:YES];
    }else if(deviceOrientation == UIDeviceOrientationLandscapeRight){
        NYLog(@"右边");
        [self goFullScreenWithisLeft:YES animated:YES];
    }else{
        NYLog(@"其他");
    }
}
/// 进入详情页
-(void)goDetailVCanimated:(BOOL)animated{
    if (animated) {
        self.playerViewStyle = NYPlayererViewStyleAnimating;
    }
    NYVideoDetailVC *vc = [[NYVideoDetailVC alloc] initWithURLString:self.urlStr];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:^{
        self.playerViewStyle = NYPlayererViewStyleDetail;
    }];
    self.detailVC = vc;
}

/// 进入全屏模式
-(void)goFullScreenWithisLeft:(BOOL)isLeft animated:(BOOL)animated{
    if (animated) {
        self.playerViewStyle = NYPlayererViewStyleAnimating;
    }
    NYVideoFullScreenVC *vc = [[NYVideoFullScreenVC alloc] initWithIsLeft:isLeft];
    [self.detailVC presentViewController:vc animated:animated completion:^{
        self.playerViewStyle = NYPlayererViewStyleFullScreen;
    }];
    self.fullScreenVC = vc;
}
/// 退出全屏模式
-(void)quitFullScreenAnimated:(BOOL)animated{
    if (![self.fullScreenVC isKindOfClass:NYVideoFullScreenVC.class]) {
        return;
    }
    if (animated) {
        self.playerViewStyle = NYPlayererViewStyleAnimating;
    }
    [self.fullScreenVC dismissViewControllerAnimated:YES completion:^{
        self.playerViewStyle = NYPlayererViewStyleDetail;
    }];
}
/// 去小窗
-(void)goSmallViewAnimated:(BOOL)animated{
    NYSmallView *smallView = [[NYSmallView alloc] initWithFrame:CGRectMake(10, 100, 150, 150)];
    [[UIApplication sharedApplication].keyWindow addSubview:smallView];
    self.smallView = smallView;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.detailVC dismissViewControllerAnimated:NO completion:nil];
    NSString *smallCenterSty = [[NSUserDefaults standardUserDefaults] objectForKey:NYSmallViewCenterStringKey];
    if ([smallCenterSty isKindOfClass:NSString.class]) {
        self.smallView.center = CGPointFromString(smallCenterSty);
    }
    
    @weakify(self)
    [smallView setCloseBtnClickBlock:^(NYSmallView * _Nonnull smallView) {
        @strongify(self)
        [self closeSmallView];
    }];
    
    if (animated) {
        self.smallView.hidden = YES;
        self.playerViewStyle = NYPlayererViewStyleAnimating;
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            self.frame = self.smallView.frame;
            self.smallView.frame = self.smallView.frame;
        } completion:^(BOOL finished) {
            self.smallView.hidden = NO;
            [self.smallView insertSubview:self atIndex:0];
            self.frame = self.smallView.bounds;
            self.smallView.frame = self.smallView.frame;
            self.playerViewStyle = NYPlayererViewStyleSmall;
        }];
    }else{
        self.smallView.hidden = NO;
        [self.smallView insertSubview:self atIndex:0];
        self.frame = self.smallView.bounds;
        self.smallView.frame = self.smallView.frame;
        self.playerViewStyle = NYPlayererViewStyleSmall;
    }
}
/// 关闭小窗
-(void)closeSmallView{
    [self.smallView removeFromSuperview];
    NSString *smallViewCenterStr = NSStringFromCGPoint(self.smallView.center);
    [[NSUserDefaults standardUserDefaults] setObject:smallViewCenterStr forKey:NYSmallViewCenterStringKey];
}



-(void)setPlayerViewStyle:(NYPlayererViewStyle)playerViewStyle{
    _playerViewStyle = playerViewStyle;
    if (playerViewStyle == NYPlayererViewStyleNone) {//此状态 无控制 只有站位图和播放状态显示
        self.topView.hidden = YES;
        self.bottomControllerView.hidden = YES;
        
    }else if (playerViewStyle == NYPlayererViewStyleAnimating) {//在动画中
        self.topView.hidden = YES;
        self.bottomControllerView.hidden = YES;
        
    }else if (playerViewStyle == NYPlayererViewStyleFullScreen) {//全屏状态
        self.topView.hidden = NO;
        self.topView.downloadBtn.hidden = NO;
        self.topView.smallBtn.hidden = YES;
        
        self.bottomControllerView.hidden = NO;
        self.bottomControllerView.rateBtn.hidden = NO;
        self.bottomControllerView.frame = self.bottomControllerView.frame;
    }else if (playerViewStyle == NYPlayererViewStyleDetail) {//竖屏 详情状态
        self.topView.hidden = NO;
        self.topView.downloadBtn.hidden = YES;
        self.topView.smallBtn.hidden = NO;
        
        self.bottomControllerView.hidden = NO;
        self.bottomControllerView.rateBtn.hidden = YES;
        self.bottomControllerView.frame = self.bottomControllerView.frame;
        
        self.gestureControl.disablePanMovingDirection = NYPlayerDisablePanMovingDirectionVertical;
    }
        
        
    if (playerViewStyle == NYPlayererViewStyleSmall) {//小窗状态
        self.topView.hidden = YES;
        self.bottomControllerView.hidden = YES;
        self.smallView.hidden = NO;
    }else{
        self.smallView.hidden = YES;
    }
}

-(void)playWithURLStr:(NSString *)urlStr superView:(UIView *)superView isAutoPlay:(BOOL)isAutoPlay playerViewStyle:(NYPlayererViewStyle)playerViewStyle{
    [self playWithURLStr:urlStr superView:superView isAutoPlay:isAutoPlay playerViewStyle:playerViewStyle nearestVC:nil];
}
-(void)playWithURLStr:(NSString *)urlStr superView:(UIView *)superView isAutoPlay:(BOOL)isAutoPlay playerViewStyle:(NYPlayererViewStyle)playerViewStyle nearestVC:(nullable UIViewController *)nearestVC{
    
    if ([_urlStr isEqualToString:urlStr] && self.currentManager.assetURL) {
        if ([nearestVC isKindOfClass:NYVideoDetailVC.class]) {
            [superView insertSubview:self atIndex:0];
            self.frame = superView.bounds;
            self.bottomControllerView.slider.delegate = self;
        }
        return;
    }
    if (urlStr == nil) {
        return;
    }
    
    [superView insertSubview:self atIndex:0];
    self.frame = superView.bounds;
    self.urlStr = urlStr;
    self.currentManager.assetURL = [NSURL URLWithString:urlStr];
    if (isAutoPlay) {
        [self.currentManager play];
        self.playOrPauseBtn.selected = NO;
    }else{
        self.playOrPauseBtn.selected = YES;
    }
    self.playerViewStyle = playerViewStyle;
    [self setupCurrentManager];
    [self resetControlView];
    [self addNotification];
    [self.gestureControl addGestureToView:self];
    self.bottomControllerView.slider.delegate = self;
}

/** 重置ControlView */
- (void)resetControlView {
    self.bottomControllerView.alpha= 1;
    self.topView.alpha= 1;
    self.bottomControllerView.slider.value = 0;
    self.bottomControllerView.slider.bufferValue = 0;
    self.bottomControllerView.currentTimeLabel.text = @"00:00";
    self.bottomControllerView.totalTimeLabel.text = @"00:00";
    self.bottomControllerView.playOrPauseBtn.selected = YES;
    self.backgroundColor = [UIColor blackColor];
    [self removeNotification];
}

#pragma mark - 控制层的现实隐藏
- (void)showControlView {
    self.topView.alpha           = 1;
    self.bottomControllerView.alpha        = 1;
    self.isShow                      = YES;
    self.topView.ny_y            = 0;
    self.bottomControllerView.ny_y         = self.ny_height - self.bottomControllerView.ny_height;
    self.playOrPauseBtn.alpha        = 1;
}

- (void)hideControlView {
    self.isShow                      = NO;
    self.topView.ny_y            = -self.topView.ny_height;
    self.bottomControllerView.ny_y         = self.ny_height;
    self.playOrPauseBtn.alpha        = 0;
    self.topView.alpha           = 0;
    self.bottomControllerView.alpha        = 0;
}

- (void)autoFadeOutControlView {
    self.controlViewAppeared = YES;
    [self cancelAutoFadeOutControlView];
    @weakify(self)
    self.afterBlock = dispatch_block_create(0, ^{
        @strongify(self)
        [self hideControlViewWithAnimated:YES];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.autoHiddenTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(),self.afterBlock);
}

/// 取消延时隐藏controlView的方法
- (void)cancelAutoFadeOutControlView {
    if (self.afterBlock) {
        dispatch_block_cancel(self.afterBlock);
        self.afterBlock = nil;
    }
}

/// 隐藏控制层
- (void)hideControlViewWithAnimated:(BOOL)animated {
    self.controlViewAppeared = NO;
    [UIView animateWithDuration:animated ? self.autoFadeTimeInterval : 0 animations:^{
        [self hideControlView];
    } completion:^(BOOL finished) {
        
    }];
}

/// 显示控制层
- (void)showControlViewWithAnimated:(BOOL)animated {
    self.controlViewAppeared = YES;
    [self autoFadeOutControlView];
    [UIView animateWithDuration:animated ? self.autoFadeTimeInterval : 0 animations:^{
        [self showControlView];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - NYPlayerGestureControl手势
/// 单击手势事件
- (void)gestureSingleTapped:(NYPlayerGestureControl *)gestureControl {
    if (self.playerViewStyle == NYPlayererViewStyleSmall || self.playerViewStyle == NYPlayererViewStyleNone) {
        [self goDetailVCanimated:YES];
    }else if(self.playerViewStyle == NYPlayererViewStyleFullScreen || self.playerViewStyle == NYPlayererViewStyleDetail){
        if (self.controlViewAppeared) {
            [self hideControlViewWithAnimated:YES];
        } else {
            /// 显示之前先把控制层复位，先隐藏后显示
            [self hideControlViewWithAnimated:NO];
            [self showControlViewWithAnimated:YES];
        }
    }
}

/// 双击手势事件
- (void)gestureDoubleTapped:(NYPlayerGestureControl *)gestureControl {
    //    [self playOrPause];
}

/// 开始滑动手势事件
- (void)gestureBeganPan:(NYPlayerGestureControl *)gestureControl panDirection:(NYPanDirection)direction panLocation:(NYPanLocation)location {
    if (direction == NYPanDirectionH) {
        self.sumTime = self.currentManager.currentTime;
    }
}

/// 滑动中手势事件
- (void)gestureChangedPan:(NYPlayerGestureControl *)gestureControl panDirection:(NYPanDirection)direction panLocation:(NYPanLocation)location withVelocity:(CGPoint)velocity {
    
}

/// 滑杆结束滑动
- (void)sliderChangeEnded {
    self.bottomControllerView.slider.isdragging = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomControllerView.slider.sliderBtn.transform = CGAffineTransformIdentity;
    }];
}
/// 滑动结束手势事件
- (void)gestureEndedPan:(NYPlayerGestureControl *)gestureControl panDirection:(NYPanDirection)direction panLocation:(NYPanLocation)location {
    @weakify(self)
    if (direction == NYPanDirectionH && self.sumTime >= 0 && self.currentManager.totalTime > 0) {
        [self.currentManager seekToTime:self.sumTime completionHandler:^(BOOL finished) {
            @strongify(self)
            /// 左右滑动调节播放进度
            [self sliderChangeEnded];
            if (self.controlViewAppeared) {
                [self autoFadeOutControlView];
            }
        }];
        self.sumTime = 0;
    }
}

/// 捏合手势事件，这里改变了视频的填充模式
- (void)gesturePinched:(NYPlayerGestureControl *)gestureControl scale:(float)scale {
    if (scale > 1) {
        self.currentManager.scalingMode = NYPlayerScalingModeAspectFill;
    } else {
        self.currentManager.scalingMode = NYPlayerScalingModeAspectFit;
    }
}

@end


#pragma mark - NYSliderViewDelegate 滑杆相关
@interface NYPlayerControllerView (NYSliderViewDelegate)

@end
@implementation NYPlayerControllerView(NYSliderViewDelegate)
// 滑块滑动开始
- (void)sliderTouchBegan:(float)value{
    self.bottomControllerView.slider.isdragging = YES;
}
// 滑块滑动中
- (void)sliderValueChanged:(float)value{
    if (self.currentManager.totalTime == 0) {
        self.bottomControllerView.slider.value = 0;
        return;
    }
    [self cancelAutoFadeOutControlView];
    self.bottomControllerView.slider.isdragging = YES;
    NSString *currentTimeString = [NYUtilities convertTimeSecond:self.currentManager.totalTime*value];
    self.bottomControllerView.currentTimeLabel.text = currentTimeString;
}
// 滑块滑动结束
- (void)sliderTouchEnded:(float)value{
    if (self.currentManager.totalTime > 0) {
        @weakify(self)
        [self.currentManager seekToTime:self.currentManager.totalTime*value completionHandler:^(BOOL finished) {
            @strongify(self)
            if (finished) {
                self.bottomControllerView.slider.isdragging = NO;
                [self autoFadeOutControlView];
            }
        }];
    } else {
        self.bottomControllerView.slider.isdragging = NO;
    }
}
// 滑杆点击
- (void)sliderTapped:(float)value{
    if (self.currentManager.totalTime > 0) {
        self.bottomControllerView.slider.isdragging = YES;
        @weakify(self)
        [self.currentManager seekToTime:self.currentManager.totalTime*value completionHandler:^(BOOL finished) {
            @strongify(self)
            if (finished) {
                self.bottomControllerView.slider.isdragging = NO;
                [self.currentManager play];
            }
        }];
    } else {
        self.bottomControllerView.slider.isdragging = NO;
        self.bottomControllerView.slider.value = 0;
    }
}

@end
