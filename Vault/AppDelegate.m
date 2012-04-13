/* 
 * AppDelegate.h
 * Vault
 *
 * Created by Jace Allison on December 21, 2011
 * Last modified on December 22, 2011 by Jace Allison
 *
 * Copyright 2011 Oregon State University. All rights reserved.
 */

#import "AppDelegate.h"

extern BOOL needToSync;

@implementation AppDelegate

@synthesize window = _window;
@synthesize keychain;
@synthesize invalidSession;
@synthesize authManager;
@synthesize loginCycle;

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSURL *baseUrl = [NSURL URLWithString:BASE_URL];
    NSURL *authUrl = [NSURL URLWithString:LOGIN_URL];
    
    invalidSession = NO;
    keychain = [[KeychainItemWrapper alloc] initWithIdentifier:USER_CRED accessGroup:nil];
    loginCycle = 0;
    
    /* Set up a general object manager for Vault and make it shraed */
    RKObjectManager *genManager = [RKObjectManager objectManagerWithBaseURL:baseUrl];
    [RKObjectManager setSharedManager:genManager]; 
    
    /* Map the response status for determining if a session is still valid */
    RKObjectMapping *sessionTestMapping = [RKObjectMapping mappingForClass:[SessionTest class]];
    [sessionTestMapping mapAttributes:@"responseStatus", nil];
    [[RKObjectManager sharedManager].mappingProvider setObjectMapping:sessionTestMapping 
                                               forResourcePathPattern:@"/metadata/objects"];
    
    /* Map the document attributes for requests retrieving document information */
    RKObjectMapping *documentMapping = [RKObjectMapping mappingForClass:[Document class]];
    [documentMapping mapKeyPath:@"id" toAttribute:@"documentId"];
    [documentMapping mapKeyPath:@"type__v" toAttribute:@"type"];
    [documentMapping mapKeyPath:@"name__v" toAttribute:@"name"];
    [documentMapping mapKeyPath:@"format__v" toAttribute:@"format"];
    [documentMapping mapKeyPath:@"version_modified_date__v" toAttribute:@"dateLastModified"];
    
    [[RKObjectManager sharedManager].mappingProvider setMapping:documentMapping forKeyPath:@"documents.document"];
    
    /* Set up a authorization object manager to refresh user sessions */
    authManager = [RKObjectManager objectManagerWithBaseURL:authUrl];
    authManager.serializationMIMEType = RKMIMETypeFormURLEncoded;
    
    /* Serialize the the AuthUserDetail class to send POST data to vault */
    RKObjectMapping *authSerialMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [authSerialMapping mapAttributes:@"username", @"password", nil];
    
    /* Set the mapping attributes to obtain relevent information from Vault */
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[VaultUser class]];
    userMapping.setNilForMissingRelationships = YES;
    [userMapping mapAttributes:@"sessionid", @"responseStatus", nil];
    
    /* Set object mappings */
    [authManager.mappingProvider setObjectMapping:userMapping forResourcePathPattern:@"/auth/api"];
    
    /* Map the properties of the AuthUserDetail class to POST authentication parameters */
    [authManager.mappingProvider setSerializationMapping:authSerialMapping forClass:[AuthUserDetail class]];
    
    /* Set up a router to route the POST call to the right path for authentication */
    [authManager.router routeClass:[AuthUserDetail class] toResourcePath:@"/auth/api"];
    
    /* Set the parser for the application to work with type text/html */
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];
    
    return YES;
}

/*
 * Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary 
 * interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins 
 * the transition to the background state.  Use this method to pause ongoing tasks, disable timers, and throttle
 * down OpenGL ES frame rates. Games should use this method to pause the game.
 */

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

/*
 * Use this method to release shared resources, save user data, invalidate timers, and store enough application state
 * information to restore your application to its current state in case it is terminated later. 
 * If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
 */

- (void)applicationDidEnterBackground:(UIApplication *)application {
   
}

/*
 * Called as part of the transition from the background to the inactive state; here you can undo many of the changes
 * made on entering the background.
 */

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

 /*
  * Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was
  * previously in the background, optionally refresh the user interface.
  */

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    NSString *session = [VaultUser loadSession];                /* Load last session */
    
    if (session == nil) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *loginScreen = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        loginScreen.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self.window.rootViewController presentModalViewController:loginScreen animated:YES];
    }
    
    else {                                       /* Test to see if the session is still valid */
        [[RKObjectManager sharedManager].client setValue:session forHTTPHeaderField:@"Authorization"];
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/metadata/objects" 
                                                        usingBlock:^(RKObjectLoader *loader) {
                                                            loader.method = RKRequestMethodGET;
                                                            loader.delegate = self;
                                                        }];
    }
        
} 

/*
 * Called when the application is about to terminate.  Save data if appropriate.
 * See also applicationDidEnterBackground:.
 */

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
    NSLog(@"String is %@", [response bodyAsString]);
}

/* Function called when one cannot connect to Vault */

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    
}

/* Called when the objects are mapped to a REST response */

- (void) objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    
    SessionTest *test = [objects objectAtIndex:0];                  /* Load the test object */
    
    if ([test.responseStatus isEqualToString:FAILURE]){ /* If the test failed */
        
        invalidSession = YES;
        loginCycle++;
        [self loginWithKeychain];
    }
    
    else if ([test.responseStatus isEqualToString:FAILURE] 
             && invalidSession == YES 
             && loginCycle == 1) {
        
        loginCycle++;
        
        /* Create the alert */
        UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"You username and/or password has changed! Please enter you new credentials" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [loginAlert show]; 
    }
    
    else if (invalidSession == YES && (loginCycle == 1 || loginCycle == 2)) {
        loginCycle = 0;
        invalidSession = NO;
        VaultUser *user = [objects objectAtIndex:0];
       
        if (![user.sessionid isEqualToString:[VaultUser loadSession]])
            [VaultUser saveSession:user.sessionid];
        
        needToSync = TRUE;
    }
}

/* This function determines the action that should be taken when a user clicks a button
 * on a alert view.  In this case, the alert view is prompting the user to login.
 */

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
        
    /* Load the login page */
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *loginScreen = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
    loginScreen.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.window.rootViewController presentModalViewController:loginScreen animated:YES];
}

- (void)loginWithKeychain {
    
    /* Created an instance of a user to send user credentials to vault */
    AuthUserDetail *userLogin = [[AuthUserDetail alloc] init];
    userLogin.username = [keychain objectForKey:(__bridge id)kSecAttrAccount];
    userLogin.password = [keychain objectForKey:(__bridge id)kSecValueData];
    
    /* Send the POST request to vault */
    [authManager postObject:userLogin delegate:self];
    
    /* Show activity indicator in the devices top menu bar */
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


@end
