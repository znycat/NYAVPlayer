//
//  NYPlayerBottomControllerView.m
//  NYPlayerIJKPlayer
//
//  Created by 翟乃玉 on 2019/6/27.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import "NYPlayerBottomControllerView.h"
@interface NYPlayerBottomControllerView()
/// 播放还是暂停按钮
@property(nonatomic, weak)UIButton *playOrPauseBtn;
/** 清晰度按钮*/
@property(nonatomic, weak)UIButton *definitionBtn;
/** 倍速按钮*/
@property(nonatomic, weak)UIButton *rateBtn;
/** 全屏按钮*/
@property(nonatomic, weak)UIButton *fullScreenBtn;
/// 播放的当前时间
@property (nonatomic, weak) UILabel *currentTimeLabel;
/// 视频总时间
@property (nonatomic, weak) UILabel *totalTimeLabel;
/// 滑杆
@property (nonatomic, weak) NYSliderView *slider;

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
    [self currentTimeLabel];
    [self totalTimeLabel];
    [self definitionBtn];
}
#pragma mark - property
-(void)setFrame:(CGRect)frame{
    CGFloat maxW = frame.size.width;
    //CGFloat maxH = frame.size.height;
    
    CGFloat playOrPauseBtnW = 24;
    CGFloat playOrPauseBtnH = playOrPauseBtnW;
    self.playOrPauseBtn.frame = CGRectMake(8, 40, playOrPauseBtnW, playOrPauseBtnH);

    [self.currentTimeLabel sizeToFit];
    self.currentTimeLabel.frame = CGRectMake(self.playOrPauseBtn.ny_max_x + 6, self.playOrPauseBtn.ny_y, self.currentTimeLabel.ny_width, self.currentTimeLabel.ny_height);
    self.currentTimeLabel.ny_centerY = self.playOrPauseBtn.ny_centerY;
    
    //全屏按钮
    CGFloat fullScreenBtnW = 24;
    CGFloat fullScreenBtnH = fullScreenBtnW;
    CGFloat fullScreenBtnX = maxW - fullScreenBtnW - 8;
    CGFloat fullScreenBtnY = self.playOrPauseBtn.ny_y;
    self.fullScreenBtn.frame = CGRectMake(fullScreenBtnX, fullScreenBtnY, fullScreenBtnW, fullScreenBtnH);
    self.fullScreenBtn.ny_centerY = self.playOrPauseBtn.ny_centerY;
    
    //倍速按钮
    [self.rateBtn sizeToFit];
    CGFloat rateBtnW = self.rateBtn.ny_width;
    CGFloat rateBtnH = self.rateBtn.ny_height;
    CGFloat rateBtnX = self.fullScreenBtn.ny_x - rateBtnW - 14;
    CGFloat rateBtnY = self.playOrPauseBtn.ny_y;
    self.rateBtn.frame = CGRectMake(rateBtnX, rateBtnY, rateBtnW, rateBtnH);
    self.rateBtn.ny_centerY = self.playOrPauseBtn.ny_centerY;
    
    //高清按钮
    [self.definitionBtn sizeToFit];
    CGFloat definitionBtnW = self.definitionBtn.ny_width;
    CGFloat definitionBtnH = self.definitionBtn.ny_height;
    CGFloat definitionBtnX = self.rateBtn.ny_x - definitionBtnW - 14;
    CGFloat definitionBtnY = self.playOrPauseBtn.ny_y;
    if (self.rateBtn.hidden) {
        definitionBtnX = self.fullScreenBtn.ny_x - rateBtnW - 14;
    }
    self.definitionBtn.frame = CGRectMake(definitionBtnX, definitionBtnY, definitionBtnW, definitionBtnH);
    self.definitionBtn.ny_centerY = self.playOrPauseBtn.ny_centerY;
    
    [self.totalTimeLabel sizeToFit];
    CGFloat totalTimeLabelW = self.totalTimeLabel.ny_width;
    CGFloat totalTimeLabelH = self.totalTimeLabel.ny_height;
    CGFloat totalTimeLabelX = self.definitionBtn.ny_x - totalTimeLabelW - 14;
    self.totalTimeLabel.frame = CGRectMake(totalTimeLabelX, 0, totalTimeLabelW, totalTimeLabelH);
    self.totalTimeLabel.ny_centerY = self.playOrPauseBtn.ny_centerY;
    
    CGFloat sliderX = self.currentTimeLabel.ny_max_x + 8;
    CGFloat sliderY = 0;
    CGFloat sliderW = self.totalTimeLabel.ny_x - 8 - sliderX;
    CGFloat sliderH = self.playOrPauseBtn.ny_height;
    self.slider.frame = CGRectMake(sliderX, sliderY, sliderW, sliderH);
    self.slider.ny_centerY = self.playOrPauseBtn.ny_centerY;
    [super setFrame:frame];
}
-(UIButton *)playOrPauseBtn{
    if (!_playOrPauseBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [self addSubview:btn];
        _playOrPauseBtn = btn;
        [_playOrPauseBtn setImage:NYPlayer_Image(@"icVideoPlay") forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:NYPlayer_Image(@"icVideoPause") forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _playOrPauseBtn;
}
-(UIButton *)definitionBtn{
    if (!_definitionBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [self addSubview:btn];
        _definitionBtn = btn;
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
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
        _fullScreenBtn = btn;
        [btn setImage:NYPlayer_Image(@"ic_video_full") forState:UIControlStateNormal];
        [btn setImage:NYPlayer_Image(@"ic_video_full_off") forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenBtn;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        _currentTimeLabel = label;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
    
}
- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        _totalTimeLabel = label;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
    
}
- (UIButton *)rateBtn{
    if (!_rateBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [self addSubview:btn];
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
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
        _slider.sliderBtn.backgroundColor = [UIColor whiteColor];
        _slider.sliderBtn.layer.cornerRadius = 6;
        _slider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
        _slider.bufferTrackTintColor  = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _slider.minimumTrackTintColor = [UIColor whiteColor];
//        [_slider setThumbImage:ZFPlayer_Image(@"ZFPlayer_slider") forState:UIControlStateNormal];
        _slider.sliderHeight = 2;
    }
    return _slider;
}

#pragma mark - click
-(void)playBtnClick:(id)sender{
    if(self.playBtnClickBlock)self.playBtnClickBlock(self,self.playOrPauseBtn);
}
-(void)fullScreenBtnClick:(id)sender{
    if(self.fullScreenBtnBlock)self.fullScreenBtnBlock(self);
    [self setFrame:self.frame];
}
-(void)definitionBtnClick:(id)sender{
    if(self.definitionBtnClickBlock)self.definitionBtnClickBlock(self);
}
-(void)rateBtnClick:(id)sender{
    if(self.rateBtnClickBlock)self.rateBtnClickBlock(self);
    [self setFrame:self.frame];
}
/// 调节播放进度slider和当前时间更新
- (void)sliderValueChanged:(CGFloat)value currentTimeString:(NSString *)timeString {
    self.slider.value = value;
    self.currentTimeLabel.text = timeString;
    self.slider.isdragging = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.sliderBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
}

@end
