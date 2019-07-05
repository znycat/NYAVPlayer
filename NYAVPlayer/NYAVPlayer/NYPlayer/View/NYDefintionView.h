//
//  NYDefintionView.h
//  NYAVPlayer
//
//  Created by 翟乃玉 on 2019/7/5.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYDefinitionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NYDefintionView : UIView
@property (nonatomic,strong)NSArray <NYDefinitionModel *> *definitionModels;
@property (nonatomic,copy)void(^defintionBtnClickBlock)(NYDefintionView *defintionView,NYDefinitionModel *model);
@end

NS_ASSUME_NONNULL_END
