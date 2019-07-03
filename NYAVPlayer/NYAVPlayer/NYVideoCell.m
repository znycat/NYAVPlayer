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
#import "NYPlayerManager.h"
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
    self.playerView.urlStr = self.urlStr;
    [NYPlayerManager shareManager].currentPlayerView = self.playerView;
    NYVideoDetailVC *vc = [[NYVideoDetailVC alloc] initWithPlayerView:self.playerView];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
}
- (IBAction)play:(id)sender {
    self.videoImageV.userInteractionEnabled = YES;
    self.playerView.urlStr = self.urlStr;
    [NYPlayerManager shareManager].currentPlayerView = self.playerView;
}

-(NYPlayerControllerView *)playerView{
    if (!_playerView) {
        NYPlayerControllerView *playerView = [[NYPlayerControllerView alloc] init];
        [self.videoImageV addSubview:playerView];
        _playerView = playerView;
        playerView.frame = self.videoImageV.bounds;
    }
    return _playerView;
}
-(void)setUrlStr:(NSString *)urlStr{
    if (![urlStr isEqualToString:urlStr]) {
        [self.playerView removeFromSuperview];
    }
    _urlStr = urlStr;
}
@end
