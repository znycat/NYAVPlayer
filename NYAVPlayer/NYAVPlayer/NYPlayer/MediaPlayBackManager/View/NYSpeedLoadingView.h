//
//  NYSpeedLoadingView.h
//  NYAVPlayer
//
//  Created by 翟乃玉 on 2019/7/2.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYLoadingView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NYSpeedLoadingView : UIView

@property (nonatomic, strong) NYLoadingView *loadingView;

@property (nonatomic, strong) UILabel *speedTextLabel;

/**
 *  Starts animation of the spinner.
 */
- (void)startAnimating;

/**
 *  Stops animation of the spinnner.
 */
- (void)stopAnimating;
@end

NS_ASSUME_NONNULL_END
