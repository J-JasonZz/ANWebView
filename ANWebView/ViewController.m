//
//  ViewController.m
//  ANWebView
//
//  Created by JasonZhang on 16/8/4.
//  Copyright © 2016年 wscn. All rights reserved.
//

#import "ViewController.h"
#import "ANWebView.h"

@interface ViewController ()

@property (nonatomic, strong) ANWebView *an_webView;

@end

@implementation ViewController

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

@end
