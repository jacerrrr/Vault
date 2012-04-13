/* 
 * AppDelegate.h
 * Vault
 *
 * Created by Jace Allison on December 21, 2011
 * Last modified on December 22, 2011 by Jace Allison
 *
 * Copyright 2011 Oregon State University. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import <RestKit/RKJSONParserJSONKit.h>
#import "VaultUser.h"
#import "SessionTest.h"
#import "LoginViewController.h"
#import "Document.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate, RKObjectLoaderDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) KeychainItemWrapper *keychain;
@property (nonatomic) BOOL invalidSession;
@property (nonatomic, retain) RKObjectManager *authManager;
@property (nonatomic) int loginCycle;

- (void)loginWithKeychain;

@end
