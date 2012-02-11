//
//  TableView.h
//  Vault
//
//  Created by Jeremy on 1/31/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface TableView : UITableViewCell {
	UIColor *lineColor;
	UILabel *docTypeImage;
	UILabel *docName;
	UILabel *docType;
    UILabel *docLastModified;
}
@property (nonatomic, retain) UIColor* lineColor;
@property (readonly) UILabel* docTypeImage;
@property (readonly) UILabel* docName;
@property (readonly) UILabel* docType;
@property (readonly) UILabel* docLastModified;

@end
