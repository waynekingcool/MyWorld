//
//  BookShelfController.m
//  MyWorld
//
//  Created by wayneking on 2018/5/8.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "BookShelfController.h"
#import "BookChapListController.h"
//cell
#import "BookIndexNoImgCell.h"

@interface BookShelfController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) WBNetWorkTool *tool;

@end

@implementation BookShelfController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI{
    self.leftButton.hidden = YES;
    
    self.tableView = [WBUtil createTableView:self SeparatorStyle:UITableViewCellSeparatorStyleNone rowHeight:0 CellClass:[BookIndexNoImgCell class]];
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, screenWidth, screenHeight-64-49);
}

#pragma mark - TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookIndexNoImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BookChapListController *vc = [[BookChapListController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - Getter And Setter
-(WBNetWorkTool *)tool{
    if (!_tool) {
        _tool = [[WBNetWorkTool alloc]init];
    }
    return _tool;
}

@end
