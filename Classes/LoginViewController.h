/* 
 * LoginViewController.h
 * Vault
 *
 * Created by Jace Allison on January 21, 2012
 * Last modified on May 24, 2012 by Jace Allison
 *
 * Copyright © 2011-2012 Veeva Systems. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import <Security/Security.h>
#import "VaultUser.h"
#import "AuthUserDetail.h"
#import "Constants.h"
#import "KeychainItemWrapper.h"

@interface LoginViewController : UIViewController <RKObjectLoaderDelegate>

@property(strong, nonatomic) IBOutlet UITextField *emailField;      /* Text field where user inputs username */
@property(strong, nonatomic) IBOutlet UITextField *passwordField;   /* Text field where user inputs password */
@property(strong, nonatomic) IBOutlet UIButton *loginBtn;           /* Button user presses to login */
@property(strong, nonatomic) IBOutlet UIButton *clearBtn;           /* Button to clear everything in the text fields */
@property(strong, nonatomic) KeychainItemWrapper *keychain;         /* Keychain object to save user credntials securely */
@property (nonatomic, strong) RKObjectManager * authManager;        /* Object Manager for authentication only */

- (IBAction)hideKeyboard:(id)sender;
- (IBAction)clearFields:(id)sender;
- (IBAction)login:(id)sender;

@end

