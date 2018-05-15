//
//  WebBookController.m
//  MyWorld
//
//  Created by wayneking on 2018/5/7.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "WebBookController.h"
#import "BookPageController.h"
//viewModel
#import "WebBookViewModel.h"

@interface WebBookController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property(nonatomic,strong) WebBookViewModel *viewModel;
@property(nonatomic,strong) UIPageViewController *pageViewController;
@property(nonatomic,strong) BookPageController *pageController;
///当前页码
@property(nonatomic,assign) NSInteger currentPage;
///改变的页码
@property(nonatomic, assign) NSInteger changePage;

@property(nonatomic, assign) BOOL isPre;
@property(nonatomic, assign) BOOL isNext;

@property(nonatomic, assign) BOOL isTap;    //是否显示导航条
@end

@implementation WebBookController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //禁用侧滑
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    
    self.currentPage = 0;
    self.changePage = 0;
    
    //不显示导航条
    self.isTap = NO;
    
    [self createUI];
    
    [self initViewModel];
    [self bindData];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setStatusBarBackgroundColor:ProtectEyeColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)createUI{
    [self.view addSubview:self.pageViewController.view];
    [self addChildViewController:self.pageViewController];
    
    //增加点击手势
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelf:)];
    [self.view addGestureRecognizer:tapGR];
}

- (void)loadData{
    [CCProgressHUD showMwssage:@"正在加载(*^__^*)" toView:self.view];
    [self.viewModel.fetchContentCommad execute:self.webUrl];
}

//根据链接跳转
- (void)loadDataWithUrl:(NSString *)urlStr{
    [CCProgressHUD showMwssage:@"正在加载(*^__^*)" toView:self.view];
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.viewModel.fetchContentCommad execute:url];
}

- (void)initViewModel{
    [self.viewModel.fetchContentCommad.executing subscribeNext:^(id x) {
        [CCProgressHUD hideHUDForView:self.view];
    }];
}

- (void)bindData{
    @weakify(self);
    [[RACObserve(self.viewModel, model) ignore:nil] subscribeNext:^(BookChapModel *model) {
        @strongify(self);
        WBLog(@"chapModel:%@",model);
        
        if (self.isPre) {
            self.changePage = self.viewModel.model.pageCount - 1;
            [self.pageViewController setViewControllers:@[[self createPageControllerWithContent:self.changePage]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        }else if(self.isNext){
            self.changePage = 0;
            self.currentPage = 0;
            [self.pageViewController setViewControllers:@[[self createPageControllerWithContent:self.changePage]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        }else{
            [self.pageViewController setViewControllers:@[[self createPageControllerWithContent:self.currentPage]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        }
        self.isPre = false;
        self.isNext = false;
    }];
}

#pragma mark - UIPageViewController
//往前翻
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    //第一章和第一页则不能继续往前翻
    if ([self.viewModel.model.pre isEqualToString:@"已经是第一章"] && self.changePage == 0) {
        [CCProgressHUD showMessageInAFlashWithMessage:@"已经是第一章"];
        return nil;
    }
    
    if (self.changePage == 0) {
        //上一章的最后一页
        self.isPre = true;
        [self loadDataWithUrl:self.viewModel.model.pre];
        return nil;
    }else{
        //下一页
        self.changePage--;
    }
    return [self createPageControllerWithContent:self.changePage];
}

//往后翻
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    self.changePage = self.currentPage;
    
    //最后一章的最后一页
    if (self.changePage == self.viewModel.model.pageCount-1 && [self.viewModel.model.next isEqualToString:@"最后一章"]) {
        [CCProgressHUD showMessageInAFlashWithMessage:@"已经是最后一章了"];
        return nil;
    }
    
    if (self.changePage == self.viewModel.model.pageCount - 1) {
        //开始下一章的第一页
        self.isNext = true;
        [self loadDataWithUrl:self.viewModel.model.next];
        return nil;
    }else{
        self.changePage++;
    }
    return [self createPageControllerWithContent:self.changePage];
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    //将要翻页时候执行该方法
    self.currentPage = self.changePage;
}

#pragma mark - Private Methods
- (BookPageController *)createPageControllerWithContent:(NSInteger)page{
    self.pageController = [[BookPageController alloc]init];
    self.pageController.content = [self.viewModel getContentWithPage:page];
    return self.pageController;
}

#pragma mark - ResponseEvent
- (void)tapSelf:(UITapGestureRecognizer *)sender{
    self.isTap = !self.isTap;
    if (self.isTap) {
        [self setStatusBarBackgroundColor:ProtectEyeColor];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        [self setStatusBarBackgroundColor:[UIColor whiteColor]];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

#pragma mark - Getter And Setter
-(WebBookViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[WebBookViewModel alloc]init];
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
