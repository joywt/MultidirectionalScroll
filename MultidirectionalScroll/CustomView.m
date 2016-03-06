//
//  CustomView.m
//  MultidirectionalScroll
//
//  Created by wangtie on 16/3/6.
//  Copyright © 2016年 wangtie. All rights reserved.
//

#import "CustomView.h"

@interface CustomView () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIScrollView *landscapeScrollView;
@property (nonatomic,strong)NSMutableArray *scrollViewSource;
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,assign)NSInteger currentIndex;
@end
@implementation CustomView
#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.landscapeScrollView];
        [self addSubview:self.topView];
        for ( int i = 0; i<6; i++) {
            UITableView *view = [[UITableView alloc] initWithFrame:CGRectMake(i * SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT)];
            [view setBackgroundColor:[self randowColor]];
            [view setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 200)]];
            [view registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Hello"];
            [view setDelegate:self];
            [view setDataSource:self];
            [self.landscapeScrollView addSubview:view];
            [self.scrollViewSource addObject:view];
        }
        self.currentIndex = 0;

    }
    return self;
}

#pragma mark - target action
- (void)touchMe:(id)sender{
    NSLog(@"你点我了，谢谢！");
}

#pragma mark - private method
- (UIColor *)randowColor{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Hello" forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setText:[NSString stringWithFormat:@"Row %ld",(long)indexPath.row]];
    return cell;
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0) {
    if (scrollView== self.landscapeScrollView) {
        NSInteger index = targetContentOffset->x/SCREENWIDTH;
        self.currentIndex = index;
        UITableView *view = self.scrollViewSource[index];
        CGFloat topViewY = self.topView.frame.origin.y;
        if (-topViewY <=200){
             [view setContentOffset:CGPointMake(0, -topViewY) animated:NO];
        }
       
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float y = scrollView.contentOffset.y;
    if (y>0) {
        if (y>200) {
            y = 200;
        }
        [self.topView setTransform:CGAffineTransformMakeTranslation(0, -y)];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float y = scrollView.contentOffset.y;
    if (y>0) {
        if (y>200) {
            y = 200;
        }
        [self.topView setTransform:CGAffineTransformMakeTranslation(0, -y)];
    }
}

#pragma mark - getter & setter

- (UIScrollView *)landscapeScrollView{
    if (!_landscapeScrollView) {
        _landscapeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [_landscapeScrollView setDelegate:self];
        [_landscapeScrollView setPagingEnabled:YES];
        [_landscapeScrollView setContentSize:CGSizeMake(SCREENWIDTH*6, SCREENHEIGHT)];
    }
    return _landscapeScrollView;
}

- (NSMutableArray *)scrollViewSource{
    if (!_scrollViewSource) {
        _scrollViewSource = [[NSMutableArray alloc] initWithCapacity:6];
    }
    return _scrollViewSource;
}

-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 200)];
        [_topView setBackgroundColor:[UIColor whiteColor]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, SCREENWIDTH, 40)];
        [label setText:@"我是头部视图"];
        [label setTextAlignment:NSTextAlignmentCenter];
        [_topView addSubview:label];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((SCREENWIDTH - 100)/2 , 120, 100, 50)];
        [button setTitle:@"点我" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(touchMe:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:button];
        
    }
    return _topView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    NSLog(@"view ...%@",view);
    if (view==self.topView){
        return self.scrollViewSource[self.currentIndex];
    }
    return view;
}
@end
