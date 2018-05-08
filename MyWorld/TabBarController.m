//
//  TabBarController.m
//  广生盈
//
//  Created by wayneking on 18/10/2017.
//  Copyright © 2017 wayneking. All rights reserved.
//

#import "TabBarController.h"
#import "HomeViewController.h"
#import "BookIndexController.h"
#import "BookShelfController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setVCs];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置子controller
- (void)setVCs{
    HomeViewController *home = [[HomeViewController alloc]init];
    [self setUpOneChildVcWithVc:home Image:@"Btn-hp-pre" selectedImage:@"Btn-hp" title:@"首页"];
    
    BookIndexController *index = [[BookIndexController alloc]init];
    [self setUpOneChildVcWithVc:index Image:@"Btn-sort-pre" selectedImage:@"Btn-sort" title:@"推荐"];
    
    BookShelfController *shelf = [[BookShelfController alloc]init];
    [self setUpOneChildVcWithVc:shelf Image:@"Btn-sort-pre" selectedImage:@"Btn-sort" title:@"书架"];

}

/**
 *
 *  @param Vc            每一个按钮对应的控制器
 *  @param image         每一个按钮对应的普通状态下图片
 *  @param selectedImage 每一个按钮对应的选中状态下的图片
 *  @param title         每一个按钮对应的标题
 */
- (void)setUpOneChildVcWithVc:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:Vc];
    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Vc.tabBarItem.image = mySelectedImage;
    Vc.tabBarItem.selectedImage = myImage;
    Vc.tabBarItem.title = title;
    //    Vc.tabBarItem.badgeColor=MainColor;
    //    Vc.tabBarItem.badgeValue=@"9";
    Vc.navigationItem.title = title;
    [self inits:Vc.tabBarItem];
    [self addChildViewController:nav];
}


-(void)inits:(UITabBarItem *)tabBarItem
{
    NSMutableDictionary *dictNormal = [[NSMutableDictionary alloc]init];
    dictNormal[NSForegroundColorAttributeName] = MiddleGray;
    dictNormal[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    
    NSMutableDictionary *dictSelected = [[NSMutableDictionary alloc]init];
    dictSelected[NSForegroundColorAttributeName] = [UIColor colorWithRed:240/155.0 green:149/255.0 blue:37/255.0 alpha:1.0];
    dictSelected[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    
    [tabBarItem setTitleTextAttributes:dictNormal forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:dictSelected forState:UIControlStateSelected];
}


@end
