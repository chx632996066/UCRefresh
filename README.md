# UCRefresh
仿UC头条下拉刷新效果

#USAGE
UCRefreshHeaderView *refreshHeaderView = [UCRefreshHeaderView headerWithRefreshingBlock:^{
        
        dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 2ull *NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            //执行操作
            NSLog(@"获取数据成功");
            [self.tableView.ucRefreshHeader endRefreshing];
        });
    }];
    
    self.tableView.ucRefreshHeader = refreshHeaderView;

TODO:刷新时动画尚未完成

![](https://github.com/chx632996066/UCRefresh/blob/master/UCRefreshView3/refresh.gif)



