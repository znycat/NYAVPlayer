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

-(void)dealloc{
    NSLog(@"cell delloc");
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)goDetail:(id)sender {
    
//    [NYSharePlayer playWithURLStr:self.urlStr superView:self.videoImageV isAutoPlay:YES playerViewStyle:NYPlayererViewStyleNone];

}
- (IBAction)play:(id)sender {
    self.videoImageV.userInteractionEnabled = YES;
    [NYSharePlayer playWithURLStr:self.urlStr superView:self.videoImageV isAutoPlay:YES];
}
-(void)setUrlStr:(NSString *)urlStr{
    _urlStr = urlStr;
    for (UIView *view in self.videoImageV.subviews) {
        [view removeFromSuperview];
    }
}

@end
