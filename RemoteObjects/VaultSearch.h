//
//  VaultSearch.h
//  Vault
//
//  Created by kuwaharg on 5/10/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

/* Example VaultSearch response
 
{"responseStatus":"SUCCESS",
 "responseMessage":"OK",
 "errorType":null,
 "errors":null,
 "find":"*sam*",
 "limit":1000,
 "offset":0,
 "size":1,
 "totalFound":1,
 "columns":[
        "name__v",
        "id"
 ],
 "resultSet":[
        {"values":[
            "Sample Project Plan",
            "3"
        ]}
 ]}
 */

#import <Foundation/Foundation.h>

@interface VaultSearch : NSObject

@property (nonatomic, strong) NSString *responseStatus;
@property (nonatomic, strong) NSString *responseMessage;
@property (nonatomic, strong) NSObject *columns;
@property (nonatomic, strong) NSArray *resultSet;
@property (nonatomic, strong) NSString *totalFound;

@end
