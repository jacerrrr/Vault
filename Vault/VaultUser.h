//
//  VaultUser.h
//  Vault
//
//  Created by Jace Allison on 1/22/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface VaultUser : NSObject

@property (nonatomic, retain) NSString *sessionid;          /* Session ID number */
@property (nonatomic, retain) NSString *responseStatus;     /* Status of REST reponse */

+ (void)saveSession:(NSString *)sessionId;
+ (NSString *)loadSession;

@end
