/* 
 * DocumentProperties.m
 * Vault
 *
 * Created by Jace Allison on May 15, 2012
 * Last modified on May 24, 2012 by Jace Allison
 *
 * Copyright © 2011-2012 Veeva Systems. All rights reserved.
 *
 * FILE DESCRIPTION
 *
 * This class holds all the properties that pertain to a specific document.  
 * The class contains functions to initilized and uninitilize these properties.
 */

#import "DocumentProperties.h"

@implementation DocumentProperties

@synthesize genProperties;  /* Dictionary to contain a dictionary of general properties for key document id */
@synthesize productInfo;    /* Dictionary to contain a dictionary of product info for key document id */
@synthesize sharedSettings; /* Dictionary to contain a dictionary of shared settings for key document id */
@synthesize supportDocs;    /* Dictionary to contain a dictionary of supporting docs for key document id */
@synthesize vHistory;       /* Dictionary to contain a dictionary of version history for key document id */
@synthesize userCreated;    /* Dictionary to contain name of created user for key document id */
@synthesize userLastMod;    /* Dictionary to contain name of last modified user for key document id */
@synthesize sharedUsers;    /* Dictionary to contain a dictionary of names of shared users for key document id */

/* Initialize all properties when a DocumentProperties class object is initilized
 
 * RETURN VALUE(S)
 *
 *  id          object with properly initialized properties 
 */

- (id)init 
{
    if (self = [super init]) {
        self.genProperties = [[NSMutableDictionary alloc] initWithDictionary:[Document loadDocInfoForKey:GEN_PROPERTIES]];
        self.productInfo = [NSMutableDictionary dictionary];
        self.sharedSettings = [NSMutableDictionary dictionary];
        self.supportDocs = [NSMutableDictionary dictionary];
        self.vHistory = [NSMutableDictionary dictionary];
        self.userCreated = [NSMutableDictionary dictionary];
        self.userLastMod = [NSMutableDictionary dictionary];
        self.sharedUsers = [NSMutableDictionary dictionary];
    }
    
    return self;
}

/* Uninitialize any unused properties */

- (void)dealloc 
{
    self.genProperties = nil;
    self.productInfo = nil;
    self.sharedSettings = nil;
    self.supportDocs = nil;
    self.vHistory = nil;
    self.userCreated = nil;
    self.userLastMod = nil;
    self.sharedUsers = nil;
}
    
@end
