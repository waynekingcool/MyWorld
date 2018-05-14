//
//  BookChapListController.m
//  MyWorld
//
//  Created by wayneking on 2018/5/8.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "BookChapListController.h"
#import "WBDatabase.h"
//cell
#import "BookChapListCell.h"
//model
#import "BookInfoChapModel.h"

@interface BookChapListController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) WBNetWorkTool *tool;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSMutableArray *selectArray;

@end

@implementation BookChapListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    self.tableView = [WBUtil createTableView:self SeparatorStyle:UITableViewCellSeparatorStyleNone rowHeight:0 CellClass:[BookChapListCell class]];
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, screenWidth, screenHeight-64);
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
            //暂时设置为未选中
            [self.selectArray addObject:@"0"];
        }
        //这里还需要和已经缓存过的章节进行比对
        [self.tableView reloadData];
    }];
}

-(void)rightButtonAction{
    WBLog(@"点击了保存");
    //遍历已选中的章节,进行保存
    for (int i = 0; i < self.selectArray.count; i++) {
        NSString *select = self.selectArray[i];
        if (select.boolValue) {
            //保存
            BookInfoChapModel *model = self.dataArray[i];
            [self loadContent:model.chapUrl WithId:model.chapId];
        }else{
            //跳过
        }
    }
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
    cell.title = model.chapTitle;
    cell.isSelect = selected.boolValue;
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

@end
