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
@synthesize authManager;

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
        
    /* Created an instance of a user to send user credentials to vault */
    AuthUserDetail *userLogin = [[AuthUserDetail alloc] init];
    userLogin.username =emailField.text;
    userLogin.password = passwordField.text;
    
    RKObjectMapping *responseMapping = [authManager.mappingProvider objectMappingForClass:[VaultUser class]];
    
    /* Send the POST request to vault */
    [authManager postObject:userLogin mapResponseWith:responseMapping delegate:self];

}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    
    if (error) {
        NSLog(@"Error is: %@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not connect to Veeva Vault" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    VaultUser *user = [objects objectAtIndex:0];

    NSLog(@"Here is type %@", user.errors.type);    
    /* Present an alert if login failed */
    if ([user.responseStatus isEqualToString:FAILURE]) {
   
    }
    
    else {      /* Login was sucessful */
        
        /* Save the sessionId for later use */
       // [VaultUser saveSession:user.sessionid];
    }
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


/* Implement viewDidLoad to do additional setup after loading the view, typically from a nib */
- (void)viewDidLoad
{
    /* Set up a unique objectmanager for authentication only when login view loads */
    authManager = [RKObjectManager objectManagerWithBaseURL:
                                    @"https://login.veevavault.com"];
    
    authManager.serializationMIMEType = RKMIMETypeFormURLEncoded;
    
    /* Serialize the the AuthUserDetail class to send POST data to vault */
    RKObjectMapping *authSerialMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [authSerialMapping mapAttributes:@"username", @"password", nil];
    
    /* Map the properties of the AuthUserDetail class to POST authentication parameters */
    [authManager.mappingProvider setSerializationMapping:authSerialMapping forClass:[AuthUserDetail class]];
    
    /* Set up a router to route the POST call to the right path for authentication*/
    [authManager.router routeClass:[AuthUserDetail class] toResourcePath:@"/auth/api"];
    
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[VaultErrors class]];
    errorMapping.setNilForMissingRelationships = YES;
    [errorMapping mapAttributes:@"type", @"message", nil];
    
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[VaultUser class]];
    userMapping.setNilForMissingRelationships = YES;
    [userMapping mapAttributes:@"sessionid", @"responseStatus", nil];
    
    [userMapping mapKeyPath:@"errors" toRelationship:@"errors" withMapping:errorMapping];
    
    [authManager.mappingProvider setMapping:userMapping forKeyPath:@""];
    [authManager.mappingProvider setErrorMapping:errorMapping];
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
