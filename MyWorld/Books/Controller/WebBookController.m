//
//  WebBookController.m
//  MyWorld
//
//  Created by wayneking on 2018/5/7.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "WebBookController.h"
#import "BookPageController.h"
#import "WBDatabase.h"
#import "WebBookToolView.h"
#import "BookChapListController.h"
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
@property(nonatomic, assign) BOOL loadRecord;

@property(nonatomic, assign) BOOL isTap;    //是否显示导航条
@property(nonatomic,strong) WebBookToolView *toolView;  //工具条

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
    self.loadRecord = NO;
    
    [self createUI];
    
    [self initViewModel];
    [self bindData];
    
    //如果是选择某章节
    if (self.isChoseChap) {
        [self loadDataWithUrl:[self.webUrl absoluteString]];
        return;
    }
    
    //判断是否有记录
    if ([self isHasRecord]) {
        //有记录则从缓存中获取数据
        if (![self getRecordData]) {
            //内容为空则从网络获取数据
            [self loadData];
        }
    }else{
        //无记录则从网络获取数据
        [self loadData];
    }
    
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
    
    [self.toolView removeFromSuperview];
}

- (void)createUI{
    [self.view addSubview:self.pageViewController.view];
    [self addChildViewController:self.pageViewController];
    
    //增加点击手势
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelf:)];
    [self.view addGestureRecognizer:tapGR];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.toolView];
    self.toolView.downSubject = [RACSubject subject];
    //预缓存章节
    @weakify(self);
    [self.toolView.downSubject subscribeNext:^(id x) {
        //取书籍path
        NSArray *tempArray = [[self_weak_.webUrl absoluteString] componentsSeparatedByString:@"/"];
        BookChapListController *vc = [[BookChapListController alloc]init];
        NSString *path = tempArray[3];
        vc.bookPath = [NSString stringWithFormat:@"%@/",path];
        [self_weak_.navigationController pushViewController:vc animated:YES];
    }];
    self.toolView.frame = CGRectMake(0, screenHeight, screenWidth, 50);
}

- (void)loadData{
    [CCProgressHUD showMwssage:@"正在加载(*^__^*)" toView:self.view];
    [self.viewModel.fetchContentCommad execute:self.webUrl];
}

//根据链接跳转
- (void)loadDataWithUrl:(NSString *)urlStr{
    //加载前判断是否有缓存数据
    if ([self isHasRecord]) {
        //有记录则从缓存中获取数据
        if ( [self getRecordDataWithUrl:urlStr]) {
            //有内容
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
            WBLog(@"加载了缓存数据");
            return ;
        }else{
            //无内容  从网络获取
            [CCProgressHUD showMwssage:@"正在加载(*^__^*)" toView:self.view];
            NSURL *url = [NSURL URLWithString:urlStr];
            [self.viewModel.fetchContentCommad execute:url];
            return;
        }
    }
    
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
        
        //如果缓存存在
        if (self.viewModel.recordModel) {
            self.changePage = [self.viewModel.recordModel.recordPage integerValue];
        }
        
        if (self.isPre) {
            self.changePage = self.viewModel.model.pageCount - 1;
            [self.pageViewController setViewControllers:@[[self createPageControllerWithContent:self.changePage]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        }else if(self.isNext){
            self.changePage = 0;
            self.currentPage = 0;
            [self.pageViewController setViewControllers:@[[self createPageControllerWithContent:self.changePage]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        }else{
            [self.pageViewController setViewControllers:@[[self createPageControllerWithContent:self.changePage]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        }
        self.isPre = false;
        self.isNext = false;
        //更新章节名称
        self.title = model.chapTitle;
        
        if (self.loadRecord) {
            self.loadRecord = false;
            return ;
        }
        
        //将数据缓存到数据库中
        [self saveDataToDBWithModel:self.viewModel.model WithTitle:self.recordTitle];
    }];
}

#pragma mark - 判断是否有阅读记录
- (BOOL)isHasRecord{
    NSString *filePath = [RecordPath stringByAppendingPathComponent:self.recordTitle];
    WBLog(@"缓存的路径:%@",filePath);
    return [self.viewModel hasRecordWithPath:filePath];
}



#pragma mark - 获取缓存数据
- (BOOL)getRecordData{
    NSString *title = self.viewModel.recordModel.recordTitle;
    NSString *chapTitle = self.viewModel.recordModel.recordChap;
    //因为这里会导致viewModel.model发生变化,所以设置一个bool来控制
    self.loadRecord = YES;
    WBLog(@"缓存数据----> 书名: %@,  章节名称: %@ 页码: %@",title,chapTitle,self.viewModel.recordModel.recordPage);
    self.viewModel.model = [WBDatabase getDataWithTableName:title WithChapName:chapTitle];
    if ([self isBlankString:self.viewModel.model.chapContent]) {
        //无内容
        return NO;
    }else{
        //有内容
        return YES;
    }
}

//根据url获取缓存数据
- (BOOL)getRecordDataWithUrl:(NSString *)url{
    NSString *title = self.viewModel.recordModel.recordTitle;
    self.viewModel.model = [WBDatabase getDataWithUrl:url WithTableName:title];
    if (!self.viewModel.model) {
        //无内容
        return NO;
    }else{
        //有内容
        return YES;
    }
}

#pragma mark - 将数据缓存到数据库中
- (void)saveDataToDBWithModel:(BookChapModel *)model WithTitle:(NSString *)title{
    //判断数据库中是否已经存在该数据
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE current = '%@'",title,model.current];
    if ([WBDatabase isExistWithSQL:sql WithTableName:title]) {
        WBLog(@"数据已存在,不进行缓存: %@",model.chapTitle);
    }else{
        [WBDatabase saveModel:model WithTitle:title];
    }
    
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
        self.changePage = self.changePage - 1;
    }
    return [self createPageControllerWithContent:self.changePage];
}

//往后翻
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
//    self.changePage = self.currentPage;
    
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
        self.changePage = self.changePage + 1;
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
    
    //保存阅读记录
    [self.viewModel saveRecordWithTitle:self.recordTitle WithChapTitle:self.viewModel.model.chapTitle WithPage:[NSString stringWithFormat:@"%ld",self.changePage]];
    
    return self.pageController;
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

#pragma mark - ResponseEvent
- (void)tapSelf:(UITapGestureRecognizer *)sender{
    self.isTap = !self.isTap;
    if (self.isTap) {
        [self setStatusBarBackgroundColor:ProtectEyeColor];

        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
        //隐藏
        [UIView animateWithDuration:0.5 animations:^{
            self.toolView.frame = CGRectMake(0, screenHeight, screenWidth, 50);
        } completion:^(BOOL finished) {

        }];

    }else{
        [self setStatusBarBackgroundColor:[UIColor whiteColor]];

        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
        //显示
        [UIView animateWithDuration:0.5 animations:^{
            self.toolView.frame = CGRectMake(0, screenHeight-50, screenWidth, 50);
        } completion:^(BOOL finished) {

        }];
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

-(WebBookToolView *)toolView{
    if (!_toolView) {
        _toolView = [[WebBookToolView alloc]init];
    }
    return _toolView;
}
@end
