//
//  ViewController.m
//  NYAVPlayer
//
//  Created by 翟乃玉 on 2019/6/28.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import "ViewController.h"
#import "NYVideoDetailVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)aaa:(id)sender {
    [self presentViewController:[NYVideoDetailVC new] animated:YES completion:nil];
}

@end
