/* 
 * DocumentUser.h
 * Vault
 *
 * Created by Jace Allison on January 10, 2012
 * Last modified on May 28, 2012 by Jace Allison
 *
 * Copyright © 2011-2012 Veeva Systems. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface DocumentUser : NSObject

@property (nonatomic, strong) NSString *firstName;      /* The first name of a Vault user */
@property (nonatomic, strong) NSString *lastName;       /* The last name of a Vault user */

@end
