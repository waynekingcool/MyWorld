//
//  BookController.m
//  MyWorld
//
//  Created by wayneking on 2018/4/28.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "BookController.h"
#import "BookPageController.h"
//viewModel
#import "BookViewModel.h"

@interface BookController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property(nonatomic,strong) BookViewModel *viewModel;
@property(nonatomic,strong) UIPageViewController *pageViewController;   //翻页VC
@property(nonatomic,strong) BookPageController *pageController;
@end

@implementation BookController

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
    [self.view addSubview:self.pageViewController.view];
    [self addChildViewController:self.pageViewController];
    
}

//初始化viewModel的操作
- (void)initViewModel{
    //执行完后停止小菊花
    [self.viewModel.fetchContentCommand.executing subscribeNext:^(id x) {
        [CCProgressHUD hideHUDForView:self.view];
    }];
    
    
}

//绑定数据
- (void)bindData{
    //忽略空值,否则会执行两次
    @weakify(self);
    [[RACObserve(self.viewModel, model) ignore:nil] subscribeNext:^(BookModel *model) {
        @strongify(self);
        WBLog(@"加载完毕咯 %@",model);
        //设置容器
        self.pageController = [[BookPageController alloc]init];
        self.pageController.model = model;
        [self.pageViewController setViewControllers:@[[self createPageControllerWithChapter:0 page:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }];
}

//获取数据
- (void)loadData{
    [CCProgressHUD showMwssage:@"开始加载数据..." toView:self.view];
    [self.viewModel.fetchContentCommand execute:self.bookUrl];
}

#pragma mark - CreatePageController
- (BookPageController *)createPageControllerWithChapter:(NSInteger)chapter page:(NSInteger)page{
    self.pageController = [[BookPageController alloc]init];
    //根据页数获取内容
    self.pageController.content = [self.viewModel getContentWithChap:chapter Page:page];
    return self.pageController;
}

#pragma mark - UIPageViewControllerDelegate


#pragma mark - Getter And Setter
-(BookViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[BookViewModel alloc]init];
    }
    return _viewModel;
}

-(UIPageViewController *)pageViewController{
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
    }
    return _pageViewController;
}

@end
