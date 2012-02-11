/* 
 * AppDelegate.h
 * Vault
 *
 * Created by Jace Allison on December 21, 2011
 * Last modified on December 22, 2011 by Jace Allison
 *
 * Copyright 2011 Oregon State University. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "VaultUser.h"
#import "Document.h"
#import "TableView.h"

@interface FirstViewController : UIViewController <RKObjectLoaderDelegate, UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView* documents;
}

@property (nonatomic, retain) UITableView* documents;                               /* Table view containing documents */
@property (nonatomic, retain) NSMutableDictionary *documentTypes;                   /* Mutable Dictionary containing document types */
@property (nonatomic, retain) NSMutableDictionary *documentNames;                   /* Mutable Dictionary containing document names */
@property (nonatomic, retain) NSMutableDictionary *contentFiles;                    /* Mutable Dictionary containing content files */
@property (nonatomic, retain) NSMutableDictionary *datesModified;                   /* Mutable Dictionary containing  dates modified */
@property (nonatomic) int numOfDocuments;                                           /* The number of documents being retrieved */

- (void) docInfoDidLoad;
@end
