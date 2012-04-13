//
//  LoginViewController.m
//  Vault
//
//  Created by Jace Allison on 12/22/11.
//  Copyright (c) 2011 Issaquah High School. All rights reserved.
//

#import "LoginViewController.h"

/* Global variable that determines if the user needs to resync documents with Vault */
BOOL needToSync = FALSE;

@implementation LoginViewController

@synthesize emailField;
@synthesize passwordField;
@synthesize loginBtn;
@synthesize clearBtn;
@synthesize keychain;
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
    
    [keychain setObject:@"Myappstring" forKey: (__bridge id)kSecAttrService];
    
    [keychain setObject:userLogin.username forKey:(__bridge id)kSecAttrAccount];
    [keychain setObject:userLogin.password forKey:(__bridge id)kSecValueData];

    /* Send the POST request to vault */
    [authManager postObject:userLogin delegate:self];

    /* Show activity indicator in the devices top menu bar */
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

}

/* Release any cached data, images, etc that aren't in use. */

- (void)didReceiveMemoryWarning {
    /* Releases the view if it doesn't have a superview. */
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

/* Implement viewDidLoad to do additional setup after loading the view, typically from a nib */

- (void)viewDidLoad {
    
    /* Url for the login page */
    NSURL *authUrl = [NSURL URLWithString:LOGIN_URL];
    
    keychain = [[KeychainItemWrapper alloc] initWithIdentifier:USER_CRED accessGroup:nil];
    
    /* Set up a unique objectmanager for authentication only when login view loads */
    authManager = [RKObjectManager objectManagerWithBaseURL: authUrl];
    
    authManager.serializationMIMEType = RKMIMETypeFormURLEncoded;
    
    /* Serialize the the AuthUserDetail class to send POST data to vault */
    RKObjectMapping *authSerialMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [authSerialMapping mapAttributes:@"username", @"password", nil];
    
    /* Map the properties of the AuthUserDetail class to POST authentication parameters */
    [authManager.mappingProvider setSerializationMapping:authSerialMapping forClass:[AuthUserDetail class]];
    
    /* Set up a router to route the POST call to the right path for authentication */
    [authManager.router routeClass:[AuthUserDetail class] toResourcePath:@"/auth/api"];
    
    /* Set the mapping attributes to obtain relevent information from Vault */
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[VaultUser class]];
    userMapping.setNilForMissingRelationships = YES;
    [userMapping mapAttributes:@"sessionid", @"responseStatus", nil];
    
    /* Set object mappings */
    [authManager.mappingProvider setObjectMapping:userMapping forResourcePathPattern:@"/auth/api"];
    
    [super viewDidLoad];
}

/* Release any retained subviews of the main view. Also set any initialized attributes to nil */
- (void)viewDidUnload {
    [super viewDidUnload];
}

/* Function that determines which orientations will be supported.  Return YES for all orientations */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

/* Function called when a button is clicked on an alert view in FirstViewController */

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    /* Cancel the login process due to connection failure and return to the main screen */
    if (alertView.tag == CONNECT_ALERT_TAG) {
        if (buttonIndex == CANCEL) {        /* Cancel button pressed */
            [self dismissModalViewControllerAnimated:YES];      /* Go back to home screen */
        }
        
    }
    
    /* Cancel the login process and return to the main screen */
    else if (alertView.tag == LOGIN_ALERT_TAG) {                /* Login failed alert */
        if (buttonIndex == CANCEL) {                            /* Cancel button pressed*/
            [self dismissModalViewControllerAnimated:YES];      /* Go back to main screen */
        }
    }
    
}

/* Function called when no request can be sent or recieved from Vault */

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    
    /* If there is an error, show an alert */
    if (error) {
        
        /* Create alert */
        UIAlertView *connectAlert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Could not connect to Vault. You may not be connected to the Internet" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
        [connectAlert setTag:CONNECT_ALERT_TAG];                /* Set alert identifier to use */
        
        [connectAlert show];                                    /* Show alert */
    }
    
    /* Make the network activity inidicator in the top menu bar disappear */
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    
    VaultUser *user = [objects objectAtIndex:0];            /* Load objects from response */
    
    /* Present an alert if login failed */
    if ([user.responseStatus isEqualToString:FAILURE]) {
        
        /* Create the alert */
        UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Invalid username or password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
        [loginAlert setTag:LOGIN_ALERT_TAG];                /* Set alert identifier to use */
        
        [loginAlert show];                                  /* Show alert */
        
    }
    
    /* Login was sucessful */
    else {
        [VaultUser saveSession:user.sessionid];             /* Save sessionId */
      
        needToSync = TRUE;                                  /* Set BOOL to show user has just logged in */
        
        /* All loading is finished, so hide the network activity indicator */
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        /* Transistion to main UITabbarControler */
        [self dismissModalViewControllerAnimated:YES];
    }
}

@end
