//
//  ANWebView.m
//  ANWebView
//
//  Created by JasonZhang on 16/8/4.
//  Copyright © 2016年 wscn. All rights reserved.
//

#import "ANWebView.h"
#import "ANWebViewDefine.h"

@implementation ANWebView
{
    
}

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration
{
    self = [super init];
    if (self) {
        if (AN_K_DeviceVersion < 8.0) {
            [self configUIWebView];
        } else {
            [self configWKWebView];
        }
    }
    return self;
}

- (void)configUIWebView
{
    
}

- (void)configWKWebView
{
    
}


@end
