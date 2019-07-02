//
//  UIView+NYFrame.m
//  NYAVPlayer
//
//  Created by 翟乃玉 on 2019/7/1.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import "UIView+NYFrame.h"

@implementation UIView (NYFrame)
- (CGFloat)ny_x {
    return self.frame.origin.x;
}

- (void)setNy_x:(CGFloat)ny_x {
    CGRect newFrame   = self.frame;
    newFrame.origin.x = ny_x;
    self.frame        = newFrame;
}

- (CGFloat)ny_y {
    return self.frame.origin.y;
}

- (void)setNy_y:(CGFloat)ny_y {
    CGRect newFrame   = self.frame;
    newFrame.origin.y = ny_y;
    self.frame        = newFrame;
}

- (CGFloat)ny_width {
    return CGRectGetWidth(self.bounds);
}

- (void)setNy_width:(CGFloat)ny_width {
    CGRect newFrame     = self.frame;
    newFrame.size.width = ny_width;
    self.frame          = newFrame;
}

- (CGFloat)ny_height {
    return CGRectGetHeight(self.bounds);
}

- (void)setNy_height:(CGFloat)ny_height {
    CGRect newFrame      = self.frame;
    newFrame.size.height = ny_height;
    self.frame           = newFrame;
}

- (CGFloat)ny_top {
    return self.frame.origin.y;
}

- (void)setNy_top:(CGFloat)ny_top {
    CGRect newFrame   = self.frame;
    newFrame.origin.y = ny_top;
    self.frame        = newFrame;
}

- (CGFloat)ny_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setNy_bottom:(CGFloat)ny_bottom {
    CGRect newFrame   = self.frame;
    newFrame.origin.y = ny_bottom - self.frame.size.height;
    self.frame        = newFrame;
}

- (CGFloat)ny_left {
    return self.frame.origin.x;
}

- (void)setNy_left:(CGFloat)ny_left {
    CGRect newFrame   = self.frame;
    newFrame.origin.x = ny_left;
    self.frame        = newFrame;
}

- (CGFloat)ny_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setNy_right:(CGFloat)ny_right {
    CGRect newFrame   = self.frame;
    newFrame.origin.x = ny_right - self.frame.size.width;
    self.frame        = newFrame;
}

- (CGFloat)ny_centerX {
    return self.center.x;
}

- (void)setNy_centerX:(CGFloat)ny_centerX {
    CGPoint newCenter = self.center;
    newCenter.x       = ny_centerX;
    self.center       = newCenter;
}

- (CGFloat)ny_centerY {
    return self.center.y;
}

- (void)setNy_centerY:(CGFloat)ny_centerY {
    CGPoint newCenter = self.center;
    newCenter.y       = ny_centerY;
    self.center       = newCenter;
}

- (CGPoint)ny_origin {
    return self.frame.origin;
}

- (void)setNy_origin:(CGPoint)ny_origin {
    CGRect newFrame = self.frame;
    newFrame.origin = ny_origin;
    self.frame      = newFrame;
}

- (CGSize)ny_size {
    return self.frame.size;
}

- (void)setNy_size:(CGSize)ny_size {
    CGRect newFrame = self.frame;
    newFrame.size   = ny_size;
    self.frame      = newFrame;
}
- (CGFloat)ny_max_x {
    //    return self.ny_x + self.ny_width;
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)ny_max_y {
    //    return self.ny_y + self.ny_height;
    return CGRectGetMaxY(self.frame);
}

- (void)setNy_max_x:(CGFloat)ny_max_x {
    self.ny_x = ny_max_x - self.ny_width;
}

- (void)setNy_max_y:(CGFloat)ny_max_y {
    self.ny_y = ny_max_y - self.ny_height;
}
@end

