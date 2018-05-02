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

@property(nonatomic, assign) NSInteger currentPage; //当前页数
@property(nonatomic, assign) NSInteger currenChap;  //当前章节
@property(nonatomic, assign) NSInteger changeChap;  //将要变化的章节
@property(nonatomic, assign) NSInteger changePage;  //将要变化的页数

@property(nonatomic,strong) BookViewModel *viewModel;
@property(nonatomic,strong) UIPageViewController *pageViewController;   //翻页VC
@property(nonatomic,strong) BookPageController *pageController;

@property(nonatomic, assign) BOOL isTap;    //是否显示导航条
@end

@implementation BookController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currenChap = 0;
    self.currentPage = 0;
    
    //不显示导航条
    self.isTap = NO;
    
    //增加点击手势
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelf:)];
    [self.view addGestureRecognizer:tapGR];
    
    [self createUI];
    
    [self initViewModel];
    [self bindData];
    
    [self loadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
        [self.pageViewController setViewControllers:@[[self createPageControllerWithChapter:self.currenChap page:self.currentPage]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
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
//往前翻
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    self.changePage = self.currentPage;
    self.changeChap = self.currenChap;
    
    //第一章和第一页则不能继续往前翻
    if (self.changeChap == 0 && self.changePage ==0) {
        return nil;
    }
    
    if (self.changePage == 0) {
        self.changeChap--;
        BookChapModel *chapModel = self.viewModel.model.chapArray[self.changeChap];
        self.changePage = chapModel.pageCount-1;
    }else{
        self.changePage--;
    }
    
    return [self createPageControllerWithChapter:self.changeChap page:self.changePage];
}

//往后翻
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    self.changeChap = self.currenChap;
    self.changePage = self.currentPage;
    
    //最后一章的最后一页
    BookChapModel *model = self.viewModel.model.chapArray.lastObject;
    if (self.changePage == model.pageCount-1 && self.changeChap == self.viewModel.model.chapArray.count - 1) {
        return nil;
    }
    
    BookChapModel *tempModel = self.viewModel.model.chapArray[self.changeChap];
    if (self.changePage == tempModel.pageCount - 1) {
        //开始下一章的第一页
        self.changeChap++;
        self.changePage = 0;
    }else{
        self.changePage++;
    }
    
    return [self createPageControllerWithChapter:self.changeChap page:self.changePage];
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    //将要翻页时候执行该方法
    self.currentPage = self.changePage;
    self.currenChap = self.changeChap;
}

#pragma mark - ResponseEvent
- (void)tapSelf:(UITapGestureRecognizer *)sender{
    self.isTap = !self.isTap;
    if (self.isTap) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

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
        _pageViewController.view.frame = self.view.frame;
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
    }
    return _pageViewController;
}

@end
