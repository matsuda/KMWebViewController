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
static NSString *kTitleLoading = @"Loading...";

@interface KMWebViewController ()

@property (nonatomic, retain) UIBarButtonItem *homeButton;
@property (nonatomic, retain) UIBarButtonItem *backButton;
@property (nonatomic, retain) UIBarButtonItem *forwardButton;
@property (nonatomic, retain) UIBarButtonItem *reloadButton;
@property (nonatomic, retain) UIBarButtonItem *stopButton;
@property (nonatomic, assign) CGFloat currentToolBarHeight;

- (void)setupToolBar;
- (void)setupWebView;
- (void)setupActivityIndicatorView;
- (void)loadWeb;
- (void)toggleToolBar;
- (void)backToApp;

@end

@implementation KMWebViewController

@synthesize toolBar = _toolBar;
@synthesize webView = _webView;
@synthesize indicatorView = _indicatorView;
@synthesize homeButton = _homeButton;
@synthesize backButton = _backButton;
@synthesize forwardButton = _forwardButton;
@synthesize reloadButton = _reloadButton;
@synthesize stopButton = _stopButton;
@synthesize url = _url;
@synthesize hideToolBar = _hideToolBar;
@synthesize currentToolBarHeight = _currentToolBarHeight;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

    if (self.navigationController) {
        CGRect f = self.view.frame;
        f.size.height -= kNavigationBarHeight;
        self.view.frame = f;
    }
    [self setupToolBar];
    [self setupWebView];
    [self setupActivityIndicatorView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self toggleToolBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.url) [self loadWeb];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.toolBar = nil;
    self.webView = nil;
    self.indicatorView = nil;
    self.homeButton = nil;
    self.backButton = nil;
    self.forwardButton = nil;
    self.reloadButton = nil;
    self.stopButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [_toolBar release], _toolBar = nil;
    [_webView release], _webView = nil;
    [_indicatorView release], _indicatorView = nil;
    [_homeButton release], _homeButton = nil;
    [_backButton release], _backButton = nil;
    [_forwardButton release], _forwardButton = nil;
    [_reloadButton release], _reloadButton = nil;
    [_stopButton release], _stopButton = nil;
    [_url release], _url = nil;
    [super dealloc];
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

- (void)setupToolBar
{
    CGRect f = self.view.bounds;
    self.toolBar = [[[UIToolbar alloc] initWithFrame:CGRectMake(f.origin.x, f.size.height - kToolBarHeight, f.size.width, kToolBarHeight)] autorelease];

    self.homeButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"KMWebViewController.bundle/home.png"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapHomeButton:)] autorelease];

    self.backButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"KMWebViewController.bundle/arrow_left.png"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapBackButton:)] autorelease];
    self.backButton.enabled = NO;

    self.forwardButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"KMWebViewController.bundle/arrow_right.png"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapForwardButton:)] autorelease];
    self.forwardButton.enabled = NO;

    self.reloadButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"KMWebViewController.bundle/reload.png"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapReloadButton:)] autorelease];
    self.reloadButton.enabled = NO;

    self.stopButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"KMWebViewController.bundle/cancel.png"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapStopButton:)] autorelease];
    self.stopButton.enabled = NO;

    UIBarItem* space = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    [self.toolBar setItems:[NSArray arrayWithObjects:self.homeButton, space, self.backButton, space, self.forwardButton, space, self.reloadButton, space, self.stopButton, nil]];
    [self.view addSubview:self.toolBar];
    self.toolBar.hidden = YES;
    [self.toolBar setBarStyle:UIBarStyleBlack];
    self.currentToolBarHeight = self.toolBar.frame.size.height;
}

- (void)setupWebView
{
    CGRect f = self.view.bounds;
    self.webView = [[[UIWebView alloc] initWithFrame:CGRectMake(f.origin.x, f.origin.y, f.size.width, f.size.height)] autorelease];
    if (self.toolBar) {
        CGRect wf = self.webView.frame;
        wf.size.height -= self.toolBar.frame.size.height;
        self.webView.frame = wf;
    }
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
}

- (void)setupActivityIndicatorView
{
    self.indicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
    [self.indicatorView setHidesWhenStopped:YES];
    CGRect f = self.indicatorView.frame;
    CGRect wf = self.webView.frame;
    f.origin.x = (wf.size.width - f.size.width) / 2;
    f.origin.y = (wf.size.height - f.size.height) / 2;
    self.indicatorView.frame = f;
    [self.view addSubview:self.indicatorView];
}

- (void)loadWeb
{
    [self.indicatorView startAnimating];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)toggleToolBar
{
    CGRect tf = self.toolBar.frame;
    CGRect wf = self.webView.frame;
    if (self.hideToolBar && self.currentToolBarHeight) {
        tf.size.height -= self.currentToolBarHeight;
        wf.size.height += self.currentToolBarHeight;
    } else if (!self.hideToolBar && !self.currentToolBarHeight) {
        tf.size.height += kToolBarHeight;
        wf.size.height -= kToolBarHeight;
    }
    self.toolBar.frame = tf;
    self.webView.frame = wf;
    self.currentToolBarHeight = self.toolBar.frame.size.height;
    if (self.currentToolBarHeight) self.toolBar.hidden = NO;
}

- (void)backToApp
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    self.backButton.enabled = [self.webView canGoBack];
    self.forwardButton.enabled = [self.webView canGoForward];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.backButton.enabled = [self.webView canGoBack];
    self.forwardButton.enabled = [self.webView canGoForward];
    self.reloadButton.enabled = NO;
    self.stopButton.enabled = YES;
    self.title = kTitleLoading;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.backButton.enabled = [self.webView canGoBack];
    self.forwardButton.enabled = [self.webView canGoForward];
    self.reloadButton.enabled = YES;
    self.stopButton.enabled = NO;
    [self.indicatorView stopAnimating];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.indicatorView stopAnimating];
    [self webViewDidFinishLoad:webView];
}

@end
