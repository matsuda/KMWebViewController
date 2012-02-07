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
@property (nonatomic, copy)   NSString *url;
@property (nonatomic, assign) BOOL hideToolBar;

- (void)openURL:(NSString *)url;

@end
