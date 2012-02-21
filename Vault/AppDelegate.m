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


@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSURL *baseUrl = [NSURL URLWithString:@"https://vv1.veevavault.com/api/v1.0"];
   
    /* Set up a general object manager for Vault and make it shraed */
    RKObjectManager *genManager = [RKObjectManager objectManagerWithBaseURL:baseUrl];
   
    /* Ensure that this manager available to everyone */
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
    [documentMapping mapKeyPath:@"contentFile" toAttribute:@"contentFile"];
    [documentMapping mapKeyPath:@"version_modified_date__v" toAttribute:@"dateLastModified"];
    
    [[RKObjectManager sharedManager].mappingProvider setMapping:documentMapping forKeyPath:@"documents.document"];
    
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
    
    if (session != nil) {                                       /* Test to see if the session is still valid */
        [[RKObjectManager sharedManager].client setValue:session forHTTPHeaderField:@"Authorization"];
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/metadata/objects" 
                                                        usingBlock:^(RKObjectLoader *loader) {
                                                            loader.method = RKRequestMethodGET;
                                                            loader.delegate = self;
                                                        }];
    }
    else {      /* If the session is nil, then just present the login view controller */
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *loginScreen = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        loginScreen.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self.window.rootViewController presentModalViewController:loginScreen animated:YES];
    }
        
} 

/*
 * Called when the application is about to terminate.  Save data if appropriate.
 * See also applicationDidEnterBackground:.
 */

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

/* Function called when one cannot connect to Vault */
-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    
}

/* Called when the objects are mapped to a REST response */
- (void) objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    
    SessionTest *test = [objects objectAtIndex:0];                  /* Load the test object */
    if ([test.responseStatus isEqualToString:FAILURE]) {            /* If the test failed */
        
        /* Prompt the user to login */
        UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Login to Vault?" message:@"Your login session has expired, if you would like to login, press the login button" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
        
        [loginAlert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  
    /* If the user presses the login button, present the login page */
    if (buttonIndex == CANCEL + 1) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *loginScreen = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        loginScreen.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self.window.rootViewController presentModalViewController:loginScreen animated:YES];

        
    }
}

@end
