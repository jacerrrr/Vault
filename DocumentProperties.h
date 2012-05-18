//
//  DocumentProperties.h
//  Vault
//
//  Created by Jace Allison on 5/15/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Document.h"

@interface DocumentProperties : NSObject

@property (nonatomic, strong) NSMutableDictionary *genProperties;
@property (nonatomic, strong) NSMutableDictionary *productInfo;
@property (nonatomic, strong) NSMutableDictionary *sharedSettings;
@property (nonatomic, strong) NSMutableDictionary *supportDocs;
@property (nonatomic, strong) NSMutableDictionary *vHistory;
@property (nonatomic, strong) NSMutableDictionary *userCreated;
@property (nonatomic, strong) NSMutableDictionary *userLastMod;
@property (nonatomic, strong) NSMutableDictionary *sharedUsers;


@end
