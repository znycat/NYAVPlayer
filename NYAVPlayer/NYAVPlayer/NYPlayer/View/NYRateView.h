//
//  NYPlayerTopView.h
//  NYPlayerIJKPlayer
//
//  Created by 翟乃玉 on 2019/6/27.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYPlayerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NYRateView : UIView
@property(nonatomic,assign)float currentRate;
@property(nonatomic,copy)void(^rateBtnClickBlock)(NYRateView *rateView,UIButton *btn,CGFloat rate);
@end

NS_ASSUME_NONNULL_END
