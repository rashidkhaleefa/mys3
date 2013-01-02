//
//  delegateAppDelegate.h
//  MyS3
//
//  Created by rashid khaleefa on 28/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;
@interface delegateAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginViewController *viewController;
@property (nonatomic, retain) UINavigationController *navigationController;

@end
