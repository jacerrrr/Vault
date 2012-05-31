//
//  VaultSearch.m
//  Vault
//
//  Created by kuwaharg on 5/10/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import "VaultSearch.h"

@implementation VaultSearch

@synthesize responseStatus;
@synthesize responseMessage;
@synthesize columns;
@synthesize resultSet;
@synthesize totalFound;

- (void)dealloc
{
    responseStatus = nil;
    responseMessage = nil;
    columns = nil;
    resultSet = nil;
    totalFound = nil;
}

@end
