//
//  NYVideoFullScreenVC.h
//  NYPlayerIJKPlayer
//
//  Created by 翟乃玉 on 2019/6/27.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYFullTransition.h"
NS_ASSUME_NONNULL_BEGIN

@interface NYVideoFullScreenVC : UIViewController
- (instancetype)initWithIsLeft:(BOOL)isLeft;
- (instancetype)init __attribute__((unavailable("请用- - (instancetype)initWithIsLeft:(BOOL)isLeft; 方法初始化")));
@property (nonatomic ,strong) NYFullTransition *transition;
@end

NS_ASSUME_NONNULL_END
