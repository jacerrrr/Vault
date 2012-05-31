/* 
 * DocumentsData.m
 * Vault
 *
 * Created by Jace Allison on May 5, 2012
 * Last modified on May 10, 2012 by Jace Allison
 *
 * Copyright © 2011-2012 Veeva Systems. All rights reserved.
 *
 * FILE DESCRITION
 *
 * This class holds all the data that needs to be saved for a document.
 * 
 * TODO:
 * 
 *  - convert properties from FirstViewController to Documents Data. This will
 *    minimize the number of properties in FirstViewController
 */

#import "DocumentsData.h"

@implementation DocumentsData

@synthesize createdUsers;       /* Dictionary of users who created Vault documents */
@synthesize lastModUsers;       /* Dictionary of users who last modified Vault documents */

/* Preforms initilization of a class object.  Initializes all properties so they can be used
 *
 * RETURN VALUE(S)
 *
 *  id          object with properly initialized properties 
 */

- (id)init 
{
    
    if (self = [super init]) {
        self.createdUsers = [NSMutableDictionary dictionary];
        self.lastModUsers = [NSMutableDictionary dictionary];
    }
    
    return self;
}

/* Uninitialize properties that are no longer used */

-(void)dealloc 
{
    createdUsers = nil;
    lastModUsers = nil;
}
@end
