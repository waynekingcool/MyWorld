//
//  BookIndexController.m
//  MyWorld
//
//  Created by wayneking on 2018/5/4.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "BookIndexController.h"
//view
#import "BookIndexImgCell.h"
#import "BookIndexNoImgCell.h"
#import "BookIndexSectionView.h"
//viewModel
#import "BookIndexViewModel.h"

@interface BookIndexController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) BookIndexViewModel *viewModel;
@end

@implementation BookIndexController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    [self initViewModel];
    [self bindData];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, screenWidth, screenHeight-49);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

//初始化viewModel的相关配置
- (void)initViewModel{
    
    [self.viewModel.fetchDataCommand.executing subscribeNext:^(NSNumber *x) {
        if (!x.boolValue) {
            //执行完了
            [CCProgressHUD hideHUDForView:self.view];
        }
    } error:^(NSError *error) {
        [CCProgressHUD hideHUDForView:self.view];
        [CCProgressHUD showMessageInAFlashWithMessage:@"网络出错了"];
    }];
    
}

//绑定数据
- (void)bindData{
    @weakify(self);
    //忽略nil并且当数组个数为0时也过滤掉
    [[[RACObserve(self.viewModel, dataArray) ignore:nil] filter:^BOOL(NSMutableArray *dataArray) {
        if (dataArray.count == 0) {
            return NO;
        }
        return YES;
    }] subscribeNext:^(NSMutableArray *dataArray) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

- (void)loadData{
    [CCProgressHUD showMwssage:@"正在加载,请稍等(*^__^*)" toView:self.view];
    [self.viewModel.fetchDataCommand execute:@0];
}

#pragma mark - TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel getCount:section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.viewModel getModelBySection:indexPath.section WithRow:indexPath.row];
    if (self.viewModel.isHot) {
        //热门
        BookIndexImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hot"];
        cell.model = self.viewModel.model;
        return cell;
    }else{
        BookIndexNoImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nothot"];
        cell.model = self.viewModel.model;
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.viewModel getModelBySection:indexPath.section WithRow:indexPath.row];
    if (self.viewModel.isHot) {
        return 120;
    }else{
        return 60;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Getter And Setter
-(BookIndexViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[BookIndexViewModel alloc]init];
    }
    return _viewModel;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [WBUtil createTableView:self SeparatorStyle:UITableViewCellSeparatorStyleNone rowHeight:80 CellClass:[UITableViewCell class]];
        [_tableView registerClass:[BookIndexNoImgCell class] forCellReuseIdentifier:@"nothot"];
        [_tableView registerClass:[BookIndexImgCell class] forCellReuseIdentifier:@"hot"];
    }
    return _tableView;
}



@end
