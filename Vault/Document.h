//
//  Document.h
//  Vault
//
//  Created by Jace Allison on 2/8/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Document : NSObject

@property (nonatomic, retain) NSString *documentId;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *contentFile;
@property (nonatomic, retain) NSString *dateLastModified;

@end
