//
//  ANWebView.m
//  ANWebView
//
//  Created by JasonZhang on 16/8/4.
//  Copyright © 2016年 wscn. All rights reserved.
//

#import "ANWebView.h"
#import "ANWebViewDefine.h"
#import "AN_NJKWebViewProgress.h"

@interface ANWebView ()<WKNavigationDelegate, UIWebViewDelegate, AN_NJKWebViewProgressDelegate>

@property (nonatomic, strong, nullable) WKWebView *wkWebView;

@property (nonatomic, strong, nullable) UIWebView *uiWebView;

@property (nonatomic, weak, nullable) UIView *webView;

@property (nonatomic, strong) AN_NJKWebViewProgress *njkWebViewProgress;

@end

@implementation ANWebView
{
    struct {
        unsigned int webViewDidStartLoad : 1;
        unsigned int webViewDidFinishLoad : 1;
        unsigned int didFailLoadWithError : 1;
        unsigned int shouldStartLoadWithRequest : 1;
        unsigned int loadProgress : 1;
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
        self.uiWebView.delegate = self.njkWebViewProgress;
        self.webView = self.uiWebView;
    }
}

- (void)configWKWebViewWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration
{
    if (self.wkWebView == nil) {
        self.wkWebView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
        self.wkWebView.navigationDelegate = self;
        [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
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
    _delegateFlags.loadProgress = _delegate && [_delegate respondsToSelector:@selector(an_webView:loadProgress:)];
}

- (UIScrollView *)scrollView
{
    return _wkWebView ? _wkWebView.scrollView : _uiWebView.scrollView;
}

- (AN_NJKWebViewProgress *)njkWebViewProgress
{
    if (_njkWebViewProgress == nil) {
        _njkWebViewProgress = [[AN_NJKWebViewProgress alloc] init];
        _njkWebViewProgress.webViewProxyDelegate = self;
        _njkWebViewProgress.progressDelegate = self;
    }
    return _njkWebViewProgress;
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

- (void)loadRequest:(NSURLRequest *)request
{
    _request = request;
    _wkWebView ? [_wkWebView loadRequest:request] : [_uiWebView loadRequest:request];
}

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL
{
    _wkWebView ? [_wkWebView loadHTMLString:string baseURL:baseURL] : [_uiWebView loadHTMLString:string baseURL:baseURL];
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

#pragma mark -- Progress
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [self _webViewProgressChanged:[change[@"NSKeyValueChangeNewKey"] floatValue]];
    }
}

#pragma mark -- AN_NJKWebViewProgressDelegate
- (void)webViewProgress:(AN_NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [self _webViewProgressChanged:progress];
}

- (void)_webViewProgressChanged:(float)progress
{
    if (_delegateFlags.loadProgress) {
        [_delegate an_webView:self loadProgress:progress];
    }
}


#pragma mark -- UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self _webViewDidStartLoad];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self _webViewDidFinishLoad];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    [self _webViewDidFailLoadWithError:error];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return [self _webViewShouldStartLoadWithRequest:request navigationType:navigationType];
}

#pragma mark -- WKWebViewDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    [self _webViewDidStartLoad];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [self _webViewDidFinishLoad];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [self _webViewDidFailLoadWithError:error];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if ([self _webViewShouldStartLoadWithRequest:navigationAction.request navigationType:navigationAction.navigationType]) {
        decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

#pragma mark -- privateCommon
- (void)_webViewDidStartLoad
{
    if (_delegateFlags.webViewDidStartLoad) {
        [_delegate an_webViewDidStartLoad:self];
    }
}

- (void)_webViewDidFinishLoad
{
    if (_delegateFlags.webViewDidFinishLoad) {
        [_delegate an_webViewDidFinishLoad:self];
    }
}

- (void)_webViewDidFailLoadWithError:(NSError *)error
{
    if (_delegateFlags.didFailLoadWithError) {
        [_delegate an_webView:self didFailLoadWithError:error];
    }
}

- (BOOL)_webViewShouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(NSInteger)navigationType
{
    BOOL shouldLoad = YES;
    if (_delegateFlags.shouldStartLoadWithRequest) {
        if (navigationType == -1) {
            navigationType = WKNavigationTypeOther;
        }
        return [_delegate an_webView:self shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return shouldLoad;
}

- (void)dealloc
{
    if (_wkWebView) {
        [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
}

@end
