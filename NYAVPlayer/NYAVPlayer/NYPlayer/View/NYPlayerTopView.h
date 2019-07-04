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

@interface NYPlayerTopView : UIView
@property(nonatomic,copy)void(^backBtnClickBlock)(NYPlayerTopView *topView);
@property(nonatomic,copy)void(^smallBtnClickBlock)(NYPlayerTopView *topView);
@property(nonatomic,copy)void(^downloadBtnClickBlock)(NYPlayerTopView *topView);
@property(nonatomic, weak, readonly)UIButton *smallBtn;
@property(nonatomic, weak, readonly)UIButton *downloadBtn;
@end

NS_ASSUME_NONNULL_END
