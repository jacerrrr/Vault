//
//  VaultUser.m
//  Vault
//
//  Created by Jace Allison on 1/13/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import "VaultUser.h"

@implementation VaultUser

+ (void)loginWithUsername:(NSString *)email andPassword:(NSString *)pass {
    NSArray *vaultAuthNames = [NSArray arrayWithObjects:
                               @"username", @"password", nil];
    NSArray *authKeys = [NSArray arrayWithObjects:email, pass, nil];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjects:
                            vaultAuthNames forKeys:authKeys];
    
    [[RKClient sharedClient] post:@"" params:params delegate:self];
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
    if ([request isPOST]) {
        if ([response isJSON]) 
            NSLog(@"Retrieved JSON: %@", [response bodyAsString]);
    }
}

@end
