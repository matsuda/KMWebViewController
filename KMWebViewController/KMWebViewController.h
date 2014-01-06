//
//  KMWebViewController.h
//  KMWebViewController
//
//  Created by matsuda on 12/02/07.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIBarButtonItem *homeButton;
@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *forwardButton;
@property (nonatomic, strong) UIBarButtonItem *reloadButton;
@property (nonatomic, strong) UIBarButtonItem *stopButton;
@property (nonatomic, assign) CGFloat currentToolBarHeight;
@property (nonatomic, assign) BOOL hideToolBar;
@property (nonatomic, copy)   NSString *url;

- (void)openURL:(NSString *)url;

@end
