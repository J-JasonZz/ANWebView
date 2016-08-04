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

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnullability-completeness"

@class ANWebView;
@protocol ANWebViewDelegate <NSObject>
- (void)an_webViewDidStartLoad:(ANWebView *)webView;
- (void)an_webViewDidFinishLoad:(ANWebView *)webView;
- (void)an_webView:(ANWebView *)webView didFailLoadWithError:(nullable NSError *)error;
- (BOOL)an_webView:(ANWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
@end

@interface ANWebView : NSObject

@property (nonatomic, weak, nullable) UIView *webView;

@property (nonatomic, strong, nullable) WKWebView *wkWebView;

@property (nonatomic, strong, nullable) UIWebView *uiWebView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, weak, nullable) id<ANWebViewDelegate> delegate;

@property (nullable, nonatomic, readonly, strong) NSURLRequest *request;

@property (nonatomic, assign, readonly) BOOL canGoBack;

@property (nonatomic, assign, readonly) BOOL canGoForward;

@property (nonatomic, assign, readonly) BOOL isLoading;

- (instancetype)initWithFrame:(CGRect)frame configuration:(nullable WKWebViewConfiguration *)configuration;

- (void)loadRequest:(NSURLRequest *)request;

- (void)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL;

- (void)goBack;

- (void)goForward;

- (void)reload;

- (void)stopLoading;


#pragma clang diagnostic pop
@end
