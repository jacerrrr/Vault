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

@property (nonatomic, retain) NSString *responseStatus;
@property (nonatomic, retain) NSString *responseMessage;
@property (nonatomic, retain) NSObject *columns;
@property (nonatomic, retain) NSArray *resultSet;
@property (nonatomic, retain) NSString *totalFound;

@end
