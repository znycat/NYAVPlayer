//
//  NYPlayerBottomControllerView.m
//  NYPlayerIJKPlayer
//
//  Created by 翟乃玉 on 2019/6/27.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import "NYPlayerBottomControllerView.h"
@interface NYPlayerBottomControllerView()<NYSliderViewDelegate>
/// 播放还是暂停按钮
@property(nonatomic, weak)UIButton *playOrPauseBtn;
/** 清晰度按钮*/
@property(nonatomic, weak)UIButton *definitionBtn;
/** 倍速按钮*/
@property(nonatomic, weak)UIButton *rateBtn;
/** 全屏按钮*/
@property(nonatomic, weak)UIButton *fullScreenBtn;
/** 时间进度label 1:03/3:33*/
@property(nonatomic, weak)UILabel *timeProgressLabel;
/// 滑杆
@property (nonatomic, weak) NYSliderView *slider;
/// 底部播放进度
@property (nonatomic, weak) NYSliderView *bottomPgrogress;

@end
@implementation NYPlayerBottomControllerView


#pragma mark - cycle
- (void)dealloc{
    NSLog(@"delloc");
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    [self playOrPauseBtn];
    [self fullScreenBtn];
    [self slider];
    [self bottomPgrogress];
    [self timeProgressLabel];
    [self definitionBtn];
}
#pragma mark - property
-(void)setFrame:(CGRect)frame{
    CGFloat maxW = frame.size.width;
    CGFloat maxH = frame.size.height;
    
    CGFloat playOrPauseBtnW = 40;
    CGFloat playOrPauseBtnH = playOrPauseBtnW;
    self.playOrPauseBtn.frame = CGRectMake(0, 0, playOrPauseBtnW, playOrPauseBtnH);

    //全屏按钮
    CGFloat fullScreenBtnW = 40;
    CGFloat fullScreenBtnH = fullScreenBtnW;
    CGFloat fullScreenBtnX = maxW - fullScreenBtnW - 20;
    CGFloat fullScreenBtnY = 0;
    self.fullScreenBtn.frame = CGRectMake(fullScreenBtnX, fullScreenBtnY, fullScreenBtnW, fullScreenBtnH);

    //倍速按钮
    CGFloat rateBtnW = 40;
    CGFloat rateBtnH = rateBtnW;
    CGFloat rateBtnX = maxW - rateBtnW - 20;
    CGFloat rateBtnY = 0;
    self.rateBtn.frame = CGRectMake(rateBtnX, rateBtnY, rateBtnW, rateBtnH);
    
    //高清按钮
    CGFloat definitionBtnW = 40;
    CGFloat definitionBtnH = definitionBtnW;
    CGFloat definitionBtnX = self.rateBtn.ny_x - definitionBtnW - 20;
    CGFloat definitionBtnY = 0;
    self.definitionBtn.frame = CGRectMake(definitionBtnX, definitionBtnY, definitionBtnW, definitionBtnH);

    CGFloat timeProgressLabelW = 100;
    CGFloat timeProgressLabelH = 40;
    UIView *btn = self.fullScreenBtn;
    if (self.fullScreenBtn.hidden == NO) {
        btn = self.fullScreenBtn;
    }else{
        btn = self.definitionBtn;
    }
    CGFloat timeProgressLabelX = btn.ny_x - timeProgressLabelW - 20;
    CGFloat timeProgressLabelY = 0;
    self.timeProgressLabel.frame = CGRectMake(timeProgressLabelX, timeProgressLabelY, timeProgressLabelW, timeProgressLabelH);
    
    CGFloat sliderX = self.playOrPauseBtn.ny_max_x + 10;
    CGFloat sliderY = 0;
    CGFloat sliderW = self.timeProgressLabel.ny_x - 30 - sliderX;
    CGFloat sliderH = self.playOrPauseBtn.ny_height;
    self.slider.frame = CGRectMake(sliderX, sliderY, sliderW, sliderH);
    
    self.bottomPgrogress.frame = CGRectMake(0, maxH - 2, maxW, 2);
    [super setFrame:frame];
}
-(UIButton *)playOrPauseBtn{
    if (!_playOrPauseBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [self addSubview:btn];
        _playOrPauseBtn = btn;
        [_playOrPauseBtn setImage:NYPlayer_Image(@"new_allPlay_44x44_") forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:NYPlayer_Image(@"new_allPause_44x44_") forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _playOrPauseBtn;
}
-(UIButton *)definitionBtn{
    if (!_definitionBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [self addSubview:btn];
        _definitionBtn = btn;
        [btn setTitle:@"高清" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(definitionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _definitionBtn = btn;
    }
    return _definitionBtn;
}
-(UIButton *)fullScreenBtn{
    if (!_fullScreenBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [self addSubview:btn];
        [btn setTitle:@"全屏" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _fullScreenBtn = btn;
    }
    return _fullScreenBtn;
}

- (UILabel *)timeProgressLabel {
    if (!_timeProgressLabel) {
        UILabel *progressLabel = [[UILabel alloc] init];
        [self addSubview:progressLabel];
        _timeProgressLabel = progressLabel;
        progressLabel.textColor = [UIColor whiteColor];
        progressLabel.font = [UIFont systemFontOfSize:14.0f];
        progressLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeProgressLabel;
    
}
- (UIButton *)rateBtn{
    if (!_rateBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [self addSubview:btn];
        [btn setTitle:@"倍速" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(rateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _rateBtn = btn;
    }
    return _rateBtn;
}

- (NYSliderView *)slider {
    if (!_slider) {
        NYSliderView *slider = [[NYSliderView alloc] initWithFrame:CGRectZero];
        [self addSubview:slider];
        _slider = slider;
        slider.delegate = self;
        _slider.sliderBtn.backgroundColor = [UIColor redColor];
        _slider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
        _slider.bufferTrackTintColor  = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _slider.minimumTrackTintColor = [UIColor whiteColor];
//        [_slider setThumbImage:ZFPlayer_Image(@"ZFPlayer_slider") forState:UIControlStateNormal];
        _slider.sliderHeight = 2;
    }
    return _slider;
}
- (NYSliderView *)bottomPgrogress {
    if (!_bottomPgrogress) {
        NYSliderView *bottomPgrogress = [[NYSliderView alloc] init];
        [self addSubview:bottomPgrogress];
        _bottomPgrogress = bottomPgrogress;
        _bottomPgrogress.maximumTrackTintColor = [UIColor clearColor];
        _bottomPgrogress.minimumTrackTintColor = [UIColor purpleColor];
        _bottomPgrogress.bufferTrackTintColor  = [UIColor redColor];//[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _bottomPgrogress.sliderHeight = 2;
        _bottomPgrogress.isHideSliderBlock = NO;
    }
    return _bottomPgrogress;
}

#pragma mark - click
-(void)playBtnClick:(id)sender{
    if(self.playBtnClickBlock)self.playBtnClickBlock(self,self.playOrPauseBtn);
}
-(void)fullScreenBtnClick:(id)sender{
    if(self.fullScreenBtnBlock)self.fullScreenBtnBlock(self);
    self.fullScreenBtn.hidden = YES;
    self.rateBtn.hidden = NO;
    self.definitionBtn.hidden = NO;
    [self setFrame:self.frame];
}
-(void)definitionBtnClick:(id)sender{
    if(self.definitionBtnClickBlock)self.definitionBtnClickBlock(self);
}
-(void)rateBtnClick:(id)sender{
    if(self.rateBtnClickBlock)self.rateBtnClickBlock(self);
    self.fullScreenBtn.hidden = NO;
    self.rateBtn.hidden = YES;
    self.definitionBtn.hidden = YES;
    [self setFrame:self.frame];
}
/// 调节播放进度slider和当前时间更新
- (void)sliderValueChanged:(CGFloat)value currentTimeString:(NSString *)timeString {
    self.slider.value = value;
    self.timeProgressLabel.text = timeString;
    self.slider.isdragging = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.sliderBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
}
#pragma mark - NYSliderViewDelegate
// 滑块滑动开始
- (void)sliderTouchBegan:(float)value{
    self.slider.isdragging = YES;
}
// 滑块滑动中
- (void)sliderValueChanged:(float)value{
    if (self.currentManager.totalTime == 0) {
        self.slider.value = 0;
        return;
    }
    self.slider.isdragging = YES;
    NSString *currentTimeString = [NYUtilities convertTimeSecond:self.currentManager.totalTime*value];
    self.timeProgressLabel.text = currentTimeString;
}
// 滑块滑动结束
- (void)sliderTouchEnded:(float)value{
    if (self.currentManager.totalTime > 0) {
        @weakify(self)
        [self.currentManager seekToTime:self.currentManager.totalTime*value completionHandler:^(BOOL finished) {
            @strongify(self)
            if (finished) {
                self.slider.isdragging = NO;
            }
        }];
    } else {
        self.slider.isdragging = NO;
    }
}
// 滑杆点击
- (void)sliderTapped:(float)value{
    if (self.currentManager.totalTime > 0) {
        self.slider.isdragging = YES;
        @weakify(self)
        [self.currentManager seekToTime:self.currentManager.totalTime*value completionHandler:^(BOOL finished) {
            @strongify(self)
            if (finished) {
                self.slider.isdragging = NO;
                [self.currentManager play];
            }
        }];
    } else {
        self.slider.isdragging = NO;
        self.slider.value = 0;
    }
}
@end
