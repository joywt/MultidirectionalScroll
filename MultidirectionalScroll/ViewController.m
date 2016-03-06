//
//  ViewController.m
//  MultidirectionalScroll
//
//  Created by wangtie on 16/3/6.
//  Copyright © 2016年 wangtie. All rights reserved.
//

#import "ViewController.h"
#import "CustomView.h"
@interface ViewController () <UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,strong)CustomView *customView;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = self.customView;
        // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CustomView *)customView{
    if (!_customView){
        _customView = [[CustomView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [_customView setBackgroundColor:[UIColor whiteColor]];
    }
    return _customView;
}
@end
