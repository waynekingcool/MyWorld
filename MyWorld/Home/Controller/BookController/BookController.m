//
//  BookController.m
//  MyWorld
//
//  Created by wayneking on 2018/4/28.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "BookController.h"
#import "BookPageController.h"
//vender
#import <LLSlideMenu/LLSlideMenu.h>
//viewModel
#import "BookViewModel.h"

@interface BookController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property(nonatomic, assign) NSInteger currentPage; //当前页数
@property(nonatomic, assign) NSInteger currenChap;  //当前章节
@property(nonatomic, assign) NSInteger changeChap;  //将要变化的章节
@property(nonatomic, assign) NSInteger changePage;  //将要变化的页数

@property(nonatomic,strong) BookViewModel *viewModel;
@property(nonatomic,strong) UIPageViewController *pageViewController;   //翻页VC
@property(nonatomic,strong) BookPageController *pageController;

@property(nonatomic, assign) BOOL isTap;    //是否显示导航条

@property(nonatomic,strong) LLSlideMenu *sideMenu;  //侧边栏 用来显示所有章节
@property(nonatomic,strong) UITableView *chapTableView; //显示所有章节
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
    tapGR.delegate = self;
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
    [self.view addSubview:self.sideMenu];
    
    //目录
    [self.rightButton setImage:[UIImage imageNamed:@"Icon-order"] forState:UIControlStateNormal];
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
        [self.chapTableView reloadData];
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

#pragma mark - TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.model.chapTitleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSString *title = self.viewModel.model.chapTitleArray[indexPath.row];
    cell.textLabel.text = title;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //关闭侧边栏
    [self.sideMenu ll_closeSlideMenu];
    //跳转到该章
    self.currenChap = indexPath.row;
    self.currentPage = 0;
    [self.pageViewController setViewControllers:@[[self createPageControllerWithChapter:self.currenChap page:self.currentPage]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

#pragma mark -  手势代理
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    //处理tableview和全局view手势冲突
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
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

//打开目录
-(void)rightButtonAction{
    if (self.sideMenu.ll_isOpen) {
        [self.sideMenu ll_closeSlideMenu];
    }else{
        [self.sideMenu ll_openSlideMenu];
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

-(LLSlideMenu *)sideMenu{
    if (!_sideMenu) {
        _sideMenu = [[LLSlideMenu alloc]init];
        _sideMenu.ll_menuWidth = 200.f; //宽度
        _sideMenu.ll_menuBackgroundColor = ProtectEyeColor; //背景色
        _sideMenu.ll_springDamping = 20;       // 阻力
        _sideMenu.ll_springVelocity = 15;      // 速度
        _sideMenu.ll_springFramesNum = 60;     // 关键帧数量
        [_sideMenu addSubview:self.chapTableView];
        self.chapTableView.frame = _sideMenu.bounds;
    }
    return _sideMenu;
}

-(UITableView *)chapTableView{
    if (!_chapTableView) {
        _chapTableView = [WBUtil createTableView:self SeparatorStyle:UITableViewCellSeparatorStyleSingleLine rowHeight:0 CellClass:[UITableViewCell class]];
    }
    return _chapTableView;
}

@end
