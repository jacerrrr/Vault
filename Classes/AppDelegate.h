/* 
 * AppDelegate.h
 * Vault
 *
 * Created by Jace Allison on December 21, 2011
 * Last modified on May 5, 2012 by Jace Allison
 *
 * Copyright © 2011-2012 Veeva Systems. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import <RestKit/RKJSONParserJSONKit.h>
#import "VaultUser.h"
#import "SessionTest.h"
#import "LoginViewController.h"
#import "Document.h"
#import "DocumentUser.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
