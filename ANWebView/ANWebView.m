//
//  ANWebView.m
//  ANWebView
//
//  Created by JasonZhang on 16/8/4.
//  Copyright © 2016年 wscn. All rights reserved.
//

#import "ANWebView.h"
#import "ANWebViewDefine.h"

@interface ANWebView ()<WKNavigationDelegate, UIWebViewDelegate>

@end

@implementation ANWebView
{
    struct {
        unsigned int webViewDidStartLoad : 1;
        unsigned int webViewDidFinishLoad : 1;
        unsigned int didFailLoadWithError : 1;
        unsigned int shouldStartLoadWithRequest : 1;
    } _delegateFlags;
}

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration
{
    self = [super init];
    if (self) {
        if (AN_K_DeviceVersion < 8.0 || !configuration) {
            [self configUIWebViewWithFrame:frame];
        } else {
            [self configWKWebViewWithFrame:frame configuration:configuration];
        }
    }
    return self;
}

- (void)configUIWebViewWithFrame:(CGRect)frame;
{
    if (self.uiWebView == nil) {
        self.uiWebView = [[UIWebView alloc] initWithFrame:frame];
        self.webView = self.uiWebView;
    }
}

- (void)configWKWebViewWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration
{
    if (self.wkWebView == nil) {
        self.wkWebView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
        self.wkWebView.navigationDelegate = self;
        [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
        self.webView = self.wkWebView;
    }
}

- (void)setDelegate:(id<ANWebViewDelegate>)delegate
{
    _delegate = delegate;
    _delegateFlags.webViewDidStartLoad = _delegate && [_delegate respondsToSelector:@selector(an_webViewDidStartLoad:)];
    _delegateFlags.webViewDidFinishLoad = _delegate && [_delegate respondsToSelector:@selector(an_webViewDidFinishLoad:)];
    _delegateFlags.didFailLoadWithError = _delegate && [_delegate respondsToSelector:@selector(an_webView:didFailLoadWithError:)];
    _delegateFlags.shouldStartLoadWithRequest = _delegate && [_delegate respondsToSelector:@selector(an_webView:shouldStartLoadWithRequest:navigationType:)];
}

- (void)loadRequest:(NSURLRequest *)request
{
    _request = request;
    _wkWebView ? [_wkWebView loadRequest:request] : [_uiWebView loadRequest:request];
}

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL
{
    _wkWebView ? [_wkWebView loadHTMLString:string baseURL:baseURL] : [_uiWebView loadHTMLString:string baseURL:baseURL];
}

- (BOOL)canGoBack
{
    return _wkWebView ? _wkWebView.canGoBack : _uiWebView.canGoBack;
}

- (BOOL)canGoForward
{
    return _wkWebView ? _wkWebView.canGoForward : _uiWebView.canGoForward;
}

- (BOOL)isLoading
{
    return _wkWebView ? _wkWebView.isLoading : _uiWebView.isLoading;
}

- (void)goBack
{
    _wkWebView ? [_wkWebView goBack] : [_uiWebView goBack];
}

- (void)goForward
{
    _wkWebView ? [_wkWebView goForward] : [_uiWebView goForward];
}

- (void)reload
{
    _wkWebView ? [_wkWebView reload] : [_uiWebView reload];
}

- (void)stopLoading
{
    _wkWebView ? [_wkWebView stopLoading] : [_wkWebView stopLoading];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
}

#pragma mark - WebViewDelegate
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    
}


@end
