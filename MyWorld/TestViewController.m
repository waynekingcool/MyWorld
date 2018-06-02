//
//  TestViewController.m
//  MyWorld
//
//  Created by wayneking on 2018/6/1.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "TestViewController.h"
#import "WBHeaderRefresh.h"

#import "FBShimmeringView.h"

@interface TestViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) FBShimmeringView *shimmeringView;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    
//    self.shimmeringView = [[FBShimmeringView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
//    [self.view addSubview:self.shimmeringView];
//    
//    UILabel *label = [[UILabel alloc]init];
//    label.layer.cornerRadius = 20;
//    label.layer.masksToBounds = YES;
//    label.text = @"妈妈应用";
//    label.frame = self.shimmeringView.bounds;
//    label.font =  [UIFont systemFontOfSize:20 weight:5];
//    label.textColor = [UIColor whiteColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.numberOfLines = 0;
//    label.backgroundColor = [WBUtil createHexColor:@"#FF606E"];
//    self.shimmeringView.contentView = label;
//    self.shimmeringView.shimmering = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI{
    self.tableView = [WBUtil createTableView:self SeparatorStyle:UITableViewCellSeparatorStyleNone rowHeight:0 CellClass:[UITableViewCell class]];
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, screenWidth, screenHeight-64);
    
    self.tableView.mj_header = [WBHeaderRefresh headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

@end
