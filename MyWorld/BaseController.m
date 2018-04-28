//
//  BaseController.m
//  广生盈
//
//  Created by wayneking on 18/10/2017.
//  Copyright © 2017 wayneking. All rights reserved.
//

#import "BaseController.h"
#import "Reachability.h"

@interface BaseController ()

@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;

@end

@implementation BaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavi];
    
    [self listenNetChange];
}

//设置导航条
- (void)setNavi{
    self.view.backgroundColor = BGColor;
    self.navigationController.interactivePopGestureRecognizer.delegate =  (id<UIGestureRecognizerDelegate>)self;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.leftButton = [[UIButton alloc]init];
    self.leftButton.frame = CGRectMake(0, 0, 40, 40);
    //[self.leftButton setBackgroundImage:[UIImage imageNamed:@"Icon-return_login_"] forState:UIControlStateNormal];
    [self.leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    self.leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    [self.leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
    self.navigationItem.leftBarButtonItem = back;
    
    self.rightButton = [[UIButton alloc]init];
    self.rightButton.frame = CGRectMake(0, 0, 24, 24);
    [self.rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.right = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
//    self.navigationItem.rightBarButtonItem = right;
    
//    self.rightButton2 = [[UIButton alloc]init];
//    self.rightButton2.frame = CGRectMake(0, 0, 24, 24);
//    [self.rightButton2 addTarget:self action:@selector(rightButtonAction2) forControlEvents:UIControlEventTouchUpInside];
//    self.right2 = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton2];
//    UIBarButtonItem *right2 = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton2];
//    self.navigationItem.rightBarButtonItem = right;
    
    
    self.rightButton2 = [[TTFaveButton alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
        [self.rightButton2 addTarget:self action:@selector(rightButtonAction2) forControlEvents:UIControlEventTouchUpInside];
        self.right2 = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton2];
        UIBarButtonItem *right2 = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton2];
    
    
    self.navigationItem.rightBarButtonItems = @[right,right2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//监听网络状态
- (void)listenNetChange{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
//    NSString *remoteHostName = @"www.apple.com";
//    NSString *remoteHostLabelFormatString = NSLocalizedString(@"Remote Host: %@", @"Remote host label format string");
    
//    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
//    [self.hostReachability startNotifier];
//    [self updateInterfaceWithReachability:self.hostReachability];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
}

- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    if (reachability == self.hostReachability)
    {
        [self configureTextField:nil imageView:nil reachability:reachability];
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        BOOL connectionRequired = [reachability connectionRequired];
        
        NSString* baseLabelText = @"";
        
        if (connectionRequired)
        {
            baseLabelText = NSLocalizedString(@"Cellular data network is available.\nInternet traffic will be routed through it after a connection is established.", @"Reachability text if a connection is required");
        }
        else
        {
            baseLabelText = NSLocalizedString(@"Cellular data network is active.\nInternet traffic will be routed through it.", @"Reachability text if a connection is not required");
        }
        
    }
    
    if (reachability == self.internetReachability)
    {
        [self configureTextField:nil imageView:nil reachability:reachability];
    }
    
}

- (void)configureTextField:(UITextField *)textField imageView:(UIImageView *)imageView reachability:(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    BOOL connectionRequired = [reachability connectionRequired];
    NSString* statusString = @"";
    
    switch (netStatus)
    {
        case NotReachable:        {
            statusString = NSLocalizedString(@"无可用网络", @"");
            self.netState = @"NotReachable";
            /*
             Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
             */
            connectionRequired = NO;
             [CCProgressHUD showMessageInAFlashWithMessage:@"未连接网络,请连接WiFi或3G/4G"];
            break;
        }
            
        case ReachableViaWWAN:        {
            statusString = NSLocalizedString(@"WWAN", @"");
            self.netState = @"3G/4G";
            break;
        }
        case ReachableViaWiFi:        {
            statusString= NSLocalizedString(@"WiFi", @"");
            self.netState = @"WiFi";
            break;
        }
    }
    
    if (connectionRequired)
    {
        NSString *connectionRequiredFormatString = NSLocalizedString(@"%@, Connection Required", @"Concatenation of status string with connection requirement");
        statusString= [NSString stringWithFormat:connectionRequiredFormatString, statusString];
    }

//    [CCProgressHUD showMessageInAFlashWithMessage:statusString];
    
    [self netWorkChange:self.netState];
}

- (void)netWorkChange:(NSString *)currentState{
    //子类重写
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

#pragma mark - Action
- (void)leftButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonAction{
    
}

- (void)rightButtonAction2{
    
}

-(void)setLeftButtonImage:(NSString *)imageName{
    [self.leftButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

-(void)setRightButtonImage:(NSString *)imageName{
    [self.rightButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}


@end
