//
//  HomeViewController.m
//  KMWebViewController
//
//  Created by matsuda on 12/02/07.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "KMWebViewController.h"
#import "InheritanceViewController.h"

static NSString *kKMWebViewSampleURL = @"https://github.com/matsuda/KMWebViewController";

@implementation HomeViewController

@synthesize originalButton, inheritanceButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Sample";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.originalButton = nil;
    self.inheritanceButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [originalButton release];
    [inheritanceButton release];
    [super dealloc];
}

- (IBAction)openWebFromOriginalButton:(id)sender
{
    KMWebViewController *controller = [[[KMWebViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    controller.url = kKMWebViewSampleURL;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)openWebFromInheritanceButton:(id)sender
{
    InheritanceViewController *controller = [[[InheritanceViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    controller.url = kKMWebViewSampleURL;
    UINavigationController *naviController = [[[UINavigationController alloc] initWithRootViewController:controller] autorelease];
    [self presentModalViewController:naviController animated:YES];
    // [self presentModalViewController:controller animated:YES];
}

@end
