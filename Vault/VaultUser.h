//
//  VaultUser.h
//  Vault
//
//  Created by Jace Allison on 1/22/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>


@interface VaultUser : NSObject

@property (nonatomic, retain) NSNumber *sessionId;
@property (nonatomic, retain) NSString *responseStatus;

+ (void)saveSession:(NSNumber *)sessionId;
+ (NSNumber *)loadSession:(NSString *)sessionKey;

@end
