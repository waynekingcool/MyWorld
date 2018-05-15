//
//  BookChapListController.m
//  MyWorld
//
//  Created by wayneking on 2018/5/8.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "BookChapListController.h"
#import "WBDatabase.h"
#import "WBProgressView.h"
//cell
#import "BookChapListCell.h"
//model
#import "BookInfoChapModel.h"

@interface BookChapListController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) WBNetWorkTool *tool;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSMutableArray *selectArray;
@property(nonatomic,strong) NSMutableArray *downLoadArray;
@property(nonatomic,strong) WBProgressView *progressView;   //进度

@property(nonatomic, assign) NSInteger downCount;   //下载的总数
@property(nonatomic, assign) NSInteger finishCount; //已完成数
@end

@implementation BookChapListController

- (void)viewDidLoad {
    [super viewDidLoad];
    WBLog(@"DBPath: %@",DBPath);
    
    self.downCount = 0;
    self.finishCount = 0;
    
    [self createUI];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI{
    self.title = @"章节列表";
    
    [self.rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.rightButton2 setTitle:@"全选" forState:UIControlStateNormal];
    [self.rightButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.tableView = [WBUtil createTableView:self SeparatorStyle:UITableViewCellSeparatorStyleNone rowHeight:0 CellClass:[BookChapListCell class]];
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, screenWidth, screenHeight-64);
    
    [self.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(0);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(0);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(70);
    }];
}

- (void)loadData{
    //51_51880/
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"51_51880/" forKey:@"path"];
    
    [self.tool getDataWithAct:@"bookInfo" params:dic start:^{
        [CCProgressHUD showMwssage:@"正在加载所有章节(*^__^*)" toView:self.view];
    } fail:^(NSError *error) {
        [CCProgressHUD hideHUDForView:self.view];
        [CCProgressHUD showMessageInAFlashWithMessage:@"出错了╮(╯▽╰)╭"];
        
    } success:^(NSDictionary *data) {
        [CCProgressHUD hideHUDForView:self.view];
        
        //获取标题
        NSDictionary *info = data[@"bookInfo"];
        NSString *title = info[@"title"];
        self.title = title;
        
        //获取章节
        NSArray *array = data[@"allChap"];
        for (NSDictionary *dic in array) {
            BookInfoChapModel *model = [BookInfoChapModel mj_objectWithKeyValues:dic];
            [self.dataArray addObject:model];
            //暂时设置为未选中 从数据库中进行判断
            //判断是否已经存在内容
            NSString *sql = [NSString stringWithFormat:@"select count(*) from %@ where chapId = '%@'",self.title,model.chapId];
            BOOL isExist = [WBDatabase isExistWithSQL:sql WithTableName:self.title];
            if (isExist) {
                WBLog(@"在表: %@ 已经存在数据:%@",self.title,model.chapId);
                [self.selectArray addObject:@"1"];
                [self.downLoadArray addObject:@"1"];
            }else{
                [self.selectArray addObject:@"0"];
                [self.downLoadArray addObject:@"0"];
            }
            
        }
        //这里还需要和已经缓存过的章节进行比对
        [self.tableView reloadData];
    }];
}

-(void)rightButtonAction{
    WBLog(@"点击了保存");
    
    //遍历已选中的章节,统计总下载数
    for (int i = 0; i < self.selectArray.count; i++) {
        NSString *select = self.selectArray[i];
        NSString *down = self.downLoadArray[i];
        if (select.boolValue && !down.boolValue) {
            self.downCount += 1;
        }
    }
    
    //显示进度
    NSDictionary *dic = @{@"finish":[NSNumber numberWithInteger:self.finishCount] , @"all":[NSNumber numberWithInteger:self.downCount]};
    self.progressView.dataDic = dic;
    [self.progressView show];
    
    //遍历已选中的章节,进行保存
    for (int i = 0; i < self.selectArray.count; i++) {
        NSString *select = self.selectArray[i];
        NSString *down = self.downLoadArray[i];
        if (select.boolValue && !down.boolValue) {
            //保存
            BookInfoChapModel *model = self.dataArray[i];
            [self loadContent:model.chapUrl WithId:model.chapId];
        }else{
            //跳过
            
        }
    }
}

- (void)rightButtonAction2{
    [self.selectArray removeAllObjects];
    for (int i = 0 ; i < self.dataArray.count; i++) {
        [self.selectArray addObject:@"1"];
    }
    [self.tableView reloadData];
}

//获取章节内容
- (void)loadContent:(NSString *)path WithId:(NSString *)chapId{

    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:path forKey:@"path"];
    
    [self.tool getDataWithAct:@"chapContent" params:dic start:^{
        
    } fail:^(NSError *error) {
        
    } success:^(NSDictionary *data) {
        BookChapModel *model = [BookChapModel mj_objectWithKeyValues:data];
        model.chapId = chapId;
        [WBDatabase saveModel:model WithTitle:self.title];
        [self.downLoadArray replaceObjectAtIndex:[chapId integerValue]  withObject:@"1"];
        
        //更新状态
        self.finishCount += 1;
        NSDictionary *dic = @{@"finish":[NSNumber numberWithInteger:self.finishCount] , @"all":[NSNumber numberWithInteger:self.downCount]};
        self.progressView.dataDic = dic;
        if (self.finishCount == self.downCount) {
            //刷新
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookChapListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    BookInfoChapModel *model = self.dataArray[indexPath.row];
    NSString *selected = self.selectArray[indexPath.row];
    NSString *down = self.downLoadArray[indexPath.row];
    cell.title = model.chapTitle;
    cell.isSelect = selected.boolValue;
    cell.isDown = down.boolValue;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *select = self.selectArray[indexPath.row];
    if ([select isEqualToString:@"0"]) {
        select = @"1";
    }else{
        select = @"0";
    }
    
    NSString *down = self.downLoadArray[indexPath.row];
    if ([down isEqualToString:@"0"]) {
        
    }else{
        return;
    }
    
    //更新选中状态
    [self.selectArray replaceObjectAtIndex:indexPath.row withObject:select];
    BookChapListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.isSelect = select.boolValue;
}

#pragma mark - Getter And Setter
-(WBNetWorkTool *)tool{
    if (!_tool) {
        _tool = [[WBNetWorkTool alloc]init];
    }
    return _tool;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(NSMutableArray *)selectArray{
    if (!_selectArray) {
        _selectArray = [[NSMutableArray alloc]init];
    }
    return _selectArray;
}

-(NSMutableArray *)downLoadArray{
    if (!_downLoadArray) {
        _downLoadArray = [[NSMutableArray alloc]init];
    }
    return _downLoadArray;
}

-(WBProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[WBProgressView alloc]init];
    }
    return _progressView;
}

@end
