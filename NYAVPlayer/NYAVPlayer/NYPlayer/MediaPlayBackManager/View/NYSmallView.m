//
//  NYSmallView.m
//  NYAVPlayer
//
//  Created by 翟乃玉 on 2019/7/3.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import "NYSmallView.h"
#import "NYPlayerView.h"
@interface NYSmallView()
@property(nonatomic, assign) UIEdgeInsets safeInsets;
@property(nonatomic, weak)UIView *closeBtn;
@end
@implementation NYSmallView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initilize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initilize];
    }
    return self;
}
-(void)setFrame:(CGRect)frame{
    CGFloat maxW = frame.size.width;
    //CGFloat maxH = frame.size.height;
    
    self.closeBtn.frame = CGRectMake(maxW - 40, 0, 40, 25);
    [super setFrame:frame];
}
- (void)initilize {
    [self closeBtn];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doMoveAction:)];
    [self addGestureRecognizer:panGestureRecognizer];
}

-(UIView *)closeBtn{
    if (!_closeBtn) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:btn];
        [btn setImage:NYPlayer_Image(@"ic_video_close") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn = btn;
    }
    return _closeBtn;
}
-(void)closeBtnClick:(id)sender{
    if(self.closeBtnClickBlock)self.closeBtnClickBlock(self);
}
#pragma mark - Action

- (void)doMoveAction:(UIPanGestureRecognizer *)recognizer {
    /// The position where the gesture is moving in the self.view.
    CGPoint translation = [recognizer translationInView:self.superview];
    CGPoint newCenter = CGPointMake(recognizer.view.center.x + translation.x,
                                    recognizer.view.center.y + translation.y);
    
    // Limited screen range:
    // Top margin limit.
    newCenter.y = MAX(recognizer.view.frame.size.height/2 + self.safeInsets.top, newCenter.y);
    
    // Bottom margin limit.
    newCenter.y = MIN(self.superview.frame.size.height - self.safeInsets.bottom - recognizer.view.frame.size.height/2, newCenter.y);
    
    // Left margin limit.
    newCenter.x = MAX(recognizer.view.frame.size.width/2, newCenter.x);
    
    // Right margin limit.
    newCenter.x = MIN(self.superview.frame.size.width - recognizer.view.frame.size.width/2,newCenter.x);
    
    // Set the center point.
    recognizer.view.center = newCenter;
    
    // Set the gesture coordinates to 0, otherwise it will add up.
    [recognizer setTranslation:CGPointZero inView:self.superview];
}


@end
