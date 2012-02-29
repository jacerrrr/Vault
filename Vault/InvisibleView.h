//
//  InvisibleView.h
//  Vault
//
//  Created by Jace Allison on 2/29/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DocViewController.h"

@interface InvisibleView : UIView

@property (nonatomic, retain) DocViewController *touchController;
@property (nonatomic) int touchesCount;

@end
