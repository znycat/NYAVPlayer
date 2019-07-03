//
//  NYPlayerManager.h
//  NYAVPlayer
//
//  Created by 翟乃玉 on 2019/7/3.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NYPlayerControllerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NYPlayerManager : NSObject
+ (instancetype)shareManager;
@property(nonatomic, weak)NYPlayerControllerView *currentPlayerView;
@end

NS_ASSUME_NONNULL_END
