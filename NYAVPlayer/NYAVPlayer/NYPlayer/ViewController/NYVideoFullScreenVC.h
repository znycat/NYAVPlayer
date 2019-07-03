//
//  NYVideoFullScreenVC.h
//  NYPlayerIJKPlayer
//
//  Created by 翟乃玉 on 2019/6/27.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYFullTransition.h"
@class NYPlayerControllerView;
NS_ASSUME_NONNULL_BEGIN

@interface NYVideoFullScreenVC : UIViewController
- (instancetype)initWithPlayerView:(NYPlayerControllerView *)playerView isLeft:(BOOL)isLeft;
- (instancetype)init __attribute__((unavailable("请用- (instancetype)initWithPlayerView:(NYPlayerControllerView *)playerView isLeft:(BOOL)isLeft 方法初始化")));
@property (nonatomic ,strong) NYFullTransition *transition;
@end

NS_ASSUME_NONNULL_END
