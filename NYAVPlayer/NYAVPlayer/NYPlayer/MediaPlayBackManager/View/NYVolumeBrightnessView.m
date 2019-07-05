//
//  NYLoadingView.m
//  NYAVPlayer
//
//  Created by 翟乃玉 on 2019/7/2.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import "NYVolumeBrightnessView.h"
#import "NYPlayerView.h"
#import <MediaPlayer/MediaPlayer.h>
@interface NYVolumeBrightnessView ()

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, assign) NYVolumeBrightnessType volumeBrightnessType;
@property (nonatomic, strong) MPVolumeView *volumeView;

@end

@implementation NYVolumeBrightnessView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImageView];
        [self addSubview:self.progressView];
        [self hideTipView];
    }
    return self;
}

- (void)dealloc {
    [self addSystemVolumeView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.frame.size.width;
    CGFloat min_view_h = self.frame.size.height;
    CGFloat margin = 10;
    
    min_x = margin;
    min_w = 20;
    min_h = min_w;
    min_y = (min_view_h-min_h)/2;
    self.iconImageView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = CGRectGetMaxX(self.iconImageView.frame) + margin;
    min_h = 2;
    min_y = (min_view_h-min_h)/2;
    min_w = min_view_w - min_x - margin;
    self.progressView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    self.layer.cornerRadius = min_view_h/2;
    self.layer.masksToBounds = YES;
}

- (void)hideTipView {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

/// 添加系统音量view
- (void)addSystemVolumeView {
    [self.volumeView removeFromSuperview];
}

/// 移除系统音量view
- (void)removeSystemVolumeView {
    [[UIApplication sharedApplication].keyWindow addSubview:self.volumeView];
}

- (void)updateProgress:(CGFloat)progress withVolumeBrightnessType:(NYVolumeBrightnessType)volumeBrightnessType {
    if (progress >= 1) {
        progress = 1;
    } else if (progress <= 0) {
        progress = 0;
    }
    self.progressView.progress = progress;
    self.volumeBrightnessType = volumeBrightnessType;
    UIImage *playerImage = nil;
    if (volumeBrightnessType == NYVolumeBrightnessTypeVolume) {
        if (progress == 0) {
            playerImage = NYPlayer_Image(@"ic_video_volume");
        } else if (progress > 0 && progress < 0.5) {
            playerImage = NYPlayer_Image(@"ic_video_volume");
        } else {
            playerImage = NYPlayer_Image(@"ic_video_volume");
        }
    } else if (volumeBrightnessType == NYVolumeBrightnessTypeumeBrightness) {
        if (progress >= 0 && progress < 0.5) {
            playerImage = NYPlayer_Image(@"ic_video_light");
        } else {
            playerImage = NYPlayer_Image(@"ic_video_light");
        }
    }
    self.iconImageView.image = playerImage;
    self.hidden = NO;
    self.alpha = 1;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideTipView) object:nil];
    [self performSelector:@selector(hideTipView) withObject:nil afterDelay:1.5];
}

- (void)setVolumeBrightnessType:(NYVolumeBrightnessType)volumeBrightnessType {
    _volumeBrightnessType = volumeBrightnessType;
    if (volumeBrightnessType == NYVolumeBrightnessTypeVolume) {
        self.iconImageView.image = NYPlayer_Image(@"ic_video_volume");
    } else {
        self.iconImageView.image = NYPlayer_Image(@"ic_video_light");
    }
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
//        _progressView.progressTintColor = [UIColor whiteColor];
//        _progressView.trackTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];;
        _progressView.progressTintColor = NYColor(255, 170, 48);
        _progressView.trackTintColor = [UIColor whiteColor];;
    }
    return _progressView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    return _iconImageView;
}

- (MPVolumeView *)volumeView {
    if (!_volumeView) {
        _volumeView = [[MPVolumeView alloc] init];
        _volumeView.frame = CGRectMake(-1000, -1000, 100, 100);
    }
    return _volumeView;
}

@end
