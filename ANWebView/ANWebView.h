//
//  ANWebView.h
//  ANWebView
//
//  Created by JasonZhang on 16/8/4.
//  Copyright © 2016年 wscn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@protocol ANWebViewDelegate <NSObject>

@end

@interface ANWebView : NSObject

@property (nonatomic, weak, nullable) UIView *webView;

@property (nonatomic, strong, nullable) WKWebView *wkWebView;

@property (nonatomic, strong, nullable) UIWebView *uiWebView;

@property (nonatomic, weak, nullable) id<ANWebViewDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration;
@end
