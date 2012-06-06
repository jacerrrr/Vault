//
//  TableView.h
//  Vault
//
//  Created by Jeremy on 1/31/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "FirstViewController.h"

@interface TableView : UITableViewCell {
	UIColor *lineColor;
	UIImageView *docTypeImage;
	UILabel *docName;
	UILabel *docType;
    UILabel *docLastModified;
    UIButton *downloadButton;
}

@property (nonatomic, strong) UIColor* lineColor;
@property (readonly) UIImageView* docTypeImage;
@property (readonly) UILabel* docName;
@property (readonly) UILabel* docType;
@property (readonly) UILabel* docLastModified;
@property (nonatomic, strong) UIButton* downloadButton;

@end
