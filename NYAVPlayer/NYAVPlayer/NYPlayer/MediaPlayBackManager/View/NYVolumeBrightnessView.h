//
//  NYLoadingView.h
//  NYAVPlayer
//
//  Created by 翟乃玉 on 2019/7/2.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NYVolumeBrightnessType) {
    NYVolumeBrightnessTypeVolume,       // volume
    NYVolumeBrightnessTypeumeBrightness // brightness
};

@interface NYVolumeBrightnessView : UIView

@property (nonatomic, assign, readonly) NYVolumeBrightnessType volumeBrightnessType;
@property (nonatomic, strong, readonly) UIProgressView *progressView;
@property (nonatomic, strong, readonly) UIImageView *iconImageView;

- (void)updateProgress:(CGFloat)progress withVolumeBrightnessType:(NYVolumeBrightnessType)volumeBrightnessType;

/// 添加系统音量view
- (void)addSystemVolumeView;

/// 移除系统音量view
- (void)removeSystemVolumeView;

@end
