/* 
 * DocumentUser.m
 * Vault
 *
 * Created by Jace Allison on January 10, 2012
 * Last modified on May 28, 2012 by Jace Allison
 *
 * Copyright © 2011-2012 Veeva Systems. All rights reserved.
 *
 * FILE DESCRIPTION
 *
 * This file contains properties which map to JSON objects that give a Vault user's information when
 * a request is sent to Vault with a user id.
 */

#import "DocumentUser.h"

@implementation DocumentUser

@synthesize firstName;          /* The first name of a Vault user */
@synthesize lastName;           /* The last name of a Vault user */

@end
