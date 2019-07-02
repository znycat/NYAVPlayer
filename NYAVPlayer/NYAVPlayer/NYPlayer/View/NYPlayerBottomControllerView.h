//
//  NYPlayerBottomControllerView.h
//  NYPlayerIJKPlayer
//
//  Created by 翟乃玉 on 2019/6/27.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYSliderView.h"
#import "NYPlayerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NYPlayerBottomControllerView : UIView
@property(nonatomic,copy)void(^playBtnClickBlock)(NYPlayerBottomControllerView *bottomView,UIButton *playOrPauseBtn);
@property(nonatomic,copy)void(^fullScreenBtnBlock)(NYPlayerBottomControllerView *bottomView);
@property(nonatomic,copy)void(^definitionBtnClickBlock)(NYPlayerBottomControllerView *bottomView);
@property(nonatomic,copy)void(^rateBtnClickBlock)(NYPlayerBottomControllerView *bottomView);

@property (nonatomic, weak) id <NYPlayerMediaPlayback> currentManager;
/// 播放还是暂停按钮
@property(nonatomic, weak, readonly)UIButton *playOrPauseBtn;
/** 清晰度按钮*/
@property(nonatomic, weak, readonly)UIButton *definitionBtn;
/** 倍速按钮*/
@property(nonatomic, weak, readonly)UIButton *rateBtn;
/** 全屏按钮*/
@property(nonatomic, weak, readonly)UIButton *fullScreenBtn;
/** 时间进度label 1:03/3:33*/
@property(nonatomic, weak, readonly)UILabel *timeProgressLabel;
/// 滑杆
@property (nonatomic, weak, readonly) NYSliderView *slider;
/// 底部播放进度
@property (nonatomic, weak, readonly) NYSliderView *bottomPgrogress;
@end

NS_ASSUME_NONNULL_END
