//
//  DocumentsData.m
//  Vault
//
//  Created by Jace Allison on 5/16/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import "DocumentsData.h"

@implementation DocumentsData

@synthesize createdUsers;
@synthesize lastModUsers;

- (id)init {
    
    if (self = [super init]) {
        self.createdUsers = [NSMutableDictionary dictionary];
        self.lastModUsers = [NSMutableDictionary dictionary];
    }
    
    return self;
}

@end
