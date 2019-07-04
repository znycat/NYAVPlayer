//
//  NYSmallView.h
//  NYAVPlayer
//
//  Created by 翟乃玉 on 2019/7/3.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, NYPlayerGestureType) {
    NYPlayerGestureTypeUnknown,
    NYPlayerGestureTypeSingleTap,
    NYPlayerGestureTypeDoubleTap,
    NYPlayerGestureTypePan,
    NYPlayerGestureTypePinch
};

typedef NS_ENUM(NSUInteger, NYPanDirection) {
    NYPanDirectionUnknown,
    NYPanDirectionV,
    NYPanDirectionH,
};

typedef NS_ENUM(NSUInteger, NYPanLocation) {
    NYPanLocationUnknown,
    NYPanLocationLeft,
    NYPanLocationRight,
};

typedef NS_ENUM(NSUInteger, NYPanMovingDirection) {
    NYPanMovingDirectionUnkown,
    NYPanMovingDirectionTop,
    NYPanMovingDirectionLeft,
    NYPanMovingDirectionBottom,
    NYPanMovingDirectionRight,
};

/// This enumeration lists some of the gesture types that the player has by default./// 禁用哪些手势，默认支持单击、双击、滑动、缩放手势
typedef NS_OPTIONS(NSUInteger, NYPlayerDisableGestureTypes) {
    NYPlayerDisableGestureTypesNone         = 0,
    NYPlayerDisableGestureTypesSingleTap    = 1 << 0,
    NYPlayerDisableGestureTypesDoubleTap    = 1 << 1,
    NYPlayerDisableGestureTypesPan          = 1 << 2,
    NYPlayerDisableGestureTypesPinch        = 1 << 3,
    NYPlayerDisableGestureTypesAll          = (NYPlayerDisableGestureTypesSingleTap | NYPlayerDisableGestureTypesDoubleTap | NYPlayerDisableGestureTypesPan | NYPlayerDisableGestureTypesPinch)
};

/// This enumeration lists some of the pan gesture moving direction that the player not support.///不支持的平移手势移动方向
typedef NS_OPTIONS(NSUInteger, NYPlayerDisablePanMovingDirection) {
    NYPlayerDisablePanMovingDirectionNone         = 0,       /// Not disable pan moving direction.
    NYPlayerDisablePanMovingDirectionVertical     = 1 << 0,  /// Disable pan moving vertical direction.
    NYPlayerDisablePanMovingDirectionHorizontal   = 1 << 1,  /// Disable pan moving horizontal direction.
    NYPlayerDisablePanMovingDirectionAll          = (NYPlayerDisablePanMovingDirectionVertical | NYPlayerDisablePanMovingDirectionHorizontal)  /// Disable pan moving all direction.
};

/// 手势的管理类
@interface NYPlayerGestureControl : NSObject

/// Gesture condition callback.
@property (nonatomic, copy, nullable) BOOL(^triggerCondition)(NYPlayerGestureControl *control, NYPlayerGestureType type, UIGestureRecognizer *gesture, UITouch *touch);

/// Single tap gesture callback.
@property (nonatomic, copy, nullable) void(^singleTapped)(NYPlayerGestureControl *control);

/// Double tap gesture callback.
@property (nonatomic, copy, nullable) void(^doubleTapped)(NYPlayerGestureControl *control);

/// Begin pan gesture callback.
@property (nonatomic, copy, nullable) void(^beganPan)(NYPlayerGestureControl *control, NYPanDirection direction, NYPanLocation location);

/// Pan gesture changing callback.
@property (nonatomic, copy, nullable) void(^changedPan)(NYPlayerGestureControl *control, NYPanDirection direction, NYPanLocation location, CGPoint velocity);

/// End the Pan gesture callback.
@property (nonatomic, copy, nullable) void(^endedPan)(NYPlayerGestureControl *control, NYPanDirection direction, NYPanLocation location);

/// Pinch gesture callback.
@property (nonatomic, copy, nullable) void(^pinched)(NYPlayerGestureControl *control, float scale);

/// The single tap gesture.
@property (nonatomic, strong, readonly) UITapGestureRecognizer *singleTap;

/// The double tap gesture.
@property (nonatomic, strong, readonly) UITapGestureRecognizer *doubleTap;

/// The pan tap gesture.
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGR;

/// The pinch tap gesture.
@property (nonatomic, strong, readonly) UIPinchGestureRecognizer *pinchGR;

/// The pan gesture direction.
@property (nonatomic, readonly) NYPanDirection panDirection;

@property (nonatomic, readonly) NYPanLocation panLocation;

@property (nonatomic, readonly) NYPanMovingDirection panMovingDirection;

/// The gesture types that the player not support.
@property (nonatomic) NYPlayerDisableGestureTypes disableTypes;

/// The pan gesture moving direction that the player not support.
@property (nonatomic) NYPlayerDisablePanMovingDirection disablePanMovingDirection;

/**
 Add gestures to the view.
 */
- (void)addGestureToView:(UIView *)view;

/**
 Remove gestures form the view.
 */
- (void)removeGestureToView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
