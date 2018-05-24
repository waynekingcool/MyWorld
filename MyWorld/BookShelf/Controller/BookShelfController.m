//
//  BookShelfController.m
//  MyWorld
//
//  Created by wayneking on 2018/5/8.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "BookShelfController.h"
#import "BookChapListController.h"
#import "WBDatabase.h"
#import "WebBookController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
//cell
#import "BookIndexNoImgCell.h"
#import "BookShelfCell.h"

@interface BookShelfController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) WBNetWorkTool *tool;
@property(nonatomic,strong) NSArray *dataArray;

@end

@implementation BookShelfController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI{
    self.leftButton.hidden = YES;
    
    self.tableView = [WBUtil createTableView:self SeparatorStyle:UITableViewCellSeparatorStyleNone rowHeight:120 CellClass:[BookShelfCell class]];
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, screenWidth, screenHeight-64-49);
    
    @weakify(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self_weak_ loadData];
        [self_weak_.tableView.mj_header endRefreshing];
    }];
}

- (void)loadData{
    //从本地加载数据
    self.dataArray = [WBDatabase loadBookToShelf];
    if (self.dataArray.count > 0) {
        [self.tableView reloadData];
    }
}

#pragma mark - TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookToShelfModel *model = self.dataArray[indexPath.row];
    BookShelfCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BookToShelfModel *model = self.dataArray[indexPath.row];
    WebBookController *vc = [[WebBookController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.recordTitle = model.title;
    vc.webUrl = [NSURL URLWithString:model.url];
    [self.navigationController pushViewController:vc animated:YES];
    
//    BookChapListController *vc = [[BookChapListController alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Getter And Setter
-(WBNetWorkTool *)tool{
    if (!_tool) {
        _tool = [[WBNetWorkTool alloc]init];
    }
    return _tool;
}

@end
