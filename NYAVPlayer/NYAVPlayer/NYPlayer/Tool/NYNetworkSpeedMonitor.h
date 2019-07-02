//
//  NYNetworkSpeedMonitor.h
//  NYAVPlayer
//
//  Created by 翟乃玉 on 2019/7/2.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *const NYDownloadNetworkSpeedNotificationKey;
extern NSString *const NYUploadNetworkSpeedNotificationKey;
extern NSString *const NYNetworkSpeedNotificationKey;

@interface NYNetworkSpeedMonitor : NSObject

@property (nonatomic, copy, readonly) NSString *downloadNetworkSpeed;
@property (nonatomic, copy, readonly) NSString *uploadNetworkSpeed;

- (void)startNetworkSpeedMonitor;
- (void)stopNetworkSpeedMonitor;

@end

