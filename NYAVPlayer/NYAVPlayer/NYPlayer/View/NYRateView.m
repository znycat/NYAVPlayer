//
//  NYPlayerTopView.m
//  NYPlayerIJKPlayer
//
//  Created by 翟乃玉 on 2019/6/27.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import "NYRateView.h"
@interface NYRateView()
@property(nonatomic, strong)NSArray <UIButton *>*btns;
@property(nonatomic, weak)UIButton *selectedBtn;
@end
@implementation NYRateView

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
    [self btns];
}
#pragma mark - property
-(void)setFrame:(CGRect)frame{
    CGFloat maxW = frame.size.width;
    CGFloat maxH = frame.size.height;
    
    CGFloat btnH = maxH / self.btns.count;
    CGFloat btnW = maxW;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    for (int i = 0; i < self.btns.count; i++) {
        UIButton *btn = self.btns[i];
        btnY = btnH * i;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    
    [super setFrame:frame];
}
-(NSArray<UIButton *> *)btns{
    if (!_btns) {
        NSMutableArray *btns = [NSMutableArray array];
        NSArray *titles = @[@"0.5X",@"1.0X正常",@"1.25X",@"1.5X",@"2.0X"];
        for (NSString *title in titles) {
            UIButton *btn = [[UIButton alloc] init];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
            [btn setTitle:title forState:UIControlStateSelected];
            if ([title isEqualToString:@"1.0X正常"]) {
                btn.selected = YES;
                self.selectedBtn = btn;
            }
            [btn addTarget:self action:@selector(rateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [btns addObject:btn];
        }
        _btns = btns;
    }
    return _btns;
}

-(float)currentRate{
    return [self rateWithTitle:self.selectedBtn.titleLabel.text];
}
-(void)setCurrentRate:(float)currentRate{
    NSString *title = [self titleWithRate:currentRate];
    NYLog(@"rate - %f title == %@",currentRate,title);
    for (UIButton *btn in self.btns) {
        if ([btn.titleLabel.text isEqualToString:title]) {
            self.selectedBtn.selected = NO;
            btn.selected = YES;
            self.selectedBtn = btn;
            return;
        }
    }
}
#pragma mark - click
-(void)rateBtnClick:(UIButton *)sender{
    NSString *title = sender.titleLabel.text;
    float rate = [self rateWithTitle:title];
    if(self.rateBtnClickBlock)self.rateBtnClickBlock(self,sender,rate);
    
    self.selectedBtn.selected = NO;
    sender.selected = YES;
    self.selectedBtn = sender;
}

-(float)rateWithTitle:(NSString *)title{
    float rate = 1.0;
    if ([title isEqualToString:@"0.5X"]) {
        rate = 0.5;
    }else if([title isEqualToString:@"1.0X正常"]){
        rate = 1.0;
    }else if([title isEqualToString:@"1.25X"]){
        rate = 1.25;
    }else if([title isEqualToString:@"1.5X"]){
        rate = 1.5;
    }else if([title isEqualToString:@"2.0X"]){
        rate = 2.0;
    }
    return rate;
}

-(NSString *)titleWithRate:(float)rate{
    NSString *title = @"1.0X正常";
    if (rate == 0.5) {
        title = @"0.5X";
    }else if (rate == 1.0) {
        title = @"1.0X正常";
    }else if (rate == 1.25) {
        title = @"1.25X";
    }else if (rate == 1.5) {
        title = @"1.5X";
    }else if (rate == 2.0) {
        title = @"2.0X";
    }
    return title;
}

@end
