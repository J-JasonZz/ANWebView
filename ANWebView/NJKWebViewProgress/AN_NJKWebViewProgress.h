//
//  NJKWebViewProgress.h
//
//  Created by Satoshi Aasano on 4/20/13.
//  Copyright (c) 2013 Satoshi Asano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#undef njk_weak
#if __has_feature(objc_arc_weak)
#define njk_weak weak
#else
#define njk_weak unsafe_unretained
#endif

extern const float AN_NJKInitialProgressValue;
extern const float AN_NJKInteractiveProgressValue;
extern const float AN_NJKFinalProgressValue;

typedef void (^AN_NJKWebViewProgressBlock)(float progress);
@protocol AN_NJKWebViewProgressDelegate;
@interface AN_NJKWebViewProgress : NSObject<UIWebViewDelegate>
@property (nonatomic, njk_weak) id<AN_NJKWebViewProgressDelegate>progressDelegate;
@property (nonatomic, njk_weak) id<UIWebViewDelegate>webViewProxyDelegate;
@property (nonatomic, copy) AN_NJKWebViewProgressBlock progressBlock;
@property (nonatomic, readonly) float progress; // 0.0..1.0

- (void)reset;
@end

@protocol AN_NJKWebViewProgressDelegate <NSObject>
- (void)webViewProgress:(AN_NJKWebViewProgress *)webViewProgress updateProgress:(float)progress;
@end

