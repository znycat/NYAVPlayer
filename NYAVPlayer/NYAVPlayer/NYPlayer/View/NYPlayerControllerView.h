//
//  NYPlayerControllerView.h
//  NYAVPlayer
//
//  Created by 翟乃玉 on 2019/7/1.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYPlayerTopView.h"
#import "NYPlayerBottomControllerView.h"
#import "NYVideoFullScreenVC.h"
#import "NYVideoDetailVC.h"

NS_ASSUME_NONNULL_BEGIN
/** NYPlayerControllerView 的tag*/
extern NSInteger const NYPlayerControllerViewTag;

typedef NS_ENUM(NSUInteger, NYPlayererViewStyle) {
    NYPlayererViewStyleNone,//此状态 无控制 只有站位图和播放状态显示
    NYPlayererViewStyleAnimating,//在动画中
    NYPlayererViewStyleFullScreen,//全屏状态
    NYPlayererViewStyleDetail,//竖屏 详情状态
    NYPlayererViewStyleSmall,//小窗状态
};

@interface NYPlayerControllerView : UIView
@property(nonatomic,copy)void(^topDownloadBtnClickBlock)(NYPlayerControllerView *playerView,NYPlayerTopView *topView);
@property(nonatomic,weak)NYVideoDetailVC *detailVC;
@property(nonatomic,weak)NYVideoFullScreenVC *fullScreenVC;

/// 底部播放进度
@property (nonatomic, weak, readonly) NYSliderView *bottomProgres;
@property(nonatomic,assign,readonly)NYPlayererViewStyle playerViewStyle;

@property (nonatomic, strong, readonly) id <NYPlayerMediaPlayback> currentManager;

+ (instancetype)sharePlayer;

/// 控制层自动隐藏的时间，默认2.5秒
@property (nonatomic, assign) NSTimeInterval autoHiddenTimeInterval;

/// 控制层显示、隐藏动画的时长，默认0.25秒
@property (nonatomic, assign) NSTimeInterval autoFadeTimeInterval;

-(void)playWithURLStr:(NSString *)urlStr superView:(UIView *)superView isAutoPlay:(BOOL)isAutoPlay;
-(void)playWithURLStr:(NSString *)urlStr superView:(UIView *)superView isAutoPlay:(BOOL)isAutoPlay nearestVC:(nullable UIViewController *)nearestVC;
@end

#pragma mark - 控制层的现实隐藏
@interface NYPlayerControllerView (NYControllerShowHidden)
/// 隐藏控制层
- (void)hideControlViewWithAnimated:(BOOL)animated;
/// 显示控制层
- (void)showControlViewWithAnimated:(BOOL)animated;
- (void)autoFadeOutControlView;
@end
#pragma mark - Notification
@interface NYPlayerControllerView (NYNotification)
-(void)addNotification;
-(void)removeNotification;
@end

NS_ASSUME_NONNULL_END
