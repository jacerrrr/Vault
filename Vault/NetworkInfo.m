//
//  NetworkInfo.m
//  Vault
//
//  Created by Jace Allison on 1/23/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import "NetworkInfo.h"
#import <SystemConfiguration/SystemConfiguration.h>

@implementation NetworkInfo

-(BOOL)connectedToNetwork {
    BOOL available = NO;
    static BOOL checkNetwork = YES;
    if (checkNetwork) { 
        checkNetwork = NO;
    
        Boolean success;
        const char *host_name = "www.google.com";
    
        SCNetworkReachabilityRef reachability = 
        SCNetworkReachabilityCreateWithName(NULL, host_name);
        SCNetworkReachabilityFlags flags;
        success = SCNetworkReachabilityGetFlags(reachability, &flags);
        available = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
        CFRelease(reachability);
    }
    
    return available;
}

@end
