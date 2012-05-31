/* 
 * SessionTest.m
 * Vault
 *
 * Created by Jace Allison on February 11, 2012
 * Last modified on May 28, 2012 by Jace Allison
 *
 * Copyright © 2011-2012 Veeva Systems. All rights reserved.
 *
 * FILE DESCRIPTION
 *
 * This class just contains a property that maps to the JSON object response status.  This status will be 
 * SUCCCESS on a successful request and FAILURE on a faled request.
 */

#import "SessionTest.h"

@implementation SessionTest

@synthesize responseStatus;     /* The response status JSON object of a request sent to Vault */

@end
