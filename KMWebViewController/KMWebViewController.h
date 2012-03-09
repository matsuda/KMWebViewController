//
//  KMWebViewController.h
//  KMWebViewController
//
//  Created by matsuda on 12/02/07.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIActivityIndicatorView *indicatorView;

@property (nonatomic, retain) UIToolbar *toolBar;
@property (nonatomic, assign) BOOL hideToolBar;
@property (nonatomic, assign) CGFloat currentToolBarHeight;

@property (nonatomic, retain) UIBarButtonItem *homeButton;
@property (nonatomic, retain) UIBarButtonItem *backButton;
@property (nonatomic, retain) UIBarButtonItem *forwardButton;
@property (nonatomic, retain) UIBarButtonItem *reloadButton;
@property (nonatomic, retain) UIBarButtonItem *stopButton;

@property (nonatomic, copy)   NSString *url;

- (void)openURL:(NSString *)url;

@end
