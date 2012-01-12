//
//  LoginViewController.h
//  Vault
//
//  Created by Jace Allison on 12/22/11.
//  Copyright (c) 2011 Issaquah High School. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property(strong, nonatomic) IBOutlet UITextField *emailField;
@property(strong, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)clearFields:(id)sender;
- (IBAction)login:(id)sender;

@end
