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

#pragma mark - 自定义高效率的 NSLog
#ifdef DEBUG
#define NYLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define NYLog(...)
#endif

NS_ASSUME_NONNULL_BEGIN

@interface NYPlayerControllerView : UIView
@property(nonatomic,copy)void(^topSmallBtnClickBlock)(NYPlayerControllerView *playerView,NYPlayerTopView *topView);
@property(nonatomic,copy)void(^topDownloadBtnClickBlock)(NYPlayerControllerView *playerView,NYPlayerTopView *topView);

@property(nonatomic,copy)NSString *urlStr;

@property(nonatomic,weak)UIViewController *detailVC;
@property(nonatomic,weak)UIViewController *fullScreenVC;
@end

NS_ASSUME_NONNULL_END
