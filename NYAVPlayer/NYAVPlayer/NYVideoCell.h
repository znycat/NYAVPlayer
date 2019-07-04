//
//  NYVideoCell.h
//  NYAVPlayer
//
//  Created by 翟乃玉 on 2019/7/3.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NYPlayerControllerView;
NS_ASSUME_NONNULL_BEGIN

@interface NYVideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageV;
@property (nonatomic, copy)NSString *urlStr;
@end

NS_ASSUME_NONNULL_END
