//
//  BookInfoController.m
//  MyWorld
//
//  Created by wayneking on 2018/5/5.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "BookInfoController.h"
#import "WebBookController.h"
//view
#import "BookInfoCell.h"
#import "BookInfoSectionView.h"
#import "BookInfoTableHeadView.h"
//viewModel
#import "BookInfoViewModel.h"

@interface BookInfoController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) BookInfoTableHeadView *headView;
@property(nonatomic,strong) BookInfoViewModel *viewModel;
@end

@implementation BookInfoController

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
    self.tableView.frame = CGRectMake(0, 0, screenWidth, screenHeight-64);
    self.tableView.tableHeaderView = self.headView;
    self.headView.frame = CGRectMake(0, 0, screenWidth, 200);
    
    @weakify(self);
    self.headView.startSubject = [RACSubject subject];
    [self.headView.startSubject subscribeNext:^(id x) {
        //开始阅读 从第一张开始阅读,如果已经有阅读记录,那么从记录开始阅读
        [self.viewModel getModelWIthSection:1 WithRow:0];
        WebBookController *vc = [[WebBookController alloc]init];
        vc.webUrl = [self.viewModel getChapUrlWithSection:1 WithRow:0];
        vc.recordTitle = self.title;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    self.headView.putSubject = [RACSubject subject];
    [self.headView.putSubject subscribeNext:^(id x) {
       //放入书架  也就是保存到本地数据库
    }];
    
    self.headView.shelfSubject = [RACSubject subject];
    [self.headView.shelfSubject subscribeNext:^(id x) {
       //我的书架
    }];
}

- (void)initViewModel{
    [self.viewModel.fetchDataCommadn.executing subscribeNext:^(NSNumber *x) {
        if (!x.boolValue) {
            [CCProgressHUD hideHUDForView:self.view];
        }
    } error:^(NSError *error) {
        [CCProgressHUD hideHUDForView:self.view];
        [CCProgressHUD showMessageInAFlashWithMessage:@"网络出错了"];
    }];
}

- (void)bindData{
    //刷新表格
    @weakify(self);
    [[[RACObserve(self.viewModel, allArray) ignore:nil] filter:^BOOL(NSMutableArray *array) {
        if (array.count == 0) {
            return NO;
        }
        return YES;
    }] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    //刷新头部view
    [[RACObserve(self.viewModel, model) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        self.headView.model = self.viewModel.model;
    }];
}

- (void)loadData{
    [CCProgressHUD showMwssage:@"正在加载,请稍等(*^__^*)" toView:self.view];
    [self.viewModel.fetchDataCommadn execute:self.path];
}

#pragma mark - TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel getChapCount:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = [self.viewModel getModelWIthSection:indexPath.section WithRow:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    BookInfoSectionView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headview"];
    if (section == 0) {
        view.sectionTitle = @"最新章节";
    }else{
        view.sectionTitle = @"全部章节";
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.viewModel getModelWIthSection:indexPath.section WithRow:indexPath.row];
    
    WebBookController *vc = [[WebBookController alloc]init];
    vc.webUrl = [self.viewModel getChapUrlWithSection:indexPath.section WithRow:indexPath.row];
    vc.recordTitle = self.title;
    vc.isChoseChap = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Getter And Setter
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [WBUtil createTableView:self SeparatorStyle:UITableViewCellSeparatorStyleNone rowHeight:0 CellClass:[BookInfoCell class]];
        [_tableView registerClass:[BookInfoSectionView class] forHeaderFooterViewReuseIdentifier:@"headview"];
    }
    return _tableView;
}

- (BookInfoTableHeadView *)headView{
    if (!_headView) {
        _headView = [[BookInfoTableHeadView alloc]init];
    }
    return _headView;
}

-(BookInfoViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[BookInfoViewModel alloc]init];
    }
    return _viewModel;
}

@end
