//
//  KMWebViewController.m
//  KMWebViewController
//
//  Created by matsuda on 12/02/07.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "KMWebViewController.h"

static CGFloat kNavigationBarHeight = 44.f;
static CGFloat kToolBarHeight = 44.f;
static CGFloat kTabBarHeight = 49.f;
static NSString *kTitleLoading = @"Loading...";

#define iOSVersionGreaterThaniOS7 \
    !(floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)

@interface KMWebViewController ()

@end

@implementation KMWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _hideToolBar = NO;
        _currentToolBarHeight = 0.f;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];

    if (!iOSVersionGreaterThaniOS7) {
        if (self.navigationController && !self.navigationController.navigationBar.hidden) {
            self.view.frame = ({
                CGRect frame = self.view.frame;
                frame.size.height -= kNavigationBarHeight;
                frame;
            });
        }
    }

    CGRect f = self.view.bounds;
    UIWebView *webView = self.webView;
    webView.frame = f;
    [self.view addSubview:webView];

    UIToolbar *toolBar = self.toolBar;
    toolBar.frame = (CGRect){f.origin.x, f.size.height - kToolBarHeight, f.size.width, kToolBarHeight};
    [self.view addSubview:toolBar];
    self.currentToolBarHeight = toolBar.frame.size.height;

    UIActivityIndicatorView *indicatorView = self.indicatorView;
    indicatorView.frame = ({
        CGRect frame = self.indicatorView.frame;
        CGRect wf = webView.frame;
        frame.origin.x = (wf.size.width - frame.size.width) / 2;
        frame.origin.y = (wf.size.height - frame.size.height) / 2;
        frame;
    });
    [self.view addSubview:indicatorView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self toggleToolBar];
    if (self.url) [self loadWeb];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([self.webView isLoading]) {
        [self.webView stopLoading];
    }
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    self.webView.delegate = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Target

- (void)didTapHomeButton:(id)sender
{
    [self backToApp];
}
- (void)didTapBackButton:(id)sender
{
    [self.webView goBack];
}
- (void)didTapForwardButton:(id)sender
{
    [self.webView goForward];
}
- (void)didTapReloadButton:(id)sender
{
    [self.webView reload];
}
- (void)didTapStopButton:(id)sender
{
    [self.webView stopLoading];
}

#pragma mark - Public

- (void)openURL:(NSString *)url
{
    self.url = url;
    [self loadWeb];
}

#pragma mark - Private

- (void)loadWeb
{
    [self.indicatorView startAnimating];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)toggleToolBar
{
    if (!iOSVersionGreaterThaniOS7) {
        if (self.tabBarController && !self.tabBarController.tabBar.hidden) {
            self.view.frame = ({
                CGRect frame = self.view.frame;
                frame.size.height -= kTabBarHeight;
                frame;
            });
        }
    }
    CGRect tf = self.toolBar.frame;
    if (self.hideToolBar && self.currentToolBarHeight) {
        tf.size.height -= self.currentToolBarHeight;
    } else if (!self.hideToolBar && !self.currentToolBarHeight) {
        tf.size.height += kToolBarHeight;
    }
    self.toolBar.frame = tf;

    CGFloat insetsBottom = self.hideToolBar ? 0.f : kToolBarHeight;
    self.webView.scrollView.contentInset = ({
        UIEdgeInsets insets = self.webView.scrollView.contentInset;
        insets.bottom = insetsBottom;
        insets;
    });
    self.webView.scrollView.scrollIndicatorInsets = ({
        UIEdgeInsets insets = self.webView.scrollView.scrollIndicatorInsets;
        insets.bottom = insetsBottom;
        insets;
    });

    self.currentToolBarHeight = self.toolBar.frame.size.height;
    if (self.currentToolBarHeight) self.toolBar.hidden = NO;
}

- (void)backToApp
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UIToolbar *)toolBar
{
    if (!_toolBar) {
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectZero];
        if (!iOSVersionGreaterThaniOS7) {
            [toolBar setBarStyle:UIBarStyleBlack];
        }
        toolBar.hidden = YES;

        UIBarItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolBar setItems:@[self.homeButton, space, self.backButton, space, self.forwardButton, space, self.reloadButton, space, self.stopButton]];
        _toolBar = toolBar;
    }
    return _toolBar;
}

- (UIBarButtonItem *)homeButton
{
    if (!_homeButton) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"KMWebViewController.bundle/home.png"]
                                                                 style:UIBarButtonItemStylePlain target:self action:@selector(didTapHomeButton:)];
        _homeButton = item;
    }
    return _homeButton;
}

- (UIBarButtonItem *)backButton
{
    if (!_backButton) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"KMWebViewController.bundle/back.png"]
                                                                 style:UIBarButtonItemStylePlain target:self action:@selector(didTapBackButton:)];
        item.enabled = NO;
        _backButton = item;
    }
    return _backButton;
}

- (UIBarButtonItem *)forwardButton
{
    if (!_forwardButton) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"KMWebViewController.bundle/forward.png"]
                                                                 style:UIBarButtonItemStylePlain target:self action:@selector(didTapForwardButton:)];
        item.enabled = NO;
        _forwardButton = item;
    }
    return _forwardButton;
}

- (UIBarButtonItem *)reloadButton
{
    if (!_reloadButton) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"KMWebViewController.bundle/reload.png"]
                                                                 style:UIBarButtonItemStylePlain target:self action:@selector(didTapReloadButton:)];
        item.enabled = NO;
        _reloadButton = item;
    }
    return _reloadButton;
}

- (UIBarButtonItem *)stopButton
{
    if (!_stopButton) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"KMWebViewController.bundle/cancel.png"]
                                                                 style:UIBarButtonItemStylePlain target:self action:@selector(didTapStopButton:)];
        item.enabled = NO;
        _stopButton = item;
    }
    return _stopButton;
}

- (UIWebView *)webView
{
    if (!_webView) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        webView.backgroundColor = [UIColor whiteColor];
        webView.scalesPageToFit = YES;
        webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        webView.delegate = self;
        _webView = webView;
    }
    return _webView;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [indicatorView setHidesWhenStopped:YES];
        _indicatorView = indicatorView;
    }
    return _indicatorView;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    self.backButton.enabled = [self.webView canGoBack];
    self.forwardButton.enabled = [self.webView canGoForward];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.backButton.enabled = [self.webView canGoBack];
    self.forwardButton.enabled = [self.webView canGoForward];
    self.reloadButton.enabled = NO;
    self.stopButton.enabled = YES;
    if (self.navigationController) {
        self.navigationItem.title = kTitleLoading;
    } else {
        self.title = kTitleLoading;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.backButton.enabled = [self.webView canGoBack];
    self.forwardButton.enabled = [self.webView canGoForward];
    self.reloadButton.enabled = YES;
    self.stopButton.enabled = NO;
    [self.indicatorView stopAnimating];
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (self.navigationController) {
        self.navigationItem.title = title;
    } else {
        self.title = title;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // [self.indicatorView stopAnimating];
    [self webViewDidFinishLoad:webView];
}

@end
