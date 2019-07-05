//
//  NYPlayerTopView.m
//  NYPlayerIJKPlayer
//
//  Created by 翟乃玉 on 2019/6/27.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import "NYPlayerTopView.h"
@interface NYPlayerTopView()
@property(nonatomic, weak)UIButton *backBtn;
@property(nonatomic, weak)UIButton *smallBtn;
@property(nonatomic, weak)UIButton *downloadBtn;
@end
@implementation NYPlayerTopView

#pragma mark - cycle
- (void)dealloc{
    NSLog(@"delloc");
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    [self backBtn];
    [self smallBtn];
    [self downloadBtn];
}
#pragma mark - property
-(void)setFrame:(CGRect)frame{
    CGFloat maxW = frame.size.width;
//    CGFloat maxH = frame.size.height;

    CGFloat temp = 13;
    
    CGFloat btnW = 24 + temp * 2;
    CGFloat btnH = btnW;
    self.backBtn.frame = CGRectMake(16 - temp, 24 -temp, btnW, btnH);
    self.smallBtn.frame = CGRectMake(maxW - btnW - 16 - 13, self.backBtn.ny_y, btnW, btnH);
    self.downloadBtn.frame = self.smallBtn.frame;
    [super setFrame:frame];
}
-(UIButton *)backBtn{
    if (!_backBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [self addSubview:btn];
        [btn setImage:NYPlayer_Image(@"ic_preview_back") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn = btn;
    }
    return _backBtn;
}
-(UIButton *)smallBtn{
    if (!_smallBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [self addSubview:btn];
        [btn setImage:NYPlayer_Image(@"ic_video_suspension") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(smallBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _smallBtn = btn;
    }
    return _smallBtn;
}
-(UIButton *)downloadBtn{
    if (!_downloadBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [self addSubview:btn];
        [btn setImage:NYPlayer_Image(@"ic_video_download") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(downloadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _downloadBtn = btn;
    }
    return _downloadBtn;
}
#pragma mark - click
-(void)backBtnClick:(id)sender{
    if(self.backBtnClickBlock)self.backBtnClickBlock(self);
}
-(void)smallBtnClick:(id)sender{
    if(self.smallBtnClickBlock)self.smallBtnClickBlock(self);
}
-(void)downloadBtnClick:(id)sender{
    if(self.downloadBtnClickBlock)self.downloadBtnClickBlock(self);
}
@end
