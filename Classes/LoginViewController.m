/* 
 * LoginViewController.m
 * Vault
 *
 * Created by Jace Allison on January 21, 2011
 * Last modified on May 24, 2011 by Jace Allison
 *
 * Copyright © 2011-2012 Veeva Systems. All rights reserved.
 *
 * FILE DESCRIPTION
 * 
 * This class contains functions related to having the user
 * manually login by entering his/her credentials.  These functions
 * are performed when the Login View is loaded.  This class DOES NOT
 * contain functions related to refreshing user information after initial
 * login.
 */

#import "LoginViewController.h"

/* Global variable that determines if the user needs to resync documents with Vault */
BOOL initLogin = FALSE;

@implementation LoginViewController

@synthesize emailField;         /* Text field for user to enter username */
@synthesize passwordField;      /* Text field for user to enter password */
@synthesize loginBtn;           /* UIButton that logs the user in */
@synthesize clearBtn;           /* UIButton that clears all text in text boxes */
@synthesize keychain;           /* Keychain object to store user credentials */
@synthesize authManager;        /* RKObjectManager for Vault authentication */


#pragma mark - Memory management functions

/* Release any cached data, images, etc that aren't in use. */

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

/* Uninitialize properties that are no longer being used */

-(void)dealloc
{
    self.emailField = nil;
    self.passwordField = nil;
    self.loginBtn = nil;
    self.clearBtn = nil;
    self.keychain = nil;
    self.authManager = nil;
}


#pragma mark - View lifecycle

/* Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 * This function maps JSON objects to native classes, like applicationdidfinishlaunching does.
 * However, these mappings are only set up for the RKObjectManager authManager in this class.
 */

- (void)viewDidLoad 
{
    
    /* Url for the login page */
    NSURL *authUrl = [NSURL URLWithString:LOGIN_URL];
    
    /* Initialize keychain object for storing user credentials */
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

/* Function that determines which orientations will be supported.  Return YES for all orientations */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	return YES;
}


#pragma mark - RKObjectLoaderDelegate Methods

/* Function called when no request can be sent or recieved from Vault */

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error 
{
    /* If there is an error, show an alert */
    if (error) {
        
        /* Create alert */
        UIAlertView *connectAlert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Could not connect to Vault. You may not be connected to the Internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [connectAlert show];                                    /* Show alert */
    }
    
    /* Make the network activity inidicator in the top menu bar disappear */
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

/* Function that is called when a request is successfully sent and response is recieved from Vault */

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects 
{
    
    VaultUser *user = [objects objectAtIndex:0];            /* Load objects from response */
    
    /* Present an alert if login failed */
    if ([user.responseStatus isEqualToString:FAILURE]) {
        
        /* Create the alert */
        UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Invalid username or password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [loginAlert show];                                  /* Show alert */
        
    }
    
    /* Login was sucessful */
    else {
        [VaultUser saveSession:user.sessionid];             /* Save sessionId */
      
        initLogin = TRUE;                                  /* Set BOOL to show user has just logged in */
        
        /* All loading is finished, so hide the network activity indicator */
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        /* Transistion to main UITabbarControler */
        [self dismissModalViewControllerAnimated:YES];
    }
}


#pragma mark - Touches methods

/* Resign keyboard when the background view is touched anywhere */

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [emailField resignFirstResponder];
    [passwordField resignFirstResponder];
}


#pragma mark - LoginViewController private methods
 
/* Resign keyboard when enter buttong on keyboard is pressed */
 
- (void)hideKeyboard:(id)sender 
{
    [sender resignFirstResponder];
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
    
    /* Add user credentials to keychain */
    [keychain setObject:@"Myappstring" forKey: (__bridge id)kSecAttrService];
    
    [keychain setObject:userLogin.username forKey:(__bridge id)kSecAttrAccount];
    [keychain setObject:userLogin.password forKey:(__bridge id)kSecValueData];
    
    /* Send the POST request to vault */
    [authManager postObject:userLogin delegate:self];
    
    /* Show activity indicator in the devices top menu bar */
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}

@end
