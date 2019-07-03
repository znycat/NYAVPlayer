//
//  NYVideoCell.m
//  NYAVPlayer
//
//  Created by 翟乃玉 on 2019/7/3.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import "NYVideoCell.h"
#import "NYPlayerControllerView.h"
#import "NYVideoDetailVC.h"
@interface NYVideoCell ()

@end
@implementation NYVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)goDetail:(id)sender {
    NYVideoDetailVC *vc = [[NYVideoDetailVC alloc] initWithPlayerView:self.playerView];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
}
- (IBAction)play:(id)sender {
    self.videoImageV.userInteractionEnabled = YES;
    for (UIView *view in self.videoImageV.subviews) {
        [view removeFromSuperview];
    }
    NYPlayerControllerView *playerView = [[NYPlayerControllerView alloc] init];
    [self.videoImageV addSubview:playerView];
    self.playerView = playerView;
    playerView.frame = self.videoImageV.bounds;
    playerView.urlStr = self.urlStr;
}

-(void)setUrlStr:(NSString *)urlStr{
    if (![urlStr isEqualToString:urlStr]) {
        [self.playerView removeFromSuperview];
    }
    _urlStr = urlStr;
}
@end
