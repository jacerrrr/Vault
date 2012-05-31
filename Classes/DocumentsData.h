/* 
 * DocumentsData.h
 * Vault
 *
 * Created by Jace Allison on May 5, 2012
 * Last modified on May 10, 2012 by Jace Allison
 *
 * Copyright © 2011-2012 Veeva Systems. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface DocumentsData : NSObject

@property (nonatomic, strong) NSMutableDictionary *createdUsers;    /* Users ids that created specific documents */
@property (nonatomic, strong) NSMutableDictionary *lastModUsers;    /* Users ids that last modified specific documents */

@end
