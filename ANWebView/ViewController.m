//
//  ViewController.m
//  ANWebView
//
//  Created by JasonZhang on 16/8/4.
//  Copyright © 2016年 wscn. All rights reserved.
//

#import "ViewController.h"
#import "ANWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pushButton.backgroundColor = [UIColor redColor];
    pushButton.frame = CGRectMake(100, 100, 100, 100);
    [pushButton addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushButton];
}

- (void)pushAction
{
    ANWebViewController *controller = [[ANWebViewController alloc] initWithUrl:[NSURL URLWithString:@"http://baidu.com"]];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
