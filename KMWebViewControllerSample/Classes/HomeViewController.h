//
//  HomeViewController.h
//  KMWebViewController
//
//  Created by matsuda on 12/02/07.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIButton *originalButton;
@property (nonatomic, retain) IBOutlet UIButton *inheritanceButton;

- (IBAction)openWebFromOriginalButton:(id)sender;
- (IBAction)openWebFromInheritanceButton:(id)sender;

@end
