/* 
 * VaultUser.m
 * Vault
 *
 * Created by Jace Allison on February 11, 2012
 * Last modified on May 28, 2012 by Jace Allison
 *
 * Copyright © 2011-2012 Veeva Systems. All rights reserved.
 *
 * FILE DESCRIPTION
 *
 * This file contains properties for a Vault user for sending request. These properties contain a user's session id and
 * a response status to determine a successful request.  This class also contains functions for saving the user's session and 
 * loading the session for later used.
 */


#import "VaultUser.h"

@implementation VaultUser

@synthesize sessionid;              /* Session id for a user give upon login */
@synthesize responseStatus;         /* Response status given for a request */

/*
 * Saves the session string for a user to NSUserDefaults.  This allows the session to be retrieved for 
 * later use.
 *
 * PAREMETER(S)
 *
 * (NSString *)sessionId            The session string to save
 *
 */

+ (void)saveSession:(NSString *)sessionId {
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardDefaults) {
        [standardDefaults setObject:sessionId forKey:@"sessionId"];
        [standardDefaults synchronize];
    }
}


/*
 * Loads the session string for a user that has been previously saved in NSUserDefaults.
 *
 * RETURN VALUE(S)
 *
 * (NSString *)                     Returns a session for a user.
 *
 */

+ (NSString *)loadSession {
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSString *sessionId = nil;
    
    if (standardDefaults)
        sessionId = [standardDefaults objectForKey:@"sessionId"];
    return sessionId;
}

- (void)dealloc
{
    
    sessionid = nil;
    responseStatus = nil;
}

@end
