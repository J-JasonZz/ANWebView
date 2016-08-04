//
//  ANWebViewDefine.h
//  ANWebView
//
//  Created by JasonZhang on 16/8/4.
//  Copyright © 2016年 wscn. All rights reserved.
//

#ifndef ANWebViewDefine_h
#define ANWebViewDefine_h

#define AN_K_BaseWidth [UIScreen mainScreen].bounds.size.width
#define AN_K_BaseHeight [UIScreen mainScreen].bounds.size.height

#define AN_K_iPhone6P ([[UIScreen mainScreen] bounds].size.height == 736)
#define AN_K_iPhone6 ([[UIScreen mainScreen] bounds].size.height == 667)
#define AN_K_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define AN_K_iPhone4 ([[UIScreen mainScreen] bounds].size.height == 480)


#define AN_K_iOS7 [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0
#define AN_K_iOS8 [[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0
#define AN_K_iOS9 [[[UIDevice currentDevice]systemVersion] floatValue] >= 9.0
#define AN_K_DeviceVersion [[[UIDevice currentDevice]systemVersion] floatValue]

#endif /* ANWebViewDefine_h */
