//
//  PropertiesViewController.h
//  Vault
//
//  Created by Jace Allison on 4/18/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropertiesViewController : UITableViewController
    
@property (nonatomic, retain) NSMutableDictionary *generalProperties;
@property (nonatomic, retain) NSString *productInformation;
@property (nonatomic, retain) NSMutableDictionary *shareSettings;
@property (nonatomic, retain) NSArray *supportingDocuments;

@end
