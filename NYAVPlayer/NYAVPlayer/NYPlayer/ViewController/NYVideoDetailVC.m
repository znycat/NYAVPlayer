//
//  NYVideoDetailVC.m
//  NYPlayerIJKPlayer
//
//  Created by 翟乃玉 on 2019/6/27.
//  Copyright © 2019 翟乃玉. All rights reserved.
//

#import "NYVideoDetailVC.h"
#import "NYPlayerControllerView.h"
@interface NYDetailCell : UICollectionViewCell
@property(nonatomic,copy)NSString *urlString;
@end
@implementation NYDetailCell
@end

@interface NYVideoDetailVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak)UICollectionView *collectionView;
@property(nonatomic, copy)NSString *firstUrlStr;

@property(nonatomic,strong)NSMutableArray *list;
@property(nonatomic, assign)BOOL playViewToCollectionView;
@end

@implementation NYVideoDetailVC
- (instancetype)initWithURLString:(NSString *)urlStr{
    self = [super init];
    if (self) {
        self.firstUrlStr = urlStr;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        self.transition = [[NYVideoDetailTransition alloc] init];
        self.transitioningDelegate = self.transition;
    }
    return self;
}
// 返回状态栏的样式
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
// 控制状态栏的现实与隐藏
- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor blackColor];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSMutableArray *list = [NSMutableArray array];
    NSArray *videoList = [rootDict objectForKey:@"list"];
    for (NSDictionary *dic in videoList) {
        [list addObject:dic[@"video_url"]];
    }
    self.list = list;
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.collectionView.frame = [UIScreen mainScreen].bounds;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NYDefinitionModel *model = [NYDefinitionModel new];
        model.title = @"标清";
        model.isSelected = YES;
        model.urlStr = @"http://tb-video.bdstatic.com/tieba-smallvideo/12_cc75b3fb04b8a23546d62e3f56619e85.mp4";
        NYDefinitionModel *model2 = [NYDefinitionModel new];
        model2.title = @"高清";
        model2.urlStr = @"http://tb-video.bdstatic.com/tieba-smallvideo/5_6d3243c354755b781f6cc80f60756ee5.mp4";
        NYSharePlayer.definitionModels = @[model, model2];
    });
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(UICollectionView *)collectionView{
    if (_collectionView) return _collectionView;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:NYDetailCell.class forCellWithReuseIdentifier:NSStringFromClass(self.class)];
    collectionView.pagingEnabled = YES;
    collectionView.bounces = NO;
    collectionView.scrollsToTop = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:collectionView];
    _collectionView = collectionView;
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.list.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NYDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.class) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    NSString *urlStr = self.list[indexPath.item];
    if (indexPath.section == 0) {
        urlStr = self.firstUrlStr;
    }
    cell.urlString = urlStr;
    return cell;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSArray *arr = [self.collectionView visibleCells];

    if (arr.count != 1) {
        NYLog(@"arr.count = %lu",(unsigned long)arr.count);
    }
    
    for (NYDetailCell *cell in arr) {
        CGRect frame = [cell.contentView convertRect:cell.contentView.bounds toView:nil];
        if (frame.origin.y > -50 && frame.origin.y < frame.size.height - 50) {
            [NYSharePlayer playWithURLStr:cell.urlString superView:cell.contentView isAutoPlay:YES];
            return;
        }
    }
    
}



-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.playViewToCollectionView && indexPath.section == 0) {
        [NYSharePlayer playWithURLStr:((NYDetailCell *)cell).urlString superView:cell.contentView isAutoPlay:YES nearestVC:self];
        self.playViewToCollectionView = YES;
    }
}

//cell结束显示
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
//    NYLog(@"didEndDisplayingCell %@",indexPath);
//    NSString *urlStr = self.list[indexPath.item];
//    if (indexPath == 0) {
//        urlStr = self.firstUrlStr;
//    }
//    //播放当前显示的视频
//    self.currentCellPlayerView.urlStr = urlStr;
}


@end
