//
//  VaultUser.h
//  Vault
//
//  Created by Jace Allison on 1/13/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface VaultUser : NSObject <RKRequestDelegate> 

+ (void)loginWithUsername: (NSString *)email andPassword: (NSString *)pass;

@end