//
//  ANWebViewController.m
//  ANWebView
//
//  Created by JasonZhang on 16/8/5.
//  Copyright © 2016年 wscn. All rights reserved.
//

#import "ANWebViewController.h"
#import "ANWebView.h"
#import "AN_NJKWebViewProgressView.h"
#import "ANWebViewDefine.h"

@interface ANWebViewController ()<ANWebViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) ANWebView *an_webView;

@property (nonatomic, strong) AN_NJKWebViewProgressView *an_progressView;

@property (nonatomic, strong) NSURL *url;

/**
 *  历史页面与request
 */
@property (nonatomic, strong) NSMutableArray *snapShotsArray;

/**
 *  当前展示的view
 */
@property (nonatomic, strong)UIView* currentSnapShotView;

/**
 *  上一个展示的view
 */
@property (nonatomic, strong)UIView* prevSnapShotView;

/**
 *  侧滑背景半透明view
 */
@property (nonatomic, strong)UIView* swipingBackgoundView;

/**
 *  滑动手势
 */
@property (nonatomic, strong)UIPanGestureRecognizer* swipePanGesture;

/**
 *  当前是否正在滑动
 */
@property (nonatomic, assign)BOOL isSwipingBack;

/**
 *  是否把当前视图和请求添加至数组
 */
@property (nonatomic, assign) BOOL isShouldAdd;

@end

@implementation ANWebViewController

- (instancetype)initWithUrl:(NSURL *)url
{
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}

- (AN_NJKWebViewProgressView *)an_progressView
{
    if (_an_progressView == nil) {
        
        CGFloat progressBarHeight = 2.f;
        CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
        
        _an_progressView = [[AN_NJKWebViewProgressView alloc] initWithFrame:CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight)];
        _an_progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    return _an_progressView;
}

- (ANWebView *)an_webView
{
    if (_an_webView == nil) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        _an_webView = [[ANWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _an_webView.delegate = self;
        [_an_webView.webView addGestureRecognizer:self.swipePanGesture];
        [self.view addSubview:_an_webView.webView];
    }
    return _an_webView;
}

- (NSMutableArray *)snapShotsArray
{
    if (_snapShotsArray == nil) {
        _snapShotsArray = [NSMutableArray array];
    }
    return _snapShotsArray;
}

-(UIView*)swipingBackgoundView{
    if (!_swipingBackgoundView) {
        _swipingBackgoundView = [[UIView alloc] initWithFrame:self.view.bounds];
        _swipingBackgoundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return _swipingBackgoundView;
}

-(UIPanGestureRecognizer*)swipePanGesture{
    if (!_swipePanGesture) {
        _swipePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipePanGestureHandler:)];
    }
    return _swipePanGesture;
}


#pragma mark -- LifeCycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.an_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.an_progressView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShouldAdd = YES;
    self.isSwipingBack = NO;
    [self.an_webView loadRequest:[NSURLRequest requestWithURL:_url]];
}

#pragma mark -- ANWebViewDelegate
- (void)an_webViewDidStartLoad:(ANWebView *)webView
{
    
}

- (void)an_webViewDidFinishLoad:(ANWebView *)webView
{
    self.isShouldAdd = YES;
    // 每次加载完成都要判断当前是否可以goback
    self.navigationController.interactivePopGestureRecognizer.enabled = !self.an_webView.canGoBack;
    
    __weak ANWebViewController *wSelf = self;
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        wSelf.title = (NSString *)result;
    }];
}

- (void)an_webView:(ANWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    self.isShouldAdd = YES;
    // 每次加载失败都要判断当前是否可以goback
    self.navigationController.interactivePopGestureRecognizer.enabled = !self.an_webView.canGoBack;
}

- (BOOL)an_webView:(ANWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(ANWebViewNavigationType)navigationType
{
    switch (navigationType) {
        case ANWebViewNavigationTypeLinkClicked: {
            if (self.an_webView.isLoading) {
                return NO;
            }
            [self pushCurrentSnapshotViewWithRequest:request];
            break;
        }
        case ANWebViewNavigationTypeFormSubmitted: {
            [self pushCurrentSnapshotViewWithRequest:request];
            break;
        }
        case ANWebViewNavigationTypeBackForward: {
            break;
        }
        case ANWebViewNavigationTypeReload: {
            break;
        }
        case ANWebViewNavigationTypeFormResubmitted: {
            break;
        }
        case ANWebViewNavigationTypeOther: {
            [self pushCurrentSnapshotViewWithRequest:request];
            break;
        }
        default: {
            break;
        }
    }
    return YES;
}

- (void)an_webView:(ANWebView *)webView loadProgress:(float)progress
{
    [self.an_progressView setProgress:progress animated:YES];
}

#pragma mark - logic of push and pop snap shot views
-(void)pushCurrentSnapshotViewWithRequest:(NSURLRequest*)request{
    
    NSURLRequest* lastRequest = (NSURLRequest*)[[self.snapShotsArray lastObject] objectForKey:@"request"];
    
    if ([lastRequest.URL.absoluteString isEqualToString:request.URL.absoluteString]) {
        return;
    }
    
    // 同一页面保存加载的第一个url和view
    if (self.isShouldAdd) {
        UIView* currentSnapShotView = [self.an_webView snapshotViewAfterScreenUpdates:YES];
        
        [self.snapShotsArray addObject:
         @{
           @"request":request,
           @"snapShotView":currentSnapShotView
           }
         ];
    }
    self.isShouldAdd = NO;
}

-(void)startPopSnapshotView{

    if (self.isSwipingBack) {
        return;
    }
    if (!self.an_webView.canGoBack) {
        return;
    }
    
    self.isSwipingBack = YES;

    CGPoint center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    
    self.currentSnapShotView = [self.an_webView snapshotViewAfterScreenUpdates:YES];
    
    self.currentSnapShotView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.currentSnapShotView.layer.shadowOffset = CGSizeMake(3, 3);
    self.currentSnapShotView.layer.shadowRadius = 5;
    self.currentSnapShotView.layer.shadowOpacity = 0.75;
    
    self.currentSnapShotView.center = center;
    
    self.prevSnapShotView = (UIView*)[[self.snapShotsArray lastObject] objectForKey:@"snapShotView"];
    center.x -= 60;
    self.prevSnapShotView.center = center;
    self.prevSnapShotView.alpha = 1;
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.prevSnapShotView];
    [self.view addSubview:self.swipingBackgoundView];
    [self.view addSubview:self.currentSnapShotView];
}

-(void)popSnapShotViewWithPanGestureDistance:(CGFloat)distance{
    if (!self.isSwipingBack) {
        return;
    }
    
    if (distance <= 0) {
        return;
    }
    
    CGPoint currentSnapshotViewCenter = CGPointMake(AN_K_BaseWidth/2, AN_K_BaseHeight/2);
    currentSnapshotViewCenter.x += distance;
    CGPoint prevSnapshotViewCenter = CGPointMake(AN_K_BaseWidth/2, AN_K_BaseHeight/2);
    prevSnapshotViewCenter.x -= (AN_K_BaseWidth - distance)*60/AN_K_BaseWidth;
    
    self.currentSnapShotView.center = currentSnapshotViewCenter;
    self.prevSnapShotView.center = prevSnapshotViewCenter;
    self.swipingBackgoundView.alpha = (AN_K_BaseWidth - distance)/AN_K_BaseWidth;
}

-(void)endPopSnapShotView{
    if (!self.isSwipingBack) {
        return;
    }
    
    self.view.userInteractionEnabled = NO;
    
    if (self.currentSnapShotView.frame.origin.x >= AN_K_BaseWidth / 4) {
        [UIView animateWithDuration:0.2 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            self.currentSnapShotView.center = CGPointMake(AN_K_BaseWidth*3/2, AN_K_BaseHeight/2);
            self.prevSnapShotView.center = CGPointMake(AN_K_BaseWidth/2, AN_K_BaseHeight/2);
            self.swipingBackgoundView.alpha = 0;
        }completion:^(BOOL finished) {
            [self.prevSnapShotView removeFromSuperview];
            [self.swipingBackgoundView removeFromSuperview];
            [self.currentSnapShotView removeFromSuperview];
            [self.an_webView goBack];
            [self.snapShotsArray removeLastObject];
            self.view.userInteractionEnabled = YES;
            self.isSwipingBack = NO;

            if (self.snapShotsArray.count <= 1) {
                self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            } else {
                self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            }
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            self.currentSnapShotView.center = CGPointMake(AN_K_BaseWidth/2, AN_K_BaseHeight/2);
            self.prevSnapShotView.center = CGPointMake(AN_K_BaseWidth/2-60, AN_K_BaseHeight/2);
            self.prevSnapShotView.alpha = 1;
        }completion:^(BOOL finished) {
            [self.prevSnapShotView removeFromSuperview];
            [self.swipingBackgoundView removeFromSuperview];
            [self.currentSnapShotView removeFromSuperview];
            self.view.userInteractionEnabled = YES;
            self.isSwipingBack = NO;
        }];
    }
}

#pragma mark - events handler
-(void)swipePanGestureHandler:(UIPanGestureRecognizer*)panGesture{
    
    if (!self.an_webView.canGoBack) {
        return;
    }
    
    CGPoint translation = [panGesture translationInView:self.an_webView.webView];
    CGPoint location = [panGesture locationInView:self.an_webView.webView];
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        if (location.x <= 50 && translation.x > 0) {
            [self startPopSnapshotView];
        }
    }else if (panGesture.state == UIGestureRecognizerStateCancelled || panGesture.state == UIGestureRecognizerStateEnded){
        [self endPopSnapShotView];
    }else if (panGesture.state == UIGestureRecognizerStateChanged){
        [self popSnapShotViewWithPanGestureDistance:translation.x];
    }
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
