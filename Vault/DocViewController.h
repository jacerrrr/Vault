//
//  DocViewController.h
//  Vault
//
//  Created by Jace Allison on 2/28/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Document.h"
#import "Constants.h"
#import "DocWebView.h"

@interface DocViewController : UIViewController

@property (nonatomic, retain)  IBOutlet DocWebView *pdfView;
@property (nonatomic, retain) IBOutlet UIToolbar *docToolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;

+ (void) setFileNameToView:(NSString *)filePath;
- (IBAction)finishViewing:(id)sender;
- (IBAction)screenTouched:(id)sender;

@end
