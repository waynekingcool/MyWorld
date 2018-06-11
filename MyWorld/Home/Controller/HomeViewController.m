//
//  HomeViewController.m
//  MyWorld
//
//  Created by wayneking on 2018/4/27.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "HomeViewController.h"
#import "BookController.h"
//vender

//view
#import "HomeCell.h"
//model

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [WBUtil createTableView:self SeparatorStyle:(UITableViewCellSeparatorStyleNone) rowHeight:0 CellClass:[HomeCell class]];
    self.tableView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    [self.view addSubview:self.tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row == 1) {
        cell.articleLabel.text = @"紫川";
        cell.authorLabel.text = @"不知名";
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        BookController *vc = [[BookController alloc]init];
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"test"withExtension:@"txt"];
        vc.bookUrl = fileURL;
        vc.bookTitle = @"test";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        BookController *vc = [[BookController alloc]init];
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"紫川"withExtension:@"txt"];
        vc.bookUrl = fileURL;
        vc.bookTitle = @"紫川";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}



@end
