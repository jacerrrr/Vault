/* 
 * AppDelegate.h
 * Vault
 *
 * Created by Jace Allison on February 13, 2012
 * Last modified on May 24, 2012 by Jace Allison
 *
 * Copyright © 2011-2012 Veeva Systems. All rights reserved.
 *
 * FILE DESCRIPTION
 *
 * This class just contains two properties which maps to HTTP POST Request with a 
 * username and a password
 */


#import "AuthUserDetail.h"

@implementation AuthUserDetail

@synthesize username;
@synthesize password;

- (void)dealloc
{
    username = nil;
    password = nil;
}
@end
