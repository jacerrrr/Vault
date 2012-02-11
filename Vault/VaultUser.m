//
//  VaultUser.m
//  Vault
//
//  Created by Jace Allison on 1/22/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import "VaultUser.h"

@implementation VaultUser

@synthesize sessionid;
@synthesize responseStatus;

+ (void)saveSession:(NSString *)sessionId {
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardDefaults) {
        [standardDefaults setObject:sessionId forKey:@"sessionId"];
        [standardDefaults synchronize];
    }
}

+ (NSString *)loadSession {
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSString *sessionId = nil;
    
    if (standardDefaults)
        sessionId = [standardDefaults objectForKey:@"sessionId"];
    return sessionId;
}

@end
