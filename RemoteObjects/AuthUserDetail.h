/* 
 * AuthUserDetail.h
 * Vault
 *
 * Created by Jace Allison on February 13, 2012
 * Last modified on May 24, 2012 by Jace Allison
 *
 * Copyright © 2011-2012 Veeva Systems. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface AuthUserDetail : NSObject

@property (nonatomic, retain) NSString *username;   /* User name for a Vault user to log in with */
@property (nonatomic, retain) NSString *password;   /* Password for a Vault user to log in with */

@end
