//
//  VaultUser.m
//  Vault
//
//  Created by Jace Allison on 1/22/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import "VaultUser.h"

@implementation VaultUser

@synthesize sessionId;
@synthesize responseStatus;

+ (void)saveSession:(NSNumber *)sessionId {
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardDefaults) {
        [standardDefaults setObject:sessionId forKey:@"sessionId"];
        [standardDefaults synchronize];
    }
}

+ (NSNumber *)loadSession:(NSString *)sessionKey {
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *sessionId = nil;
    
    if (standardDefaults)
        sessionId = [standardDefaults objectForKey:sessionKey];
    return sessionId;
}

@end
