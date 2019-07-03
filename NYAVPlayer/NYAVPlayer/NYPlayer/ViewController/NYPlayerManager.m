//
//  NYPlayerManager.m
//  NYAVPlayer
//
//  Created by 翟乃玉 on 2019/7/3.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import "NYPlayerManager.h"

@implementation NYPlayerManager
static NYPlayerManager *_shareInstance;
+ (instancetype)shareManager {
    if (!_shareInstance) {
        _shareInstance = [[NYPlayerManager alloc] init];
    }
    return _shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    if (!_shareInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareInstance = [super allocWithZone:zone];
        });
    }
    return _shareInstance;
}

-(void)setCurrentPlayerView:(NYPlayerControllerView *)currentPlayerView{
    if (_currentPlayerView.urlStr && ![_currentPlayerView.urlStr isEqualToString:currentPlayerView.urlStr]) {
        [_currentPlayerView stop];
    }
    _currentPlayerView = currentPlayerView;
}
@end
