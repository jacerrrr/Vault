//
//  DocumentProperties.m
//  Vault
//
//  Created by Jace Allison on 5/15/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import "DocumentProperties.h"

@implementation DocumentProperties

@synthesize genProperties;
@synthesize productInfo;
@synthesize sharedSettings;
@synthesize supportDocs;
@synthesize vHistory;
@synthesize userCreated;
@synthesize userLastMod;
@synthesize sharedUsers;

- (id)init {
    if (self = [super init]) {
        self.genProperties = [[NSMutableDictionary alloc] initWithDictionary:[Document loadDocInfoForKey:GEN_PROPERTIES]];
        self.productInfo = [NSMutableDictionary dictionary];
        self.sharedSettings = [NSMutableDictionary dictionary];
        self.supportDocs = [NSMutableDictionary dictionary];
        self.vHistory = [NSMutableDictionary dictionary];
        self.userCreated = [NSMutableDictionary dictionary];
        self.userLastMod = [NSMutableDictionary dictionary];
        self.sharedUsers = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)dealloc {
    self.genProperties = nil;
    self.productInfo = nil;
    self.sharedSettings = nil;
    self.supportDocs = nil;
    self.vHistory = nil;
    self.userCreated = nil;
    self.userLastMod = nil;
    self.sharedUsers = nil;
}
    
@end
