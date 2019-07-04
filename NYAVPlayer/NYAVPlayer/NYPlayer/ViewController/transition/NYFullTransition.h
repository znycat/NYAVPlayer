//
//  NYFullTransition.h
//  NYAVPlayer
//
//  Created by 翟乃玉 on 2019/7/3.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NYFullTransition : NSObject<UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>
- (instancetype)initWithIsLeft:(BOOL)isLeft;
- (instancetype)init __attribute__((unavailable("请用- - (instancetype)initWithIsLeft:(BOOL)isLeft; 方法初始化")));
@end

NS_ASSUME_NONNULL_END
