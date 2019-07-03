//
//  NYSmallView.h
//  NYAVPlayer
//
//  Created by 翟乃玉 on 2019/7/3.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSmallView : UIView
@property(nonatomic,copy)void(^closeBtnClickBlock)(NYSmallView *smallView);
@end

NS_ASSUME_NONNULL_END
