//
//  UIView+NYFrame.h
//  NYAVPlayer
//
//  Created by 翟乃玉 on 2019/7/1.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (NYFrame)

@property (nonatomic) CGFloat ny_x;
@property (nonatomic) CGFloat ny_y;
@property (nonatomic) CGFloat ny_width;
@property (nonatomic) CGFloat ny_height;

@property (nonatomic) CGFloat ny_top;
@property (nonatomic) CGFloat ny_bottom;
@property (nonatomic) CGFloat ny_left;
@property (nonatomic) CGFloat ny_right;

@property (nonatomic) CGFloat ny_centerX;
@property (nonatomic) CGFloat ny_centerY;

@property (nonatomic) CGPoint ny_origin;
@property (nonatomic) CGSize  ny_size;

@property (nonatomic, assign) CGFloat ny_max_x;
@property (nonatomic, assign) CGFloat ny_max_y;

@end

NS_ASSUME_NONNULL_END
