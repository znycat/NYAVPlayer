//
//  NYDefintionView.m
//  NYAVPlayer
//
//  Created by 翟乃玉 on 2019/7/5.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import "NYDefintionView.h"
@interface NYDefintionView()
@property(nonatomic, strong)NSMutableArray <UIButton *>*btns;
@property(nonatomic, weak)UIButton *selectedBtn;
@end
@implementation NYDefintionView

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
-(NSMutableArray<UIButton *> *)btns{
    if (!_btns) {
        NSMutableArray *btns = [NSMutableArray array];
        _btns = btns;
    }
    return _btns;
}

- (void)setDefinitionModels:(NSArray<NYDefinitionModel *> *)definitionModels{
    _definitionModels = definitionModels;
    for (UIButton *btn in self.btns) {
        [btn removeFromSuperview];
    }
    [self.btns removeAllObjects];
    
    for (int i = 0; i < definitionModels.count; i++) {
        NYDefinitionModel *model = definitionModels[i];
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:model.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [btn setTitle:model.title forState:UIControlStateSelected];
        if (model.isSelected) {
            btn.selected = YES;
            self.selectedBtn = btn;
        }
        btn.tag = i;
        [btn addTarget:self action:@selector(defintionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.btns addObject:btn];
    }
}
#pragma mark - click
-(void)defintionBtnClick:(UIButton *)sender{
    NYDefinitionModel *model = self.definitionModels[sender.tag];
    if(self.defintionBtnClickBlock)self.defintionBtnClickBlock(self,model);
    self.selectedBtn.selected = NO;
    sender.selected = YES;
    self.selectedBtn = sender;
}


@end
