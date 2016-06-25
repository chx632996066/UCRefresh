//
//  ViewController.m
//  UCRefresh2
//
//  Created by hongxi on 16/5/26.
//  Copyright (c) 2016 hongxi. All rights reserved.
//


#import "ViewController.h"
#import "UCRefreshView.h"


@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    __weak __typeof__(self) weakSelf = self;
    UCRefreshHeaderView *refreshHeaderView = [UCRefreshHeaderView headerWithRefreshingBlock:^{

        dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 2ull *NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            //执行操作
            NSLog(@"获取数据成功");
            [weakSelf.tableView.ucRefreshHeader endRefreshing];
        });
    }];

    self.tableView.ucRefreshHeader = refreshHeaderView;

}

-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 99;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


@end