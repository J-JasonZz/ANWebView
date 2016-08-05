//
//  ANWebViewController.m
//  ANWebView
//
//  Created by JasonZhang on 16/8/5.
//  Copyright © 2016年 wscn. All rights reserved.
//

#import "ANWebViewController.h"
#import "ANWebView.h"

@interface ANWebViewController ()

@property (nonatomic, strong) ANWebView *an_webView;

@end

@implementation ANWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    self.an_webView = [[ANWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    [self.view addSubview:self.an_webView.webView];
    [self.an_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
