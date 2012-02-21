//
//  LoginViewController.m
//  Vault
//
//  Created by Jace Allison on 12/22/11.
//  Copyright (c) 2011 Issaquah High School. All rights reserved.
//

#import "LoginViewController.h"

BOOL needToSync = FALSE;

@implementation LoginViewController
@synthesize emailField;
@synthesize passwordField;
@synthesize loginBtn;
@synthesize clearBtn;
@synthesize authManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/* Function to clear all fields in the text boxes on the Login screen */

- (IBAction)clearFields:(id)sender 
{
    emailField.text = nil;
    passwordField.text = nil;
}

/* Function that sends a login request to Veeva Vault */
- (IBAction)login:(id)sender {
        
    /* Created an instance of a user to send user credentials to vault */
    AuthUserDetail *userLogin = [[AuthUserDetail alloc] init];
    userLogin.username =emailField.text;
    userLogin.password = passwordField.text;
    
    /* Send the POST request to vault */
    [authManager postObject:userLogin delegate:self];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

}

/* Release any cached data, images, etc that aren't in use. */

- (void)didReceiveMemoryWarning
{
    /* Releases the view if it doesn't have a superview. */
    [super didReceiveMemoryWarning];
    
   
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


/* Implement viewDidLoad to do additional setup after loading the view, typically from a nib */
- (void)viewDidLoad
{
    NSURL *authUrl = [NSURL URLWithString:@"https://login.veevavault.com"];
    
    /* Set up a unique objectmanager for authentication only when login view loads */
    authManager = [RKObjectManager objectManagerWithBaseURL: authUrl];
    
    authManager.serializationMIMEType = RKMIMETypeFormURLEncoded;
    
    /* Serialize the the AuthUserDetail class to send POST data to vault */
    RKObjectMapping *authSerialMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [authSerialMapping mapAttributes:@"username", @"password", nil];
    
    /* Map the properties of the AuthUserDetail class to POST authentication parameters */
    [authManager.mappingProvider setSerializationMapping:authSerialMapping forClass:[AuthUserDetail class]];
    
    /* Set up a router to route the POST call to the right path for authentication*/
    [authManager.router routeClass:[AuthUserDetail class] toResourcePath:@"/auth/api"];
    
    /* Set the mapping attributes to obtain relevent information from Vault */
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[VaultUser class]];
    userMapping.setNilForMissingRelationships = YES;
    [userMapping mapAttributes:@"sessionid", @"responseStatus", nil];
    
    [authManager.mappingProvider setObjectMapping:userMapping forResourcePathPattern:@"/auth/api"];
    
    [super viewDidLoad];
}


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
    
    /* How to align the login page when in Landscape Orientation */
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight
            || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
          
        emailField.frame = CGRectMake(330, 386, 380, TEXT_FIELD_HEIGHT);
        passwordField.frame = CGRectMake(330, 425, 380, TEXT_FIELD_HEIGHT);
        loginBtn.frame = CGRectMake(330, 464, 185, 37);
        clearBtn.frame = CGRectMake(524, 464, 185, 37);
    }
    
    /* Align for Portrait Orientation */
    else {
        emailField.frame = CGRectMake(218, 486, 332, TEXT_FIELD_HEIGHT);
        passwordField.frame = CGRectMake(218, 525, 332, TEXT_FIELD_HEIGHT);
        loginBtn.frame = CGRectMake(218, 564, 162, 37);
        clearBtn.frame = CGRectMake(388, 564, 162, 37);
            
            
        }
    
}

/* Function called when a button is clicked on an alert view in FirstViewController */

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    /* Cancel the login process due to connection failure and return to the main screen */
    if (alertView.tag == CONNECT_ALERT_TAG) {
        if (buttonIndex == CANCEL) {
            [self dismissModalViewControllerAnimated:YES];
        }
        
    }
    
    /* Cancel the login process and return to the main screen */
    else if (alertView.tag == LOGIN_ALERT_TAG) {
        if (buttonIndex == CANCEL) {
            [self dismissModalViewControllerAnimated:YES];
        }
    }
    
}

/* Function called when no request can be sent or recieved from Vault */

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    
    /* If there is an error, show an alert */
    if (error) {
        
        /* Create alert */
        UIAlertView *connectAlert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Could not connect to Vault. You may not be connected to the Internet" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
        [connectAlert setTag:CONNECT_ALERT_TAG];
        
        [connectAlert show];                                /* Show alert */
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    
    VaultUser *user = [objects objectAtIndex:0];            /* Load objects from response */
    
    /* Present an alert if login failed */
    if ([user.responseStatus isEqualToString:FAILURE]) {
        
        UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Invalid username or password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
        [loginAlert setTag:LOGIN_ALERT_TAG];
        
        [loginAlert show];
        
    }
    
    else {      /* Login was sucessful */
        [VaultUser saveSession:user.sessionid];             /* Save sessionId */
      
        needToSync = TRUE;                                  /* Set BOOL to show user has just logged in */
    
        /* Transistion to main UITabbarControler */
        [self dismissModalViewControllerAnimated:YES];
        
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

@end
