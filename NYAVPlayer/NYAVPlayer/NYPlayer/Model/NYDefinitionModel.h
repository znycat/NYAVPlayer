//
//  NYDefinitionModel.h
//  NYAVPlayer
//
//  Created by 翟乃玉 on 2019/7/5.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYDefinitionModel : NSObject
@property(nonatomic, copy)NSString *urlStr;
@property(nonatomic, copy)NSString *title;
@property(nonatomic, assign)BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
