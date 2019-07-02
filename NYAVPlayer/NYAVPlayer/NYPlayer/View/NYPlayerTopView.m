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

    CGFloat btnW = 40;
    CGFloat btnH = btnW;
    self.backBtn.frame = CGRectMake(16, 0, btnW, btnH);
    self.smallBtn.frame = CGRectMake(maxW - btnW - 16, 0, btnW, btnH);
    self.downloadBtn.frame = self.smallBtn.frame;
    [super setFrame:frame];
}
-(UIButton *)backBtn{
    if (!_backBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [self addSubview:btn];
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn = btn;
    }
    return _backBtn;
}
-(UIButton *)smallBtn{
    if (!_smallBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [self addSubview:btn];
        [btn setTitle:@"小窗" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(smallBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _smallBtn = btn;
    }
    return _smallBtn;
}
-(UIButton *)downloadBtn{
    if (!_downloadBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [self addSubview:btn];
        [btn setTitle:@"下载" forState:UIControlStateNormal];
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
