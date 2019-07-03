//
//  NYVideoDetailVC.h
//  NYPlayerIJKPlayer
//
//  Created by 翟乃玉 on 2019/6/27.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYVideoDetailTransition.h"
NS_ASSUME_NONNULL_BEGIN
@class NYPlayerControllerView;
@interface NYVideoDetailVC : UIViewController
- (instancetype)initWithPlayerView:(NYPlayerControllerView *)playerView;
- (instancetype)init __attribute__((unavailable("请用- (instancetype)initWithPlayerView:(NYPlayerControllerView *)playerView 方法初始化")));
@property (nonatomic ,strong) NYVideoDetailTransition *transition;
@end

NS_ASSUME_NONNULL_END
