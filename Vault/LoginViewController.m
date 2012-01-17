//
//  LoginViewController.m
//  Vault
//
//  Created by Jace Allison on 12/22/11.
//  Copyright (c) 2011 Issaquah High School. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController
@synthesize emailField;
@synthesize passwordField;
@synthesize loginBtn;
@synthesize clearBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)clearFields:(id)sender 
{
    emailField.text = nil;
    passwordField.text = nil;
}

- (IBAction)login:(id)sender {
    [VaultUser loginWithUsername:emailField.text 
                     andPassword:passwordField.text];
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
        if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight
            || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
          
            emailField.frame = CGRectMake(330, 386, 380, 31);
            passwordField.frame = CGRectMake(330, 425, 380, 31);
            loginBtn.frame = CGRectMake(330, 464, 185, 37);
            clearBtn.frame = CGRectMake(524, 464, 185, 37);
        }
    
        else {
            emailField.frame = CGRectMake(218, 486, 332, TEXT_FIELD_HEIGHT);
            passwordField.frame = CGRectMake(218, 525, 332, TEXT_FIELD_HEIGHT);
            loginBtn.frame = CGRectMake(218, 564, 162, 37);
            clearBtn.frame = CGRectMake(388, 564, 162, 37);
            
            
        }
    
}

@end
