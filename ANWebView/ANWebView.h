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

typedef NS_ENUM(NSInteger, ANWebViewNavigationType) {
    ANWebViewNavigationTypeLinkClicked,
    ANWebViewNavigationTypeFormSubmitted,
    ANWebViewNavigationTypeBackForward,
    ANWebViewNavigationTypeReload,
    ANWebViewNavigationTypeFormResubmitted,
    ANWebViewNavigationTypeOther
};

@class ANWebView;
@protocol ANWebViewDelegate <NSObject>
@optional
- (void)an_webViewDidStartLoad:(ANWebView *)webView;
- (void)an_webViewDidFinishLoad:(ANWebView *)webView;
- (void)an_webView:(ANWebView *)webView didFailLoadWithError:(nullable NSError *)error;
- (BOOL)an_webView:(ANWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(ANWebViewNavigationType)navigationType;

- (void)an_webView:(ANWebView *)webView loadProgress:(float)progress;
@end

@interface ANWebView : NSObject

@property (nonatomic, weak, nullable, readonly) UIView *webView;

@property (nonatomic, strong, nullable, readonly) WKWebView *wkWebView;

@property (nonatomic, strong, nullable, readonly) UIWebView *uiWebView;

@property (nonatomic, strong, readonly) UIScrollView *scrollView;

@property (nonatomic, weak, nullable) id<ANWebViewDelegate> delegate;

@property (nullable, nonatomic, readonly, strong) NSURLRequest *request;

@property (nonatomic, assign, readonly) BOOL canGoBack;

@property (nonatomic, assign, readonly) BOOL canGoForward;

@property (nonatomic, assign, readonly) BOOL isLoading;

- (instancetype)initWithFrame:(CGRect)frame configuration:(nullable WKWebViewConfiguration *)configuration;

- (void)loadRequest:(NSURLRequest *)request;

- (void)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL;

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ __nullable)(__nullable id, NSError * __nullable error))completionHandler;

- (UIView *)snapshotViewAfterScreenUpdates:(BOOL)afterUpdates;

- (void)goBack;

- (void)goForward;

- (void)reload;

- (void)stopLoading;


#pragma clang diagnostic pop
@end
