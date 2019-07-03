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
#pragma mark - 自定义高效率的 NSLog
#ifdef DEBUG
#define NYLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define NYLog(...)
#endif

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, NYPlayererViewStyle) {
    NYPlayererViewStyleNone,//此状态 无控制 只有站位图和播放状态显示
    NYPlayererViewStyleAnimating,//在动画中
    NYPlayererViewStyleFullScreen,//全屏状态
    NYPlayererViewStyleDetail,//竖屏 详情状态
    NYPlayererViewStyleSmall,//小窗状态
};
@interface NYPlayerControllerView : UIView
@property(nonatomic,copy)void(^topDownloadBtnClickBlock)(NYPlayerControllerView *playerView,NYPlayerTopView *topView);

@property(nonatomic,copy)NSString *urlStr;

@property(nonatomic,weak)NYVideoDetailVC *detailVC;
@property(nonatomic,weak)NYVideoFullScreenVC *fullScreenVC;

@property(nonatomic,assign)NYPlayererViewStyle playerViewStyle;
@end

NS_ASSUME_NONNULL_END
