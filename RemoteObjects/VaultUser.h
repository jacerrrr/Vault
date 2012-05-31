/* 
 * VaultUser.h
 * Vault
 *
 * Created by Jace Allison on February 11, 2012
 * Last modified on May 28, 2012 by Jace Allison
 *
 * Copyright © 2011-2012 Veeva Systems. All rights reserved.
 */


#import <Foundation/Foundation.h>
#import "Constants.h"

@interface VaultUser : NSObject

@property (nonatomic, retain) NSString *sessionid;          /* Session ID number */
@property (nonatomic, retain) NSString *responseStatus;     /* Status of REST reponse */

+ (void)saveSession:(NSString *)sessionId;
+ (NSString *)loadSession;

@end
