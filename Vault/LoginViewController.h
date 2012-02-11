//
//  LoginViewController.h
//  Vault
//
//  Created by Jace Allison on 12/22/11.
//  Copyright (c) 2011 Issaquah High School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "VaultUser.h"
#import "VaultErrors.h"
#import "AuthUserDetail.h"
#import "Constants.h"

@interface LoginViewController : UIViewController <RKObjectLoaderDelegate>

@property(strong, nonatomic) IBOutlet UITextField *emailField;
@property(strong, nonatomic) IBOutlet UITextField *passwordField;
@property(strong, nonatomic) IBOutlet UIButton *loginBtn;
@property(strong, nonatomic) IBOutlet UIButton *clearBtn;
@property (nonatomic, retain) RKObjectManager * authManager;

- (IBAction)clearFields:(id)sender;
- (IBAction)login:(id)sender;

@end

