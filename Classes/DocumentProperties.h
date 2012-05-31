/* 
 * DocumentProperties.h
 * Vault
 *
 * Created by Jace Allison on May 15, 2012
 * Last modified on May 24, 2012 by Jace Allison
 *
 * Copyright © 2011-2012 Veeva Systems. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Document.h"

@interface DocumentProperties : NSObject

@property (nonatomic, strong) NSMutableDictionary *genProperties;   /* Stores dictionary for general properties for a document id key */
@property (nonatomic, strong) NSMutableDictionary *productInfo;     /* Stores dictionary for product info properties for a doument id key */
@property (nonatomic, strong) NSMutableDictionary *sharedSettings;  /* Stores dictionary for shared settings properties for a document id key */
@property (nonatomic, strong) NSMutableDictionary *supportDocs;     /* Stores dictionary for supporting docs properties for a document id key */
@property (nonatomic, strong) NSMutableDictionary *vHistory;        /* Stores dictionary for version history properties for a document id key */
@property (nonatomic, strong) NSMutableDictionary *userCreated;     /* Stores dictionary for name of created user for a document id key */
@property (nonatomic, strong) NSMutableDictionary *userLastMod;     /* Stores dictionary for named of last user for a document id key */
@property (nonatomic, strong) NSMutableDictionary *sharedUsers;     /* Stores dictionary for name of shared users for a document id key */


@end
